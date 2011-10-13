//
//  SolyarisViewController.m
//  Solyaris
//
//  Created by CNPP on 16.6.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SolyarisViewController.h"
#import "SolyarisAppDelegate.h"
#import "DataNode.h"
#import "Solyaris.h"
#import "SolyarisConstants.h"
#import "SplashView.h"
#import "Tracker.h"


/**
 * Helper Stack.
 */
@interface SolyarisViewController (HelperStack)
- (NSString*)makeNodeId:(NSNumber*)nid type:(NSString*)type;
- (NSString*)makeEdgeId:(NSString*)pid to:(NSString*)cid;
- (NSNumber*)toDBId:(NSString*)nid;
@end

/**
 * Animation Stack.
 */
@interface SolyarisViewController (AnimationHelpers)
- (void)animationInformationShow;
- (void)animationInformationShowDone;
- (void)animationInformationHide;
- (void)animationInformationHideDone;
- (void)animationSettingsShow;
- (void)animationSettingsShowDone;
- (void)animationSettingsHide;
- (void)animationSettingsHideDone;
@end




/**
 * Solyaris ViewController.
 */
@implementation SolyarisViewController


#pragma mark -
#pragma mark Constants

// constants
#define kAnimateTimeInformationShow	0.6f
#define kAnimateTimeInformationHide	0.45f
#define kAnimateTimeSettingsShow	0.6f
#define kAnimateTimeSettingsHide	0.3f
#define kOffsetSettings 480


#pragma mark -
#pragma mark Properties

// accessors
@synthesize solyaris;



#pragma mark -
#pragma mark Object Methods

/**
 * Init.
 */
- (id)init {
	
	// init super
	if ((self = [super init])) {
		GLog();
        
        // api
        tmdb = [[TMDb alloc] init];
        tmdb.delegate = self;
        
        // mode
        mode_settings = NO;
        
		// return
		return self;
	}
	
	// nil not nile
	return nil;
}



#pragma mark -
#pragma mark View lifecycle

/*
 * Loads the view.
 */
-(void)loadView {
	[super loadView];
	FLog();
    
    // orientation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    // window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // frames
    CGRect frame = CGRectMake(0, 0, 768, 1024);
    CGRect frameSearch = CGRectMake(0, 0, frame.size.width, 40);
    CGRect frameSearchResult = CGRectMake(0, 0, 320, 480);
    CGRect frameInformation = CGRectMake(0, 0, 580, 625);
    CGRect frameSettings = CGRectMake(0, 0, 708, kOffsetSettings);
    CGRect frameSettingsButton = CGRectMake(frame.size.width-44, frame.size.height-44, 44, 44);
    
    // view
    self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.opaque = NO;
    [window addSubview:self.view];
    
    
    // background
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
    bgView.opaque = NO;
    [window addSubview:bgView];
    [window sendSubviewToBack:bgView];
    [bgView release];
    
    
    // search
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithFrame:frameSearch];
    searchViewController.delegate = self;
    [searchViewController loadView];
    _searchViewController = [searchViewController retain];
    [self.view addSubview:_searchViewController.view];
    [self.view bringSubviewToFront:_searchViewController.view];
    [searchViewController release];
    
    
    
    // search result
    SearchResultViewController *searchResultViewController = [[SearchResultViewController alloc] initWithStyle:UITableViewStylePlain];
    searchResultViewController.delegate = self;
    searchResultViewController.view.frame = frameSearchResult;
	[searchResultViewController.view setAutoresizingMask: UIViewAutoresizingNone];
	_searchResultViewController = [searchResultViewController retain];
    
    
	UINavigationController *searchResultNavigationController = [[UINavigationController alloc] initWithRootViewController:searchResultViewController];
	UIPopoverController *searchResultPopoverController = [[UIPopoverController alloc] initWithContentViewController:searchResultNavigationController];
	[searchResultPopoverController setPopoverContentSize:CGSizeMake(searchResultViewController.view.frame.size.width, searchResultViewController.view.frame.size.height)];
    searchResultPopoverController.contentViewController.view.alpha = 0.9f;
    searchResultPopoverController.delegate = self;
	_searchResultsPopoverController = [searchResultPopoverController retain];
	[searchResultPopoverController release];

    
    // information
    InformationViewController *informationViewController = [[InformationViewController alloc] initWithFrame:frameInformation];
    informationViewController.delegate = self;
    [informationViewController loadView];
    _informationViewController = [informationViewController retain];
    [self.view  addSubview:_informationViewController.view];
    [self.view  sendSubviewToBack:_informationViewController.view];
    [informationViewController release];
    
    
    // settings
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithFrame:frameSettings];
    settingsViewController.delegate = self;
    [settingsViewController loadView];
    _settingsViewController = [settingsViewController retain];
    [self.view  addSubview:_settingsViewController.view];
    [self.view  sendSubviewToBack:_settingsViewController.view];
    [settingsViewController release];
    

    // button settings
	UIButton *btnSettings = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnSettings.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
	btnSettings.frame = frameSettingsButton;
	[btnSettings setImage:[UIImage imageNamed:@"btn_settings.png"] forState:UIControlStateNormal];
	[btnSettings addTarget:self action:@selector(actionSettings:) forControlEvents:UIControlEventTouchUpInside];
    _buttonSettings = [btnSettings retain];
	[self.view  addSubview:_buttonSettings];
    [btnSettings release];
    
    
    // fluff cinder view
    for (UIView *subview in window.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"CinderViewCocoaTouch")]) {
            _cinderView = (CinderViewCocoaTouch*) [subview retain];
            break;
        }
    }
    
    // splash
    SplashView *splash = [[[SplashView alloc] initWithFrame:frame] autorelease];
    [self.view addSubview:splash];
    [self.view bringSubviewToFront:splash];
    [splash dismissSplash];


}


