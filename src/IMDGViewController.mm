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
#define kAnimateTimeInformationShow	0.75f
#define kAnimateTimeInformationHide	0.45f
#define kAnimateTimeSettingsShow	0.75f
#define kAnimateTimeSettingsHide	0.45f



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
    CGRect frameInformation = CGRectMake(0, 0, 650, 650);
    CGRect frameSettings = CGRectMake(0, 0, 320, 480);
    CGRect frameSettingsButton = CGRectMake(window.frame.size.width-24, window.frame.size.height-24, 24, 24);
    
    // view
    self.view = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [window addSubview:self.view];
    
    
    // search
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithFrame:frameSearch];
    searchViewController.delegate = self;
    [searchViewController loadView];
    _searchViewController = [searchViewController retain];
    [window addSubview:_searchViewController.view];
    [window bringSubviewToFront:_searchViewController.view];
    [searchViewController release];
    
    
    
    // search result
    SearchResultViewController *searchResultViewController = [[SearchResultViewController alloc] initWithStyle:UITableViewStylePlain];
    searchResultViewController.delegate = self;
    searchResultViewController.view.frame = frameSearchResult;
	[searchResultViewController.view setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ];
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
    [window addSubview:_informationViewController.view];
    [window sendSubviewToBack:_informationViewController.view];
    [informationViewController release];
    
    
    // settings
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithFrame:frameSettings];
    settingsViewController.delegate = self;
    [settingsViewController loadView];
    _settingsViewController = [settingsViewController retain];
    [window addSubview:_settingsViewController.view];
    [window sendSubviewToBack:_settingsViewController.view];
    [settingsViewController release];
    

    // button settings
	UIButton *btnSettings = [UIButton buttonWithType:UIButtonTypeCustom]; 
	btnSettings.frame = frameSettingsButton;
	[btnSettings setImage:[UIImage imageNamed:@"btn_settings.png"] forState:UIControlStateNormal];
	[btnSettings addTarget:self action:@selector(actionSettings:) forControlEvents:UIControlEventTouchUpInside];
	[window addSubview:btnSettings];
    
    
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
    // portrait
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
bool settings = NO;
- (void)actionSettings:(id)sender {
	DLog();
	
	// animate
    if (! settings) {
        [self animationSettingsShow];
    }
    else {
        [self animationSettingsHide];
    }
    
    // state
    settings = ! settings;
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
    
    // window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window bringSubviewToFront:_informationViewController.view];
	
	
	// prepare controllers
    [_informationViewController.view setHidden:NO];
	[_informationViewController viewWillAppear:YES];

    
	// prepare views
    _informationViewController.view.hidden = NO;
	_informationViewController.modalView.alpha = 0.0f;
    CGPoint offcenter = _informationViewController.contentView.center;
    offcenter.y += window.frame.size.height;
    _informationViewController.contentView.center = offcenter;
    
	// animate
	[UIView beginAnimations:@"information_show" context:nil];
	[UIView setAnimationDuration:kAnimateTimeInformationShow];
    
    // modal 
    _informationViewController.modalView.alpha = 0.3f;
    
    // content
    CGPoint center = _informationViewController.contentView.center;
    center.y -= window.frame.size.height;
    _informationViewController.contentView.center = center;
    
    // make it so
	[UIView commitAnimations];
    
	// clean it up
	[self performSelector:@selector(animationInformationShowDone) withObject:nil afterDelay:kAnimateTimeInformationShow];
}
- (void)animationInformationShowDone {
	GLog();
    
    // here you are
    [self.view bringSubviewToFront:_informationViewController.view];
    [_informationViewController viewDidAppear:YES];
}


/**
 * Hides the information.
 */
- (void)animationInformationHide {
	FLog();
    
    // window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	
	// prepare controllers
	[_informationViewController viewWillDisappear:YES];
    
    
	// prepare views
	_informationViewController.view.hidden = NO;

    
	// animate
	[UIView beginAnimations:@"information_hide" context:nil];
	[UIView setAnimationDuration:kAnimateTimeInformationHide];
    
    // modal 
     _informationViewController.modalView.alpha = 0.0f;
    
    // content
    CGPoint offcenter = _informationViewController.contentView.center;
    offcenter.y += window.frame.size.height;
    _informationViewController.contentView.center = offcenter;
    
	[UIView commitAnimations];
    
	// clean it up
	[self performSelector:@selector(animationInformationHideDone) withObject:nil afterDelay:kAnimateTimeInformationHide];
}
- (void)animationInformationHideDone {
	GLog();
    
    // hide
    [_informationViewController viewDidDisappear:YES];
	[_informationViewController.view setHidden:YES];
    
    // window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window sendSubviewToBack:_informationViewController.view];
    
    // center
    CGPoint center = _informationViewController.contentView.center;
    center.y -= window.frame.size.height;
    _informationViewController.contentView.center = center;
}


/**
 * Shows the settings.
 */
- (void)animationSettingsShow {
	FLog();
    
	
	// prepare controllers
    [_settingsViewController.view setHidden:NO];
	[_settingsViewController viewWillAppear:YES];
    
    
    // animate search
	[UIView beginAnimations:@"settings_show" context:nil];
	[UIView setAnimationDuration:kAnimateTimeSettingsShow];
    _searchViewController.view.alpha = 0.0f;
	[UIView commitAnimations];
    

	// animate cinder
    CATransition *acinder = [CATransition animation];
    [acinder setDelegate:self];
    [acinder setDuration:kAnimateTimeSettingsShow];
    [acinder setType:@"pageCurl"];
    [acinder setRemovedOnCompletion:NO];
    acinder.startProgress = 0;
    acinder.endProgress = kAnimateTimeSettingsShow-0.001; 
    [acinder setFillMode: @"extended"];
    [[_cinderView layer] addAnimation:acinder forKey:@"settings_show"];

    
    // hide
    _cinderView.hidden = YES;
    _searchResultViewController.view.hidden = YES;
    _searchResultViewController.view.hidden = YES;

    
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
	
	// prepare controllers
	[_settingsViewController viewWillDisappear:YES];
    

	// animate cinder
    CATransition *acinder = [CATransition animation];
    [acinder setDelegate:self];
    [acinder setDuration:kAnimateTimeSettingsHide];
    [acinder setType:@"pageUnCurl"];
    [[_cinderView layer] addAnimation:acinder forKey:@"settings_hide"];
    
    // animate search
	[UIView beginAnimations:@"settings_hide" context:nil];
	[UIView setAnimationDuration:kAnimateTimeSettingsHide];
    _searchViewController.view.alpha = 1.0f;
	[UIView commitAnimations];
    
    // unhide
    _cinderView.hidden = NO;
    _searchResultViewController.view.hidden = NO;
    _searchResultViewController.view.hidden = NO;
    
	// clean it up
	[self performSelector:@selector(animationSettingsHideDone) withObject:nil afterDelay:kAnimateTimeSettingsHide];
}
- (void)animationSettingsHideDone {
	GLog();
    
    // hide
    [_settingsViewController viewDidDisappear:YES];
	[_settingsViewController.view setHidden:YES];
    
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
