//
//  IMDGViewController.m
//  IMDG
//
//  Created by CNPP on 16.6.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "IMDGViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IMDGApp.h"
#import "IMDGConstants.h"




/**
 * Helper Stack.
 */
@interface IMDGViewController (HelperStack)
- (NSString*)makeNodeId:(NSNumber*)nid type:(NSString*)type;
- (NSString*)makeEdgeId:(NSString*)pid to:(NSString*)cid;
- (NSNumber*)toDBId:(NSString*)nid;
@end

/**
 * Animation Stack.
 */
@interface IMDGViewController (AnimationHelpers)
- (void)animationInformationShow;
- (void)animationInformationShowDone;
- (void)animationInformationHide;
- (void)animationInformationHideDone;
- (void)animationSettingsShow;
- (void)animationSettingsShowDone;
- (void)animationSettingsHide;
- (void)animationSettingsHideDone;
@end


// constants
#define kAnimateTimeInformationShow	0.6f
#define kAnimateTimeInformationHide	0.45f
#define kAnimateTimeSettingsShow	0.6f
#define kAnimateTimeSettingsHide	0.3f
#define kOffsetSettings 480



/**
 * IMDG ViewController.
 */
@implementation IMDGViewController



#pragma mark -
#pragma mark Properties

// accessors
@synthesize imdgApp;



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
        imdb = [[IMDB alloc] init];
        imdb.delegate = self;
        
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
    
    // window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // frames
    CGRect frameSearch = CGRectMake(0, 0, window.frame.size.width, 40);
    CGRect frameSearchResult = CGRectMake(0, 0, 320, 480);
    CGRect frameInformation = CGRectMake(0, 0, 600, 600);
    CGRect frameSettings = CGRectMake(0, 0, 708, kOffsetSettings);
    CGRect frameSettingsButton = CGRectMake(window.frame.size.width-32, window.frame.size.height-32, 32, 32);
    
    // view
    self.view = [[[UIView alloc] initWithFrame:window.frame] autorelease];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.opaque = NO;
    [window addSubview:self.view];
    
    
    // background
    UIView *bgView = [[UIView alloc] initWithFrame:window.frame];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"texture_background.png"]];
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
            _cinderView = [subview retain];
            break;
        }
    }


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
    
    
    // app
    imdgApp->setDeviceOrientation(toInterfaceOrientation);
    
    // animate cinder
    [UIView beginAnimations:@"flip" context:nil];
    [UIView setAnimationDuration:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
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
    NodePtr node = imdgApp->getNode([nid UTF8String]);
    
    // check
    if (node != NULL) {
        
        // properties
        node->renderLabel([movie.title UTF8String]);
        
        
        // directors
        NSSortDescriptor *dsorter = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:YES];
        NSArray *directors = [[movie.directors allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:dsorter]];
        [dsorter release];
        
        // create nodes
        for (MovieDirector *mdirector in directors) {
            
            // child
            NSString *cid = [self makeNodeId:mdirector.director.did type:typeDirector];
            NodePtr child = imdgApp->getNode([cid UTF8String]);
            bool existing = true;
            if (child == NULL) {
                existing = false;
                
                // new child
                child = imdgApp->createNode([cid UTF8String],[typeDirector UTF8String], node->pos.x, node->pos.y);
                child->renderLabel([mdirector.director.name UTF8String]);
            }
            
            // add to node
            node->addChild(child);
            
            // create edge
            EdgePtr edge = imdgApp->getEdge([nid UTF8String], [cid UTF8String]);
            if (edge == NULL) {
                NSString *eid = [self makeEdgeId:nid to:cid];
                edge = imdgApp->createEdge([eid UTF8String],[typeDirector UTF8String],node,child);
                edge->renderLabel([mdirector.movie.year UTF8String]);
            }
            if (existing) {
                edge->show();
            }
            
        }
        
        
        // actors
        NSSortDescriptor *asorter = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        NSArray *actors = [[movie.actors allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:asorter]];
        [asorter release];
        
        // create nodes
        for (MovieActor *mactor in actors) {
            
            // child
            NSString *cid = [self makeNodeId:mactor.actor.aid type:typeActor];
            NodePtr child = imdgApp->getNode([cid UTF8String]);
            bool existing = true;
            if (child == NULL) {
                existing = false;
                 
                // new child
                child = imdgApp->createNode([cid UTF8String],[typeActor UTF8String], node->pos.x, node->pos.y);
                child->renderLabel([mactor.actor.name UTF8String]);
            }
            
            // add to node
            node->addChild(child);
            
            // create edge
            EdgePtr edge = imdgApp->getEdge([nid UTF8String], [cid UTF8String]);
            if (edge == NULL) {
                NSString *eid = [self makeEdgeId:nid to:cid];
                edge = imdgApp->createEdge([eid UTF8String],[typeActor UTF8String],node,child);
                edge->renderLabel([mactor.character UTF8String]);
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
 * Loaded actor.
 */
- (void)loadedActor:(Actor*)actor {
    DLog();
    
    // node
    NSString *nid = [self makeNodeId:actor.aid type:typeActor];
    NodePtr node = imdgApp->getNode([nid UTF8String]);
    
    // check
    if (node != NULL) {
        
        // properties
        node->renderLabel([actor.name UTF8String]);
        
        // movies
        NSSortDescriptor *msorter = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:NO];
        NSArray *movies = [[actor.movies allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:msorter]];
        [msorter release];
        
        // create nodes
        for (MovieActor *mactor in movies) {
            
            // child
            NSString *cid = [self makeNodeId:mactor.movie.mid type:typeMovie];
            NodePtr child = imdgApp->getNode([cid UTF8String]);
            bool existing = true;
            if (child == NULL) {
                existing = false;
                
                // new child
                child = imdgApp->createNode([cid UTF8String],[typeMovie UTF8String], node->pos.x, node->pos.y);
                child->renderLabel([mactor.movie.title UTF8String]);
            }
            
            // add to node
            node->addChild(child);
            
            // create edge
            EdgePtr edge = imdgApp->getEdge([nid UTF8String], [cid UTF8String]);
            if (edge == NULL) {
                NSString *eid = [self makeEdgeId:nid to:cid];
                edge = imdgApp->createEdge([eid UTF8String],[typeMovie UTF8String],node,child);
                edge->renderLabel([mactor.character UTF8String]);
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
 * Loaded director.
 */
- (void)loadedDirector:(Director*)director {
    DLog();
    
    
    // node
    NSString *nid = [self makeNodeId:director.did type:typeDirector];
    NodePtr node = imdgApp->getNode([nid UTF8String]);
    
    // check
    if (node != NULL) {
        
        // properties
        node->renderLabel([director.name UTF8String]);
        
        // movies
        NSSortDescriptor *msorter = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:NO];
        NSArray *movies = [[director.movies allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:msorter]];
        [msorter release];
        
        // create nodes
        for (MovieActor *mactor in movies) {
            
            // child
            NSString *cid = [self makeNodeId:mactor.movie.mid type:typeMovie];
            NodePtr child = imdgApp->getNode([cid UTF8String]);
            bool existing = true;
            if (child == NULL) {
                existing = false;
                
                // new child
                child = imdgApp->createNode([cid UTF8String],[typeMovie UTF8String], node->pos.x, node->pos.y);
                child->renderLabel([mactor.movie.title UTF8String]);
            }
            
            // add to node
            node->addChild(child);
            
            // create edge
            EdgePtr edge = imdgApp->getEdge([nid UTF8String], [cid UTF8String]);
            if (edge == NULL) {
                NSString *eid = [self makeEdgeId:nid to:cid];
                edge = imdgApp->createEdge([eid UTF8String],[typeDirector UTF8String],node,child);
                edge->renderLabel([mactor.movie.year UTF8String]);
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
 * Quits the application.
 */
- (void)quit {
    NSLog(@"Aus die Maus.");
    imdgApp->quit();
    abort();
}


#pragma mark -
#pragma mark SearchResult Delegate


/* 
 * Search selected.
 */
- (void)searchSelected:(SearchResult*)result type:(NSString*)type {
    DLog();
    
    
    // dismiss popover
    [_searchResultsPopoverController dismissPopoverAnimated:YES];
    
    // random position
    CGSize s = [UIScreen mainScreen].applicationFrame.size;
    int b = 300;
    int nx = ((s.width/2.0)-b + arc4random() % (2*b));
    int ny = ((s.height/2.0)-b + arc4random() % (2*b));
    
    
    // node
    NSString *nid = [self makeNodeId:result.rid type:type];
    NodePtr node = imdgApp->getNode([nid UTF8String]);
    if (node == NULL) {
        node = imdgApp->createNode([nid UTF8String],[type UTF8String], nx, ny);
    }
    
    // active
    if (! (node->isActive() || node->isLoading())) {
        
        // load
        node->load();
            
        // movie
        if ([type isEqualToString:typeMovie]) {
            [imdb movie:result.rid];
        }
        
        // actor
        if ([type isEqualToString:typeActor]) {
            [imdb actor:result.rid];
        }
        
        // director
        if ([type isEqualToString:typeDirector]) {
            [imdb director:result.rid];
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
    NodePtr node = imdgApp->getNode([iid UTF8String]);
    if (node == NULL) {
        node = imdgApp->createNode([iid UTF8String],[type UTF8String], 0, 0);
    }
    
    // active
    if (! (node->isActive() || node->isLoading())) {
        
        // tap & load
        node->tapped();
        node->load();
        
        // movie
        if ([type isEqualToString:typeMovie]) {
            [imdb movie:nid];
        }
        
        // actor
        if ([type isEqualToString:typeActor]) {
            [imdb actor:nid];
        }
        
        // director
        if ([type isEqualToString:typeDirector]) {
            [imdb director:nid];
        }
    }
    
}


/* 
 * Dismiss information.
 */
- (void)informationDismiss {
    FLog();
    
    // hide
    [self animationInformationHide];
}




#pragma mark -
#pragma mark Popopver Delegate


/**
 * Popover dismissed.
 */
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    FLog();
    
    // cancel
    [imdb cancel];
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
    
    // api
    [imdb search:s type:t];
    
    // framed
    CGRect srframe = _searchViewController.buttonMovie.frame;
    if (t == typeActor) {
        srframe = _searchViewController.buttonActor.frame;
    }
    else if (t == typeDirector) {
        srframe = _searchViewController.buttonDirector.frame;
    }
    
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
    imdgApp->reset();
}



#pragma mark -
#pragma mark Settings Delegate

/* 
 * Dismiss settings.
 */
- (void)settingsDismiss {
    FLog();
    
    // hide
    [self animationSettingsHide];
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
    NodePtr node = imdgApp->getNode([nid UTF8String]);
    if (! node->isLoading()) {
        
        // flag
        node->load();
        
        // node
        NSString *type = [NSString stringWithCString:node->type.c_str() encoding:[NSString defaultCStringEncoding]];
        NSNumber *dbid = [self toDBId:nid];
        
        
        // delay
        float dload = 1.8f;
        
        // movie
        if ([type isEqualToString:typeMovie]) {
            [imdb performSelector:@selector(movie:) withObject:dbid afterDelay:dload];
        }
        
        // actor
        if ([type isEqualToString:typeActor]) {
            [imdb performSelector:@selector(actor:) withObject:dbid afterDelay:dload];
        }
        
        // director
        if ([type isEqualToString:typeDirector]) {
            [imdb performSelector:@selector(director:) withObject:dbid afterDelay:dload];
        }
        
    }
    
}

/**
 * Node information.
 */
- (void)nodeInformation:(NSString*)nid {
    DLog();
    
    // node
    NodePtr node = imdgApp->getNode([nid UTF8String]);
    
    // info
    if (node->isActive()) {
        
        
        // information
        [_informationViewController informationTitle:[NSString stringWithCString:node->label.c_str() encoding:[NSString defaultCStringEncoding]]];
        NSMutableArray *movies = [[NSMutableArray alloc] init];
        NSMutableArray *actors = [[NSMutableArray alloc] init];
        NSMutableArray *directors = [[NSMutableArray alloc] init];
        
        // parent
        NSString *pid = [NSString stringWithCString:node->nid.c_str() encoding:[NSString defaultCStringEncoding]];
        
        
        // children
        for (NodeIt child = node->children.begin(); child != node->children.end(); ++child) {
            
            // child id
            NSString *cid = [NSString stringWithCString:(*child)->nid.c_str() encoding:[NSString defaultCStringEncoding]];
            
            // edge
            EdgePtr edge = imdgApp->getEdge([pid UTF8String], [cid UTF8String]);
            
            // properties
            NSNumber *nid = [self toDBId:[NSString stringWithCString:(*child)->nid.c_str() encoding:[NSString defaultCStringEncoding]]];
            NSString *type = [NSString stringWithCString:(*child)->type.c_str() encoding:[NSString defaultCStringEncoding]];
            NSString *value = [NSString stringWithCString:(*child)->label.c_str() encoding:[NSString defaultCStringEncoding]];
            NSString *meta = @"meta";
            bool visible = (*child)->isVisible();
            bool loaded = ( (*child)->isActive() || (*child)->isLoading() );
            if (edge != NULL) {
                
                // label
                meta = [NSString stringWithCString:edge->label.c_str() encoding:[NSString defaultCStringEncoding]];
                
            }
            
            
            // information
            Information *nfo = [[Information alloc] initWithValue:value meta:meta type:type nid:nid visible:visible loaded:loaded];
            
            // movie
            if ([type isEqualToString:typeMovie]) {
                [movies addObject:nfo];
            }
            
            // actor
            if ([type isEqualToString:typeActor]) {
                [actors addObject:nfo];
            }
            
            // director
            if ([type isEqualToString:typeDirector]) {
                [directors addObject:nfo];
            }
            
        }
        
        // set 
        _informationViewController.movies = movies;
        _informationViewController.actors = actors;
        _informationViewController.directors = directors;

        // animate
        [self animationInformationShow];        
    }
    
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