#pragma mark -
#pragma mark Rotation support

/*
 * Rotate is the new black.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // maybe baby
    return ! mode_settings;
}

/*
 * Prepare rotation.
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    FLog();
    
    // close popups
    [_searchResultsPopoverController dismissPopoverAnimated:NO];

}


/*
 * Prepare rotation animation.
 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // app
    solyaris->applyDeviceOrientation(toInterfaceOrientation);
    
    // animate cinder
    [UIView beginAnimations:@"flip" context:nil];
    [UIView setAnimationDuration:0]; // animation distorts view
    
    // flip 
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {      
        _cinderView.transform = CGAffineTransformIdentity;
        _cinderView.transform = CGAffineTransformMakeRotation(0);
        _cinderView.bounds = CGRectMake(0.0, 0.0, 768, 1024);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {      
        _cinderView.transform = CGAffineTransformIdentity;
        _cinderView.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        _cinderView.bounds = CGRectMake(0.0, 0.0, 1024, 768);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {      
        _cinderView.transform = CGAffineTransformIdentity;
        _cinderView.transform = CGAffineTransformMakeRotation(M_PI);
        _cinderView.bounds = CGRectMake(0.0, 0.0, 768, 1024);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {      
        _cinderView.transform = CGAffineTransformIdentity;
        _cinderView.transform = CGAffineTransformMakeRotation(- M_PI * 0.5);
        _cinderView.bounds = CGRectMake(0.0, 0.0, 1024, 768);
    }
    [UIView commitAnimations];
    
    // resize
    [_searchViewController resize];
    [_informationViewController resize];
}


/*
 * Cleanup rotation.
 */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // resize
    [_searchViewController resize];
    [_informationViewController resize];
    
}


#pragma mark -
#pragma mark Touch

/*
 * Touches.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    
    // forward to cinder
    [_cinderView touchesBegan:touches withEvent:event]; 
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    
    // forward to cinder
    [_cinderView touchesMoved:touches withEvent:event]; 
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    GLog();
    
    // forward to cinder
    [_cinderView touchesEnded:touches withEvent:event]; 
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    
    // forward to cinder
    [_cinderView touchesCancelled:touches withEvent:event]; 
}



#pragma mark -
#pragma mark API Delegate

/*
 * Loaded search.
 */
- (void)loadedSearch:(Search*)result {
    DLog();
    
    // results
    [_searchResultViewController searchResultShow:result];
    
}


/*
 * Loaded movie.
 */
- (void)loadedMovie:(Movie*)movie {
    DLog();
    
    // node
    NSString *nid = [self makeNodeId:movie.mid type:typeMovie];
    NodePtr node = solyaris->getNode([nid UTF8String]);
    
    // check
    if (node != NULL) {
        
        // formatter
        static NSDateFormatter *yearFormatter;
        if (yearFormatter == nil) {
            yearFormatter = [[NSDateFormatter alloc] init];
            [yearFormatter setDateFormat:@"yyyy"];
        }
        
        // properties
        node->renderLabel([movie.name UTF8String]);
        if (movie.released) {
            node->updateMeta([[yearFormatter stringFromDate:movie.released] UTF8String]);
        }
        
        
        // actors
        NSSortDescriptor *psorter = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        NSArray *persons = [[movie.persons allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:psorter]];
        [psorter release];
        
        // enablers
        bool crew_enabled = [(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefaultBool:udGraphNodeCrewEnabled];
        
        // create nodes
        for (Movie2Person *m2p in persons) {
            
            // exclude crew
            if (! crew_enabled && [m2p.person.type isEqualToString:typePersonCrew]) {
                continue;
            }
            
            // child
            NSString *cid = [self makeNodeId:m2p.person.pid type:typePerson];
            NodePtr child = solyaris->getNode([cid UTF8String]);
            bool existing = true;
            if (child == NULL) {
                existing = false;
                 
                // new child
                child = solyaris->createNode([cid UTF8String],[typePerson UTF8String], node->pos.x, node->pos.y);
                child->renderLabel([m2p.person.name UTF8String]);
                child->updateType([m2p.person.type UTF8String]);
            }
            
            // add to node
            node->addChild(child);
            
            // create edge
            EdgePtr edge = solyaris->getEdge([nid UTF8String], [cid UTF8String]);
            if (edge == NULL) {
                
                // this is the edge
                NSString *eid = [self makeEdgeId:nid to:cid];
                edge = solyaris->createEdge([eid UTF8String],[typePerson UTF8String],node,child);
                
                // type
                edge->updateType([m2p.type UTF8String]);
                
                // label
                NSString *clabel = m2p.character;
                if ([m2p.type isEqualToString:typePersonDirector] || [m2p.type isEqualToString:typePersonCrew]) {
                    clabel = m2p.job;
                }
                
                // render
                edge->renderLabel([clabel UTF8String]);
            }
            if (existing) {
                edge->show();
            }
            
        }
        
        
        // loaded
        node->loaded();
        
    }

}



/*
 * Loaded person.
 */
- (void)loadedPerson:(Person*)person {
    DLog();
    
    // node
    NSString *nid = [self makeNodeId:person.pid type:typePerson];
    NodePtr node = solyaris->getNode([nid UTF8String]);
    
    // check
    if (node != NULL) {
        
        // formatter
        static NSDateFormatter *yearFormatter;
        if (yearFormatter == nil) {
            yearFormatter = [[NSDateFormatter alloc] init];
            [yearFormatter setDateFormat:@"yyyy"];
        }
        
        // properties
        node->renderLabel([person.name UTF8String]);
        node->updateType([person.type UTF8String]);
        
        // movies
        NSSortDescriptor *msorter = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:NO];
        NSArray *movies = [[person.movies allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:msorter]];
        [msorter release];
        
        
        // create nodes
        for (Movie2Person *m2p in movies) {
            
            
            // child
            NSString *cid = [self makeNodeId:m2p.movie.mid type:typeMovie];
            NodePtr child = solyaris->getNode([cid UTF8String]);
            bool existing = true;
            if (child == NULL) {
                existing = false;
                
                // new child
                child = solyaris->createNode([cid UTF8String],[typeMovie UTF8String], node->pos.x, node->pos.y);
                child->renderLabel([m2p.movie.name UTF8String]);
                if (m2p.year) {
                    child->updateMeta([[yearFormatter stringFromDate:m2p.year] UTF8String]);
                }
            }
            
            // add to node
            node->addChild(child);
            
            // create edge
            EdgePtr edge = solyaris->getEdge([nid UTF8String], [cid UTF8String]);
            if (edge == NULL) {
                
                // on the edge
                NSString *eid = [self makeEdgeId:nid to:cid];
                edge = solyaris->createEdge([eid UTF8String],[typeMovie UTF8String],node,child);
                
                // type
                edge->updateType([m2p.type UTF8String]);
                
                // label
                NSString *clabel = m2p.character;
                if ([m2p.type isEqualToString:typePersonDirector] || [m2p.type isEqualToString:typePersonCrew]) {
                    clabel = m2p.job;
                }
                
                // render
                edge->renderLabel([clabel UTF8String]);
            }
            if (existing) {
                edge->show();
            }
            
        }
        
        // loaded
        node->loaded();
        
    }
    
}

/*
 * API Error.
*/
- (void)apiError:(NSNumber*)did type:(NSString*)type message:(NSString*)msg {
    DLog();
    
    // alert
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"API Error" 
                          message:msg 
                          delegate:self 
                          cancelButtonTitle: @"OK"
                          otherButtonTitles:nil];
    [alert setTag:SolyarisAlertAPIError];
    [alert show];    
    [alert release];
    
    // stop loader
    NSString *nid = [self makeNodeId:did type:type];
    NodePtr node = solyaris->getNode([nid UTF8String]);
    
    // check
    if (node != NULL) {
        
        // loaded
        node->loaded();
    }
}

/*
 * API Quit.
 */
- (void)apiFatal:(NSString *)msg {
    DLog();
    
    // alert
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Data Error" 
                          message:msg 
                          delegate:self 
                          cancelButtonTitle: @"Cancel"
                          otherButtonTitles:@"Quit",nil];
    [alert setTag:SolyarisAlertAPIFatal];
    [alert show];    
    [alert release];
    
    
}


#pragma mark -
#pragma mark UIAlertViewDelegate Delegate

/*
 * Alert view button clicked.
 */
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	FLog();
	
	// determine alert
	switch ([actionSheet tag]) {
            
        // fatal
		case SolyarisAlertAPIFatal: {
            
			// cancel
			if (buttonIndex == 0) {
			}
			// quit
			else {
				[self quit];
			}
			
			break;
		}
            
        // error
		case SolyarisAlertAPIError: {
			break;
		}
            
            // default
		default:
			break;
	}
	
	
}


#pragma mark -
#pragma mark SearchResult Delegate


/* 
 * Search selected.
 */
- (void)searchSelected:(SearchResult*)result {
    DLog();
    
    
    // dismiss popover
    [_searchResultsPopoverController dismissPopoverAnimated:YES];
    
    // random position
    CGSize s = [UIScreen mainScreen].applicationFrame.size;
    int b = 300;
    int nx = ((s.width/2.0)-b + arc4random() % (2*b));
    int ny = ((s.height/2.0)-b + arc4random() % (2*b));
    
    
    // node
    NSString *nid = [self makeNodeId:result.ref type:result.type];
    NodePtr node = solyaris->getNode([nid UTF8String]);
    if (node == NULL) {
        node = solyaris->createNode([nid UTF8String],[result.type UTF8String], nx, ny);
    }
    
    // active
    if (! (node->isActive() || node->isLoading())) {
        
        // track
        [Tracker trackEvent:TEventLoadSearch action:result.type label:result.data];
        
        // load
        node->load();
            
        // movie
        if ([result.type isEqualToString:typeMovie]) {
            [tmdb movie:result.ref];
        }
        
        // person
        if ([result.type isEqualToString:typePerson]) {
            [tmdb person:result.ref];
        }


    }


}



#pragma mark -
#pragma mark Information Delegate


/* 
 * Information selected.
 */
- (void)informationSelected:(NSNumber *)nid type:(NSString *)type {
    DLog();
    
    
    // node
    NSString *iid = [self makeNodeId:nid type:type];
    NodePtr node = solyaris->getNode([iid UTF8String]);
    if (node == NULL) {
        node = solyaris->createNode([iid UTF8String],[type UTF8String], 0, 0);
    }
    
    // active
    if (! (node->isActive() || node->isLoading())) {
        
        // track
        [Tracker trackEvent:TEventLoadInfo action:type label:[NSString stringWithCString:node->label.c_str() encoding:NSUTF8StringEncoding]];
        
        // tap & load
        node->tapped();
        node->load();
        
        // movie
        if ([type isEqualToString:typeMovie]) {
            [tmdb movie:nid];
        }
        // person
        else {
            [tmdb person:nid];
        }

    }
    
}


/* 
 * Dismiss information.
 */
- (void)informationDismiss {
    FLog();
    
    // track
    [Tracker trackPageView:@"/graph"];
    
    // hide
    [self animationInformationHide];
}


/*
 * Orientation landscape.
*/
- (bool)informationOrientationLandscape {
    return (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


#pragma mark -
#pragma mark Popopver Delegate


/**
 * Popover dismissed.
 */
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    FLog();
    
    // cancel
    [tmdb cancel];
}



#pragma mark -
#pragma mark Search Delegate

/**
 * Performs the search.
 */
- (void)search:(NSString*)s type:(NSString*)t {
    DLog();
    
    // reset
    [_searchResultViewController searchResultReset];
    
    // framed
    CGRect srframe = _searchViewController.searchBar.frame;
    NSString *type = typeAll;
    if (t == typeMovie) {
        type = typeMovie;
        srframe = _searchViewController.buttonMovie.frame;
    }
    else if (t == typePerson) {
        type = typePerson;
        srframe = _searchViewController.buttonPerson.frame;
    }
    
    // track
    [Tracker trackEvent:TEventSearch action:type label:s];
    
    // api
    [tmdb search:s type:type];
    
    // pop it
    [_searchResultsPopoverController setPopoverContentSize:CGSizeMake(_searchResultViewController.view.frame.size.width, 125) animated:NO];
	[_searchResultsPopoverController presentPopoverFromRect:srframe inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    
}

/*
 * Resets the graph.
 */
- (void)reset {
    DLog();
    
    // app reset
    solyaris->reset();
}



#pragma mark -
#pragma mark Settings Delegate

/* 
 * Dismiss settings.
 */
- (void)settingsDismiss {
    FLog();
    
    // track
    [Tracker trackPageView:@"/graph"];
    
    // hide
    [self animationSettingsHide];
}

/*
 * Applies the settings.
 */
- (void)settingsApply {
    GLog();
    
    // app
    solyaris->applySettings();
}

/*
 * Resets the cache.
 */
- (void)settingsClearCache {
    FLog();
    
    // api
    [tmdb clearCache];
    
    // reset 
    [self reset];
    
}




#pragma mark -
#pragma mark Actions


/*
 * Settings.
 */
- (void)actionSettings:(id)sender {
	DLog();
	
	// animate
    if (! mode_settings) {
        [self animationSettingsShow];
    }
    else {
        [self animationSettingsHide];
    }
}



#pragma mark -
#pragma mark Business


/**
 * Loads a node.
 */
- (void)nodeLoad:(NSString*)nid {
    DLog();
    
    // node
    NodePtr node = solyaris->getNode([nid UTF8String]);
    if (! node->isLoading()) {
        
        // flag
        node->load();
        
        // node
        NSString *type = [NSString stringWithCString:node->type.c_str() encoding:[NSString defaultCStringEncoding]];
        NSNumber *dbid = [self toDBId:nid];
        
        // track
        [Tracker trackEvent:TEventLoadGraph action:type label:[NSString stringWithCString:node->label.c_str() encoding:NSUTF8StringEncoding]];
        
        
        // delay
        float dload = 1.8f;
        
        // movie
        if ([type isEqualToString:typeMovie]) {
            [tmdb performSelector:@selector(movie:) withObject:dbid afterDelay:dload];
        }
        // person
        else {
            [tmdb performSelector:@selector(person:) withObject:dbid afterDelay:dload];
        }
        
    }
    
}

/**
 * Node information.
 */
- (void)nodeInformation:(NSString*)nid {
    DLog();
    
    // node
    NodePtr node = solyaris->getNode([nid UTF8String]);
    NSMutableArray *nodes = [[[NSMutableArray alloc] init] autorelease];
    
    // info
    if (node->isActive()) {
        
        // parent
        NSString *pid = [NSString stringWithCString:node->nid.c_str() encoding:[NSString defaultCStringEncoding]];
        
        // type
        NSString *ntype = [NSString stringWithCString:node->type.c_str() encoding:[NSString defaultCStringEncoding]];
        
        
        // children
        for (NodeIt child = node->children.begin(); child != node->children.end(); ++child) {
            
            // child id
            NSString *cid = [NSString stringWithCString:(*child)->nid.c_str() encoding:[NSString defaultCStringEncoding]];
            
            // edge
            EdgePtr nedge = solyaris->getEdge([pid UTF8String], [cid UTF8String]);
            
            // properties edge
            NSString *eid = [self makeEdgeId:pid to:cid];
            NSString *etype = [NSString stringWithCString:nedge->type.c_str() encoding:NSUTF8StringEncoding];
            NSString *elabel = [NSString stringWithCString:nedge->label.c_str() encoding:NSUTF8StringEncoding];
            
            // properties node
            NSNumber *nid = [self toDBId:[NSString stringWithCString:(*child)->nid.c_str() encoding:NSUTF8StringEncoding]];
            NSString *type = [NSString stringWithCString:(*child)->type.c_str() encoding:NSUTF8StringEncoding];
            NSString *label = [NSString stringWithCString:(*child)->label.c_str() encoding:NSUTF8StringEncoding];
            NSString *meta = [NSString stringWithCString:(*child)->meta.c_str() encoding:NSUTF8StringEncoding];
            bool visible = (*child)->isVisible();
            bool loaded = ( (*child)->isActive() || (*child)->isLoading() );
            
            // data
            DataEdge *dtaEdge = [[DataEdge alloc] initData:eid type:etype label:elabel];
            DataNode *dtaNode = [[[DataNode alloc] initData:nid type:type label:label meta:meta edge:dtaEdge visible:visible loaded:loaded] autorelease];
            [nodes addObject:dtaNode];
            
        }
        
        
        // movie
        if ([ntype isEqualToString:typeMovie]) {
            
            // data
            Movie *movie = [tmdb dataMovie:[self toDBId:pid]];
            
            // information
            [_informationViewController informationMovie:movie nodes:nodes];
        }
        else {
            
            // data
            Person *person = [tmdb dataPerson:[self toDBId:pid]];
            
            // information
            [_informationViewController informationPerson:person nodes:nodes];
        }
        

        // animate
        [self animationInformationShow];        
    }
    
}


/**
 * Quit.
 */
- (void)quit {
    NSLog(@"Aus die Maus.");
    
    // quit app
    solyaris->quit();
    abort();
}



#pragma mark -
#pragma mark Animation

/**
 * Shows the information.
 */
- (void)animationInformationShow {
	FLog();
	
	
	// prepare controllers
	[_informationViewController viewWillAppear:YES];

    
	// prepare views
    _informationViewController.view.hidden = NO;
	_informationViewController.modalView.alpha = 0.0f;
    [self.view bringSubviewToFront:_informationViewController.view];
    
    CGPoint informationCenter = _informationViewController.contentView.center;
    informationCenter.y += self.view.frame.size.height;
    _informationViewController.contentView.center = informationCenter;

    informationCenter.y -= self.view.frame.size.height;
    
	// animate
	[UIView beginAnimations:@"information_show" context:nil];
	[UIView setAnimationDuration:kAnimateTimeInformationShow];
    _informationViewController.modalView.alpha = 0.3f;
    _informationViewController.contentView.center = informationCenter;
	[UIView commitAnimations];
    
	// clean it up
	[self performSelector:@selector(animationInformationShowDone) withObject:nil afterDelay:kAnimateTimeInformationShow];
}
- (void)animationInformationShowDone {
	GLog();
    
    // here you are
    [_informationViewController viewDidAppear:YES];
}


/**
 * Hides the information.
 */
- (void)animationInformationHide {
	FLog();
	
	// prepare controllers
	[_informationViewController viewWillDisappear:YES];
    
    // calculate centers
    CGPoint informationCenter = _informationViewController.contentView.center;
    informationCenter.y += self.view.frame.size.height;
    
	// animate
	[UIView beginAnimations:@"information_hide" context:nil];
	[UIView setAnimationDuration:kAnimateTimeInformationHide];
     _informationViewController.modalView.alpha = 0.0f;
    _informationViewController.contentView.center = informationCenter;
	[UIView commitAnimations];
    
	// clean it up
	[self performSelector:@selector(animationInformationHideDone) withObject:nil afterDelay:kAnimateTimeInformationHide];
}
- (void)animationInformationHideDone {
	GLog();
    
    // view
	[_informationViewController.view setHidden:YES];
    [self.view sendSubviewToBack:_informationViewController.view];
    
    // controller
    [_informationViewController viewDidDisappear:YES];
    
    // center
    CGPoint informationCenter = _informationViewController.contentView.center;
    informationCenter.y -= self.view.frame.size.height;
    _informationViewController.contentView.center = informationCenter;
}


/**
 * Shows the settings.
 */
- (void)animationSettingsShow {
	FLog();
    
    // state
    mode_settings = YES;
    
	
	// prepare controllers
	[_settingsViewController viewWillAppear:YES];
    
    // prepare views
    [_searchResultViewController.view setHidden:NO];
    [_settingsViewController.view setHidden:NO];
    
    // calculate centers
    CGPoint settingsCenter = _settingsViewController.contentView.center;
    settingsCenter.y += kOffsetSettings;
    _settingsViewController.contentView.center = settingsCenter;
    settingsCenter.y -= kOffsetSettings;
    
    CGPoint searchCenter = _searchViewController.view.center;
    searchCenter.y -= kOffsetSettings;
    
    CGPoint buttonCenter = _buttonSettings.center;
    buttonCenter.y -= kOffsetSettings;
    
    // cinder
    CGPoint cinderCenter = _cinderView.center;
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        cinderCenter.x -= kOffsetSettings;
    }
    else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        cinderCenter.x += kOffsetSettings;
    }
    else if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        cinderCenter.y += kOffsetSettings;
    }
    else {
        cinderCenter.y -= kOffsetSettings;
    }

    
    // animate 
	[UIView beginAnimations:@"settings_show" context:nil];
	[UIView setAnimationDuration:kAnimateTimeSettingsShow];
    _settingsViewController.contentView.center = settingsCenter;
    _searchViewController.view.center = searchCenter;
    _buttonSettings.center = buttonCenter;
    _cinderView.center = cinderCenter;
	[UIView commitAnimations];

	// clean it up
	[self performSelector:@selector(animationSettingsShowDone) withObject:nil afterDelay:kAnimateTimeSettingsShow];
}
- (void)animationSettingsShowDone {
	GLog();
    
    // appeared
    [_settingsViewController viewDidAppear:YES];
    
}


/**
 * Hides the information.
 */
- (void)animationSettingsHide {
	FLog();
    
    // state
    mode_settings = NO;
	
	// prepare controllers
	[_settingsViewController viewWillDisappear:YES];
    
    // calculate centers
    CGPoint settingsCenter = _settingsViewController.contentView.center;
    settingsCenter.y += kOffsetSettings;
    
    CGPoint searchCenter = _searchViewController.view.center;
    searchCenter.y += kOffsetSettings;
    
    CGPoint buttonCenter = _buttonSettings.center;
    buttonCenter.y += kOffsetSettings;
    
    // cinder
    CGPoint cinderCenter = _cinderView.center;
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        cinderCenter.x += kOffsetSettings;
    }
    else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        cinderCenter.x -= kOffsetSettings;
    }
    else if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        cinderCenter.y -= kOffsetSettings;
    }
    else {
        cinderCenter.y += kOffsetSettings;
    }
    
    // animate 
	[UIView beginAnimations:@"settings_hide" context:nil];
	[UIView setAnimationDuration:kAnimateTimeSettingsHide];
    _settingsViewController.contentView.center = settingsCenter;
    _searchViewController.view.center = searchCenter;
    _buttonSettings.center = buttonCenter;
    _cinderView.center = cinderCenter;
	[UIView commitAnimations];
    
    
	// clean it up
	[self performSelector:@selector(animationSettingsHideDone) withObject:nil afterDelay:kAnimateTimeSettingsHide];
}
- (void)animationSettingsHideDone {
	GLog();
    
    // view
    [_searchResultViewController.view setHidden:NO];
    [_settingsViewController.view setHidden:YES];
    
    CGPoint settingsCenter = _settingsViewController.contentView.center;
    settingsCenter.y -= kOffsetSettings;
    _settingsViewController.contentView.center = settingsCenter;
    
    // controller
    [_settingsViewController viewDidDisappear:YES];
    
}




#pragma mark -
#pragma mark Helpers

/* 
 * Node id.
 */
- (NSString*)makeNodeId:(NSNumber*)nid type:(NSString*)type {
    
    // make it so
    return [NSString stringWithFormat:@"%@_%i",type,[nid intValue]];
}

/* 
 * Edge id.
 */
- (NSString*)makeEdgeId:(NSString*)pid to:(NSString *)cid {
    
    // theres an edge
    return [NSString stringWithFormat:@"%@_edge_%@",pid,cid];
}


/* 
 * DB ID.
 */
- (NSNumber*)toDBId:(NSString*)nid {
    
    // formatter
    static NSNumberFormatter *nf;
    if (nf == nil) {
        nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    
    // parts
    NSArray *chunks = [nid componentsSeparatedByString: @"_"];
    
    // id
    NSNumber *dbid = [nf numberFromString:[chunks objectAtIndex:1]];
    return dbid;
}




#pragma mark -
#pragma mark Memory management

/*
 * Deallocates used memory.
 */
- (void)dealloc {
	GLog();
	
    // controllers
    [_searchViewController release];
    [_searchResultViewController release];
    [_informationViewController release];
	
	// release global
    [super dealloc];
}

@end
