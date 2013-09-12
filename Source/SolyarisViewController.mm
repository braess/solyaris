//
//  SolyarisViewController.m
//  Solyaris
//
//  Created by CNPP on 16.6.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
//  This file is part of Solyaris.
//  
//  Solyaris is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  Solyaris is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with Solyaris.  If not, see www.gnu.org/licenses/.

#import <QuartzCore/QuartzCore.h>
#import "SolyarisViewController.h"
#import "SolyarisAppDelegate.h"
#import "DataNode.h"
#import "Solyaris.h"
#import "SolyarisConstants.h"
#import "SolyarisLocalization.h"
#import "HelpView.h"
#import "Tracker.h"
#import "Rater.h"


/**
 * Helper Stack.
 */
@interface SolyarisViewController (Animations)
- (NSString*)makeNodeId:(NSNumber*)nid type:(NSString*)type;
- (NSString*)makeEdgeId:(NSString*)pid to:(NSString*)cid;
- (NSString*)makeConnectionId:(NSString*)sid to:(NSString*)nid;
- (NSNumber*)toDBId:(NSString*)nid;
- (void)randomTagline;
@end


/**
 * Controller Stack.
 */
@interface SolyarisViewController (ControllerStack)
- (void)controllerSettings:(BOOL)show animated:(BOOL)animated;
- (SettingsViewController*)controllerSettings;
- (void)controllerSearch:(BOOL)show animated:(BOOL)animated;
- (SearchViewController*)controllerSearch;
- (void)controllerRelated:(BOOL)show animated:(BOOL)animated;
- (RelatedViewController*)controllerRelated;
- (void)controllerInformation:(BOOL)show animated:(BOOL)animated;
- (InformationViewController*)controllerInformation;
@end


/**
 * Transition Stack.
 */
@interface SolyarisViewController (TransitionStack)
- (void)transitionSearch:(SearchViewController*)search animated:(BOOL)animated;
- (void)transitionSearchDismiss:(SearchViewController*)search animated:(BOOL)animated;
- (void)transitionSettings:(SettingsViewController*)settings animated:(BOOL)animated;
- (void)transitionSettingsDismiss:(SettingsViewController*)settings animated:(BOOL)animated;
- (void)transitionRelated:(RelatedViewController*)related animated:(BOOL)animated;
- (void)transitionRelatedDismiss:(RelatedViewController*)related animated:(BOOL)animated;
- (void)transitionInformation:(InformationViewController*)information animated:(BOOL)animated;
- (void)transitionInformationLoader;
- (void)transitionInformationLoaded:(InformationViewController*)information animated:(BOOL)animated;
- (void)transitionInformationDismiss:(InformationViewController*)information animated:(BOOL)animated;
@end


/**
 * Gesture Stack.
 */
@interface SolyarisViewController (GestureHelpers)
- (void)pinched:(UIPinchGestureRecognizer*)recognizer; 
@end




/**
 * Solyaris ViewController.
 */
@implementation SolyarisViewController


#pragma mark -
#pragma mark Constants

// constants
#define kDelayTimeNodeLoad              1.2f
#define kDelayTimeStartup               1.2f
#define kAnimateTimeInformationLoad     0.45f
#define kAnimateTimeInformationShow     0.45f
#define kAnimateTimeInformationHide     0.33f
#define kAnimateTimeRelatedShow         0.24f
#define kAnimateTimeRelatedHide         0.12f
#define kAnimateTimeSearchShow          0.24f
#define kAnimateTimeSearchHide          0.24f
#define kAnimateTimeSettingsShow        0.48f
#define kAnimateTimeSettingsHide        0.24f
#define kOffsetSettings                 (iPad ? 480 : [[UIScreen mainScreen] bounds].size.height)
#define kAlphaModalInfo                 0.15f
#define kAlphaModalRelated              0.06f
#define kAlphaModalSearch               0.03f


#pragma mark -
#pragma mark Properties

// accessors
@synthesize solyaris;



#pragma mark -
#pragma mark Object

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
        
        // states
        state_splash = YES;
        state_settings = NO;
        state_search = NO;
        state_info = NO;
        state_related = NO;
        
        // data
        NSMutableDictionary *dtaNodes = [[NSMutableDictionary alloc] init];
        _dta_nodes = [dtaNodes retain];
        [dtaNodes release];
        
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
    
    // screen
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    // frames
    CGRect frame = CGRectMake(0, 0, screen.size.width, screen.size.height);
    CGRect frameSearchBar = CGRectMake(0, 0, screen.size.width, 40);
    CGRect frameSettingsButton = CGRectMake(screen.size.width-44, screen.size.height-44, 44, 44);
    
    
    // app window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window setRootViewController:self];
    
    // cinder view
    for (UIView *subview in window.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"CinderViewCocoaTouch")]) {
            _cinderView = (CinderViewCocoaTouch*) [subview retain];
            break;
        }
    }
    
    
    // view 
    self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.opaque = NO;
    self.view.multipleTouchEnabled = YES;
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor clearColor];
    [window addSubview:self.view];
    [window bringSubviewToFront:self.view];
    
    
    // background
    UIView *bgApp = [[UIView alloc] initWithFrame:frame];
    bgApp.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    bgApp.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_settings.png"]];
    bgApp.opaque = NO;
    [window addSubview:bgApp];
    [window sendSubviewToBack:bgApp];
    [bgApp release];
    
    
    // search
    SearchBarViewController *searchBarViewController = [[SearchBarViewController alloc] initWithFrame:frameSearchBar];
    searchBarViewController.delegate = self;
    _searchBarViewController = [searchBarViewController retain];
    [self addChildViewController:_searchBarViewController];
    [self.view addSubview:_searchBarViewController.view];
    [self.view bringSubviewToFront:_searchBarViewController.view];
    [searchBarViewController release];
    

    // button settings
	UIButton *btnSettings = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnSettings.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
	btnSettings.frame = frameSettingsButton;
	[btnSettings setImage:[UIImage imageNamed:@"btn_settings.png"] forState:UIControlStateNormal];
	[btnSettings addTarget:self action:@selector(actionSettings:) forControlEvents:UIControlEventTouchUpInside];
    _buttonSettings = [btnSettings retain];
	[self.view  addSubview:_buttonSettings];
    
    // pinch gesture recognizer
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinched:)];
    [self.view addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    
    // note
	NoteView *noteView = [[NoteView alloc] initWithFrame:frame];
	[noteView setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ];
	_noteView = [noteView retain];
	[self.view addSubview:_noteView];
    [self.view bringSubviewToFront:_noteView];
	[noteView release];
    
    // splash
    SplashView *splash = [[[SplashView alloc] initWithFrame:frame] autorelease];
    splash.delegate = self;
    [self.view addSubview:splash];
    [self.view bringSubviewToFront:splash];
    [splash dismissSplash];

    // notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activate) name: UIApplicationDidBecomeActiveNotification object:nil];

}


/*
 * View appears.
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog();
    
    // track
    [Tracker trackView:@"Solyaris"];
}


#pragma mark -
#pragma mark Application

/*
 * Activates the controller.
 */
- (void)activate {
    FLog();
    
    // reset api
    [tmdb reset];
    
    // tagline
    [self randomTagline];
    
    // delegate
    SolyarisAppDelegate *appDelegate = (SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // triggers
    NSString *triggerInstall = (NSString*) [appDelegate getUserDefault:triggerAppInstall];
    if (triggerInstall) {
        [self install:triggerInstall];
        [appDelegate removeUserDefault:triggerAppInstall];
    }
    NSString *triggerUpdate = (NSString*) [appDelegate getUserDefault:triggerAppUpdate];
    if (triggerUpdate) {
        [self update:triggerUpdate];
        [appDelegate removeUserDefault:triggerAppUpdate];
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

/**
 * Shows the help.
 */
- (void)help {
    DLog();
    
    // view
    HelpView *helpView = [[[HelpView alloc] init] autorelease];
    [self.view addSubview:helpView];
    [self.view bringSubviewToFront:helpView];
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"SplashView")]) {
            [self.view bringSubviewToFront:subview];
            break;
        }
    }
    
    // show
    [helpView showHelp];
}

/**
 * Install stuff.
 */
- (void)install:(NSString*)version {
    DLog();
    
    // help
    [self performSelector:@selector(help) withObject:nil afterDelay:kDelayTimeStartup];

}


/**
 * Update stuff.
 */
- (void)update:(NSString*)version {
    DLog();
    
    // note deprecated
    Note *deprecated = [Note retrieveNote:noteAppDeprecated];
    if (deprecated) {
        
        // view
        [self.view bringSubviewToFront:_noteView];
        
        // note
        [_noteView noteInfo:deprecated.title message:deprecated.message];
        [_noteView showNoteAfterDelay:kDelayTimeStartup];
    }
    
    // note update
    Note *updated = [Note retrieveNote:noteAppUpdate];
    if (updated) {
        
        // view
        [self.view bringSubviewToFront:_noteView];
        
        // note
        [_noteView noteSuccess:updated.title message:updated.message];
        [_noteView showNoteAfterDelay:kDelayTimeStartup*1.25];
        [_noteView dismissNoteAfterDelay:kDelayTimeStartup*1.25+2.4];
    }
}




#pragma mark -
#pragma mark Rotation support

/*
 * Rotate is the new black.
 */
- (NSUInteger)supportedInterfaceOrientations {
    return state_splash ? UIInterfaceOrientationMaskPortrait : UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotate {
    return ! (state_splash || state_settings);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation) ? ! state_settings : ! (state_splash || state_settings);
}
 

/*
 * Prepare rotation.
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    FLog();

    // hide settings
    _buttonSettings.hidden = (toInterfaceOrientation == UIInterfaceOrientationPortrait) ? NO : YES;

}


/*
 * Prepare rotation animation.
 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
 
    // animate cinder
    [UIView beginAnimations:@"flip" context:nil];
    [UIView setAnimationDuration:0]; // animation distorts view
    
    // screen
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    // flip 
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {      
        _cinderView.transform = CGAffineTransformIdentity;
        _cinderView.transform = CGAffineTransformMakeRotation(0);
        _cinderView.bounds = CGRectMake(0.0, 0.0, screen.size.width, screen.size.height);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {      
        _cinderView.transform = CGAffineTransformIdentity;
        _cinderView.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        _cinderView.bounds = CGRectMake(0.0, 0.0, screen.size.height, screen.size.width);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {      
        _cinderView.transform = CGAffineTransformIdentity;
        _cinderView.transform = CGAffineTransformMakeRotation(M_PI);
        _cinderView.bounds = CGRectMake(0.0, 0.0, screen.size.width, screen.size.height);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {      
        _cinderView.transform = CGAffineTransformIdentity;
        _cinderView.transform = CGAffineTransformMakeRotation(- M_PI * 0.5);
        _cinderView.bounds = CGRectMake(0.0, 0.0, screen.size.height, screen.size.width);
    }
    [UIView commitAnimations];
    
    // app
    solyaris->applyDeviceOrientation(toInterfaceOrientation);
    
}


/*
 * Status.
 */
- (BOOL)prefersStatusBarHidden {
    return YES;
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
#pragma mark Gestures

/*
 * Pinched.
 */
- (void)pinched:(UIPinchGestureRecognizer *)recognizer {
    GLog();
    
    // block
    if (state_settings) {
        return;
    }
    
    // forward to cinder
    solyaris->pinched(recognizer); 
}



#pragma mark -
#pragma mark API Delegate

/*
 * Loaded search.
 */
- (void)loadedSearch:(Search*)result {
    DLog();
    
    // loaded
    SearchViewController *searchViewController = [self controllerSearch];
    if (searchViewController) {
        [searchViewController loadedSearch:result];
    }
    
}

/*
 * Loaded popular.
 */
- (void)loadedPopular:(Popular*)popular more:(BOOL)more {
    DLog();

    // loaded
    SearchViewController *searchViewController = [self controllerSearch];
    if (searchViewController) {
        [searchViewController loadedPopular:popular more:more];
    }

}

/*
 * Loaded now playing.
 */
- (void)loadedNowPlaying:(NowPlaying*)nowplaying more:(BOOL)more {
    DLog();
    
    // loaded
    SearchViewController *searchViewController = [self controllerSearch];
    if (searchViewController) {
        [searchViewController loadedNowPlaying:nowplaying more:more];
    }

}

/*
 * Loaded now playing.
 */
- (void)loadedHistory:(NSArray *)history type:(NSString *)type {
    DLog();
    
    // loaded
    SearchViewController *searchViewController = [self controllerSearch];
    if (searchViewController) {
        [searchViewController loadedHistory:history type:type];
    }

}


/*
 * Loaded movie.
 */
- (void)loadedMovie:(Movie*)movie {
    DLog();
    
    // node
    NodePtr node;
    NSString *nid = [self makeNodeId:movie.mid type:typeMovie];
    if (movie != NULL) {
        node = solyaris->getNode([nid UTF8String]);
    }
    
    // check
    if (movie != NULL && node != NULL) {
        
        // formatter
        static NSDateFormatter *yearFormatter;
        if (yearFormatter == nil) {
            yearFormatter = [[NSDateFormatter alloc] init];
            [yearFormatter setDateFormat:@"yyyy"];
        }
        
        // properties
        node->renderLabel([movie.title UTF8String]);
        node->updateCategory([movie.category UTF8String]);
        if (movie.released) {
            node->updateMeta([[yearFormatter stringFromDate:movie.released] UTF8String]);
        }
        
        
        // actors
        NSSortDescriptor *psorter = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        NSArray *persons = [[movie.persons allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:psorter]];
        [psorter release];
        
        // enablers
        bool crew_enabled = [(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefaultBool:udGraphCrewEnabled];
        
        // create nodes
        for (Movie2Person *m2p in persons) {
            
            // exclude crew
            bool exclude_crew = NO;
            if (! crew_enabled && [m2p.type isEqualToString:typePersonCrew]) {
                exclude_crew = YES;
            }
            
            // child
            NSString *cid = [self makeNodeId:m2p.person.pid type:typePerson];
            NodePtr child = solyaris->getNode([cid UTF8String]);
            bool existing = true;
            if (child == NULL) {
                existing = false;
                 
                // new child
                if (! exclude_crew) {
                    child = solyaris->createNode([cid UTF8String],[typePerson UTF8String], node->pos.x, node->pos.y);
                    child->updateType([m2p.type UTF8String]);
                    child->renderLabel([m2p.person.name UTF8String]);
                }
            }
            
            // add to node
            if (! exclude_crew) {
                node->addChild(child);
            }
            
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
                    clabel = [SolyarisLocalization translateTMDbJob:m2p.job];
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
    NodePtr node;
    NSString *nid = [self makeNodeId:person.pid type:typePerson];
    if (person != NULL) {
        node = solyaris->getNode([nid UTF8String]);
    }
    
    // check node
    if (person != NULL && node != NULL) {
        
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
                child->renderLabel([m2p.movie.title UTF8String]);
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
                    clabel = [SolyarisLocalization translateTMDbJob:m2p.job];
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
 * Loaded movie data.
 */
- (void)loadedMovieData:(Movie *)movie {
    DLog();
    
    // nodes
    NSArray *nodes = [_dta_nodes objectForKey:[self makeNodeId:movie.mid type:typeMovie]];
    
    // information
    InformationViewController *informationViewController = [self controllerInformation];
    if (informationViewController) {
        
        // info
        [informationViewController informationMovie:movie nodes:nodes];
        
        // transition
        [self transitionInformationLoaded:informationViewController animated:YES];
    }

}

/*
 * Loaded movie related.
 */
- (void)loadedMovieRelated:(Movie*)movie more:(BOOL)more {
    DLog();
    
    // controller
    RelatedViewController *relatedViewController = [self controllerRelated];
    
    // loaded
    if (relatedViewController) {
        [relatedViewController loadedRelated:movie more:more];
    }
}

/*
 * Loaded person data.
 */
- (void)loadedPersonData:(Person *)person {
    DLog();
    
    // nodes
    NSArray *nodes = [_dta_nodes objectForKey:[self makeNodeId:person.pid type:typePerson]];
    
    // information
    InformationViewController *informationViewController = [self controllerInformation];
    if (informationViewController) {
        
        // info
        [informationViewController informationPerson:person nodes:nodes];
        
        // transition
        [self transitionInformationLoaded:informationViewController animated:YES];
    }

}

/*
 * API Info.
 */
- (void)apiInfo:(APIError *)error {
    FLog();
    
    // view
    [self.view bringSubviewToFront:_noteView];
    
    // note
    [_noteView noteInfo:error.errorTitle message:error.errorMessage]; 
    if (state_search) {
        [_noteView offset];
    }
    [_noteView showNote];
    [_noteView dismissNoteAfterDelay:4.5];
    
}



/*
 * API Glitch.
 */
- (void)apiGlitch:(APIError *)error {
    FLog();
    
    // view
    [self.view bringSubviewToFront:_noteView];
    
    // note
    [_noteView noteGlitch:error.errorTitle message:error.errorMessage]; 
    if (state_search) {
        [_noteView offset];
    }
    [_noteView showNote];
    
    // stop loader
    NSString *nid = [self makeNodeId:error.dataId type:error.dataType];
    NodePtr node = solyaris->getNode([nid UTF8String]);
    
    // check
    if (node != NULL) {
        
        // unload
        solyaris->unload(node);
    }
}


/*
* API Error.
*/
- (void)apiError:(APIError *)error {
    FLog();
    
    // view
    [self.view bringSubviewToFront:_noteView];
    
    // note
    [_noteView noteError:error.errorTitle message:error.errorMessage]; 
    if (state_search) {
        [_noteView offset];
    }
    [_noteView showNote];
    
    // stop loader
    NSString *nid = [self makeNodeId:error.dataId type:error.dataType];
    NodePtr node = solyaris->getNode([nid UTF8String]);
    
    // check
    if (node != NULL) {
        
        // unload
        solyaris->unload(node);
    }
}


/*
 * API Quit.
 */
- (void)apiFatal:(NSString *)title message:(NSString *)msg {
    FLog();
    
    // alert
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title 
                          message:msg 
                          delegate:self 
                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                          otherButtonTitles:NSLocalizedString(@"Quit", @"Quit"),nil];
    [alert setTag:SolyarisAlertAPIFatal];
    [alert show];    
    [alert release];
 
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
    if (node && ! node->isLoading()) {
        
        // flag
        node->load();
        
        // solyaris
        solyaris->load(node);
        
        // node
        NSNumber *dbid = [self toDBId:nid];
        
        // type
        NSString *type = [NSString stringWithCString:node->type.c_str() encoding:[NSString defaultCStringEncoding]];
        if (! [type isEqualToString:typeMovie]) {
            type = typePerson;
        }
        
        // track
        [Tracker trackEvent:TEventLoad action:@"Graph" label:type];
        
        
        // movie
        if ([type isEqualToString:typeMovie]) {
            [tmdb performSelector:@selector(movie:) withObject:dbid afterDelay:kDelayTimeNodeLoad];
        }
        // person
        else {
            [tmdb performSelector:@selector(person:) withObject:dbid afterDelay:kDelayTimeNodeLoad];
        }
        
    }
    
}

/**
 * Node information.
 */
- (void)nodeInfo:(NSString*)nid {
    GLog();
    
    // track
    [Tracker trackEvent:TEventNode action:@"Action" label:@"info"];
    
    // info
    [self nodeInformation:nid];
    
}
- (void)nodeInformation:(NSString*)nid {
    DLog();
    
    // rater
    [Rater userDidSignificantEvent:NO];
    
    // node
    NodePtr node = solyaris->getNode([nid UTF8String]);
    
    // info
    if (node->isActive()) {
        
        // parent
        NSString *pid = [NSString stringWithCString:node->nid.c_str() encoding:[NSString defaultCStringEncoding]];
        
        // type
        NSString *ntype = [NSString stringWithCString:node->type.c_str() encoding:[NSString defaultCStringEncoding]];
        
        // nodes
        NSMutableArray *nodes = [[NSMutableArray alloc] init];
        
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
            NSString *thumb = [type isEqualToString:typeMovie] ? [tmdb movieThumb:nid] : [tmdb personThumb:nid];
            bool visible = (*child)->isVisible();
            bool loaded = ( (*child)->isActive() || (*child)->isLoading() );
            
            // data
            DataEdge *dtaEdge = [[DataEdge alloc] initData:eid type:etype label:elabel];
            DataNode *dtaNode = [[DataNode alloc] initData:nid type:type label:label meta:meta thumb:thumb edge:dtaEdge visible:visible loaded:loaded];
            [nodes addObject:dtaNode];
            [dtaEdge release];
            [dtaNode release];
            
        }
        
        // save
        [_dta_nodes setObject:nodes forKey:nid];
        [nodes release];
        
        // controller
        [self controllerInformation:YES animated:YES];
        
        // movie
        if ([ntype isEqualToString:typeMovie]) {
            [tmdb movieData:[self toDBId:pid]];
        }
        // person
        else {
            [tmdb personData:[self toDBId:pid]];
        }
        
    }
    
}


/**
 * Node related.
 */
- (void)nodeRelated:(NSString*)nid {
    DLog();
    
    // track
    [Tracker trackEvent:TEventNode action:@"Action" label:@"related"];
    
    // node
    NodePtr node = solyaris->getNode([nid UTF8String]);
    if (node->isActive()) {
        
        // controller
        [self controllerRelated:YES animated:YES];
        
        // prepare
        RelatedViewController *relatedViewController = [self controllerRelated];
        if (relatedViewController) {
            
            // adjust position
            Vec3d npos = solyaris->nodeCoordinates(node);
            CGPoint offset = [relatedViewController position:npos.z posx:npos.x posy:npos.y];
            solyaris->graphShift(offset.x,offset.y);
            
            // query related
            NSNumber *dbid = [self toDBId:nid];
            [tmdb movieRelated:dbid more:NO];
        }
    }
}


/**
 * Node close.
 */
- (void)nodeClose:(NSString*)nid {
    DLog();
    
    // track
    [Tracker trackEvent:TEventNode action:@"Action" label:@"close"];
    
    // node
    NodePtr node = solyaris->getNode([nid UTF8String]);
    
    // close
    if (node->isActive()) {
        node->close();
    }
}



#pragma mark -
#pragma mark Actions

/*
 * Settings.
 */
- (void)actionSettings:(id)sender {
	DLog();
	
	// controller
    [self controllerSettings:!state_settings animated:YES];
}



#pragma mark -
#pragma mark SearchDelegate


/* 
 * Search selected.
 */
- (void)searchSelected:(NSNumber*)dbid type:(NSString*)type {
    FLog();
    
    // disable
    [_searchBarViewController enable:NO];
    
    // un tab
    [self controllerSearch:NO animated:YES];
    
    // node
    NSString *nid = [self makeNodeId:dbid type:type];
    NodePtr node = solyaris->getNode([nid UTF8String]);
    if (node == NULL) {
        node = solyaris->createNode([nid UTF8String],[type UTF8String]);
    }
    
    // active
    if (! (node->isActive() || node->isLoading())) {
        
        // track
        [Tracker trackEvent:TEventLoad action:@"Search" label:type];
        
        // load
        node->load();
            
        // movie
        if ([type isEqualToString:typeMovie]) {
            [tmdb movie:dbid];
        }
        
        // person
        if ([type isEqualToString:typePerson]) {
            [tmdb person:dbid];
        }


    }
}

/*
 * Search close.
 */
- (void)searchClose {
    FLog();
    
    // disable
    [_searchBarViewController enable:NO];
    
    // hide
    [self controllerSearch:NO animated:YES];
}




#pragma mark -
#pragma mark SearchBarDelegate 

/**
 * Search bar.
 */
- (void)searchBarPrepare {
    FLog();
    
    // show
    [self controllerSearch:YES animated:YES];
    
}
- (void)searchBarCancel {
    FLog();
    
    // hide
    [self controllerSearch:NO animated:YES];
}



#pragma mark -
#pragma mark Search 


/*
 * Search.
 */
- (void)search:(NSString*)q type:(NSString*)type {
    FLog();
    
    // track
    if (! [[NSUserDefaults standardUserDefaults] objectForKey:udSearchSection]) {
        [Tracker trackEvent:TEventSearch action:type label:q];
    }
    
    // data    
    SearchViewController *searchViewController = [self controllerSearch];
    if (searchViewController) {
        [searchViewController dbdata];
    }
    
    // api
    if ([type isEqualToString:typePerson]) {
        [tmdb searchPerson:q];
    }
    else {
        [tmdb searchMovie:q];
    }
    
}

/*
 * Popular.
 */
- (void)popular:(NSString*)type more:(BOOL)more {
    FLog();
    
    // api
    if ([type isEqualToString:typeMovie]) {
        [tmdb popularMovies:more];
    }
}

/*
 * Now Playing.
 */
- (void)nowPlaying:(NSString*)type more:(BOOL)more {
    FLog();
    
    // api
    if ([type isEqualToString:typeMovie]) {
        [tmdb nowPlaying:more];
    }
}

/*
 * History.
 */
- (void)history:(NSString *)type {
    FLog();
    
    // api
    if ([type isEqualToString:typeMovie]) {
        [tmdb historyMovie];
    }
    else if ([type isEqualToString:typePerson]) {
        [tmdb historyPerson];
    }
}


/*
 * Resets the graph.
 */
- (void)reset {
    DLog();
    
    // data
    [_dta_nodes removeAllObjects];
    
    // app reset
    solyaris->reset();

}

/*
 * Logo stuff.
 */
- (void)logo {
    DLog();
    
    // random tagline
    [self randomTagline];

}




#pragma mark -
#pragma mark InformationDelegate


/* 
 * Information selected.
 */
- (void)informationSelected:(NSNumber *)nid type:(NSString *)type {
    DLog();
    
    // type
    NSString *t = typePerson;
    if ([type isEqualToString:typeMovie]) {
        t = typeMovie;
    }
    
    // node
    NSString *iid = [self makeNodeId:nid type:t];
    NodePtr node = solyaris->getNode([iid UTF8String]);
    if (node == NULL) {
        node = solyaris->createNode([iid UTF8String],[t UTF8String], 0, 0);
    }
    
    // active
    if (! (node->isActive() || node->isLoading())) {
        
        // track
        [Tracker trackEvent:TEventLoad action:@"Info" label:type];
        
        // tap & load
        node->tapped();
        node->load();
        
        // solyaris
        solyaris->load(node);
        
        // movie
        if ([t isEqualToString:typeMovie]) {
            [tmdb movie:nid];
        }
        // person
        else {
            [tmdb person:nid];
        }
        
    }
    
    // dismiss
    if (! iPad) {
        [self informationDismiss];
    }
    
}


/* 
 * Dismiss information.
 */
- (void)informationDismiss {
    FLog();
    
    // controller
    [self controllerInformation:NO animated:YES];

}



#pragma mark -
#pragma mark RelatedDelegate


/* 
 * Related selected.
 */
- (void)relatedSelected:(DBData*)data {
    FLog();
    
    // controller
    [self controllerRelated:NO animated:YES];
    
    // source
    NSString *sid = [self makeNodeId:data.src type:typeMovie];
    NodePtr source = solyaris->getNode([sid UTF8String]);
    if (source == NULL) {
        source = solyaris->createNode([sid UTF8String],[typeMovie UTF8String]);
    }
    
    // node
    NSString *nid = [self makeNodeId:data.ref type:typeMovie];
    NodePtr node = solyaris->getNode([nid UTF8String]);
    if (node == NULL) {
        node = solyaris->createNode([nid UTF8String],[typeMovie UTF8String]);
    }
    
    // connection
    ConnectionPtr connection = solyaris->getConnection([sid UTF8String], [nid UTF8String]);
    if (connection == NULL) {
        
        // create
        NSString *cid = [self makeConnectionId:sid to:nid];
        connection = solyaris->createConnection([cid UTF8String],[connRelated UTF8String],source,node);
        
        // connect it
        source->connect(node);
    }
    
    // active
    if (! (node->isActive() || node->isLoading())) {
        
        // track
        [Tracker trackEvent:TEventLoad action:@"Related" label:typeMovie];
        
        // load
        node->load();
        
        // solyaris
        solyaris->load(node);
        
        // movie
        [tmdb movie:data.ref];
        
    }
    
}

/*
 * Related more.
 */
- (void)relatedLoadMore:(DBData*)data {
    FLog();
    
    // api
    [tmdb movieRelated:data.src more:YES];
    
}


/*
 * Related close.
 */
- (void)relatedClose {
    FLog();
    
    // controller
    [self controllerRelated:NO animated:YES];
}




#pragma mark -
#pragma mark SettingsDelegate

/* 
 * Dismiss settings.
 */
- (void)settingsDismiss {
    FLog();
    
    // hide
    [self actionSettings:self];
    
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
    [tmdb resetCache];
    
    // images
    [CacheImageView clearCache];
    
    // defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:udSearchSection];
    [defaults removeObjectForKey:udSearchType];
    [defaults synchronize];
    
    // reset 
    [self reset];
    
}

/*
 * Help, I need somebody, help.
 */
- (void)settingsHelp {
    FLog();
    
    // reset
    [self reset];
    
    // dismiss
    [self settingsDismiss];
    
    // help
    [self performSelector:@selector(help) withObject:nil afterDelay:kAnimateTimeSettingsHide*2];
    
}



#pragma mark -
#pragma mark Splash Delegate

/*
 * Splash dismiss.
 */
- (void)splashDismiss {
    FLog();
    
    // mode
    state_splash = NO;
    
}



#pragma mark -
#pragma mark Controllers

/*
 * Controller search.
 */
- (void)controllerSearch:(BOOL)show animated:(BOOL)animated {
    FLog();
    
    // search
    if (show) {
        
        // state
        if (state_search) {
            FLog("state_search");
            return;
        }
        state_search = YES;
        
        // frames
        CGRect fSelf = self.view.frame;
        CGRect frameSearch = iPad ? CGRectMake(0, 40, 360,439) : CGRectMake(0, 40, fSelf.size.width,fSelf.size.height-40);
        
        // controller
        SearchViewController *searchViewController = [[SearchViewController alloc] initWithFrame:frameSearch];
        searchViewController.delegate = self;
        
        // transition
        [self transitionSearch:searchViewController animated:animated];
        [searchViewController release];
    }
    // dismiss
    else {
        
        // controller
        SearchViewController *searchViewController = [self controllerSearch];
        searchViewController.delegate = nil;
        
        // transition
        if (searchViewController) {
            [self transitionSearchDismiss:searchViewController animated:animated];
        }
        
        // state
        state_search = NO;
        
    }
}
- (SearchViewController*)controllerSearch {
    SearchViewController *searchViewController = nil;
    for (UIViewController *controller in self.childViewControllers) {
        if ([controller isKindOfClass:NSClassFromString(@"SearchViewController")]) {
            searchViewController = (SearchViewController*) controller;
            break;
        }
    }
    return searchViewController;
}


/*
 * Controller information.
 */
- (void)controllerInformation:(BOOL)show animated:(BOOL)animated {
    FLog();
    
    // information
    if (show) {
        
        // state
        if (state_info) {
            FLog("state_info");
            return;
        }
        state_info = YES;
        
        // frame
        CGRect fSelf = self.view.frame;
        CGRect frameInformation = iPad ? CGRectMake(0, 0, 580, 624) : CGRectMake(0, 0, fSelf.size.width, fSelf.size.height);
        
        // information
        InformationViewController *informationViewController = [[InformationViewController alloc] initWithFrame:frameInformation];
        informationViewController.delegate = self;
        
        // transition
        [self transitionInformation:informationViewController animated:animated];
        [informationViewController release];
    }
    // dismiss
    else {
        
        // controller
        InformationViewController *informationViewController = [self controllerInformation];
        informationViewController.delegate = nil;
        
        // transition
        if (informationViewController) {
            [self transitionInformationDismiss:informationViewController animated:animated];
        }
        
        // state
        state_info = NO;
    }
}
- (InformationViewController*)controllerInformation {
    InformationViewController *informationViewController = nil;
    for (UIViewController *controller in self.childViewControllers) {
        if ([controller isKindOfClass:NSClassFromString(@"InformationViewController")]) {
            informationViewController = (InformationViewController*) controller;
            break;
        }
    }
    return informationViewController;
}

/*
 * Controller settings.
 */
- (void)controllerSettings:(BOOL)show animated:(BOOL)animated {
    FLog();
    
    // settings
    if (show) {
        
        // state
        if (state_settings) {
            FLog("state_settings");
            return;
        }
        state_settings = YES;
        
        // frame
        CGRect fSelf = self.view.frame;
        CGRect frameSettings = iPad ? CGRectMake(0, 0, 708, kOffsetSettings) : CGRectMake(0, 0, fSelf.size.width, fSelf.size.height);
        
        // settings
        SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithFrame:frameSettings];
        settingsViewController.delegate = self;
        
        // transition
        [self transitionSettings:settingsViewController animated:animated];
        [settingsViewController release];
    }
    // dismiss
    else {
        
        // controller
        SettingsViewController *settingsViewController = [self controllerSettings];
        settingsViewController.delegate = nil;
        
        // transition
        if (settingsViewController) {
            [self transitionSettingsDismiss:settingsViewController animated:animated];
        }
        
        // state
        state_settings = NO;
    }
}
- (SettingsViewController*)controllerSettings {
    SettingsViewController *settingsViewController = nil;
    for (UIViewController *controller in self.childViewControllers) {
        if ([controller isKindOfClass:NSClassFromString(@"SettingsViewController")]) {
            settingsViewController = (SettingsViewController*) controller;
            break;
        }
    }
    return settingsViewController;
}


/*
 * Controller related.
 */
- (void)controllerRelated:(BOOL)show animated:(BOOL)animated {
    FLog();
    
    // related
    if (show) {
        
        // state
        if (state_related) {
            FLog("state_related");
            return;
        }
        state_related = YES;
        
        // frame
        CGRect frameRelated = iPad ? CGRectMake(0, 0, 320, 275) : CGRectMake(0, 0, 280, 275);
        
        // controller
        RelatedViewController *relatedViewController = [[RelatedViewController alloc] initWithFrame:frameRelated];
        relatedViewController.delegate = self;
        
        // transition
        [self transitionRelated:relatedViewController animated:animated];
        [relatedViewController release];
    }
    // dismiss
    else {
        
        // controller
        RelatedViewController *relatedViewController = [self controllerRelated];
        relatedViewController.delegate = nil;
        
        // transition
        if (relatedViewController) {
            [self transitionRelatedDismiss:relatedViewController animated:animated];
        }
        
        // state
        state_related = NO;
        
    }
    
}
- (RelatedViewController*)controllerRelated {
    RelatedViewController *relatedViewController = nil;
    for (UIViewController *controller in self.childViewControllers) {
        if ([controller isKindOfClass:NSClassFromString(@"RelatedViewController")]) {
            relatedViewController = (RelatedViewController*) controller;
            break;
        }
    }
    return relatedViewController;
}



#pragma mark -
#pragma mark Transitions

/*
 * Transition search.
 */
- (void)transitionSearch:(SearchViewController*)search animated:(BOOL)animated {
    FLog();
    
    // controller
    [self addChildViewController:search];
    [self.view addSubview:search.view];
    [self.view bringSubviewToFront:search.view];
    
    // prepare
    search.modalView.alpha = 0.0f;
    
    // content view
    CGRect contentFrame = search.contentView.frame;
    contentFrame.origin.y = self.view.frame.size.height;
    search.contentView.frame = contentFrame;
    
    contentFrame.origin.y = 0;
    
    // animate
    [UIView animateWithDuration:animated ? kAnimateTimeSearchShow : 0
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         search.modalView.alpha = kAlphaModalSearch;
                         search.contentView.frame = contentFrame;
                        }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (void)transitionSearchDismiss:(SearchViewController*)search animated:(BOOL)animated {
    FLog();
    
    // prepare
    CGRect contentFrame = search.contentView.frame;
    contentFrame.origin.y = self.view.frame.size.height;
    
    // animate
    [search willMoveToParentViewController:nil];
    [UIView animateWithDuration:animated ? kAnimateTimeSearchHide : 0
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         search.modalView.alpha = 0.0f;
                         search.contentView.frame = contentFrame;
                     }
                     completion:^(BOOL finished) {
                         
                         // controller
                         [search.view removeFromSuperview];
                         [search removeFromParentViewController];
                         
                         // track
                         [Tracker trackView:@"Solyaris"];
                     }];
}

/*
 * Transition information.
 */
- (void)transitionInformation:(InformationViewController *)information animated:(BOOL)animated {
    FLog();
    
    // controller
    [self addChildViewController:information];
    [self.view addSubview:information.view];
    [self.view bringSubviewToFront:information.view];
    
    // prepare
    information.modalView.alpha = 0.0f;
    information.contentView.hidden = YES;
    
    
    // animate
    [UIView animateWithDuration:animated ? kAnimateTimeInformationLoad : 0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         information.modalView.alpha = kAlphaModalInfo;
                     }
                     completion:^(BOOL finished) {
                     }];
    
    // loader
    [self performSelector:@selector(transitionInformationLoader) withObject:nil afterDelay:animated ? kAnimateTimeInformationLoad : 0];
    
}
- (void)transitionInformationLoader {
	GLog();
    
    // loader
    InformationViewController *informationViewController = [self controllerInformation];
    if (informationViewController) {
        [informationViewController loading:YES];
    }
    
}
- (void)transitionInformationLoaded:(InformationViewController*)information animated:(BOOL)animated; {
	FLog();
    
    // stop loader
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(transitionInformationLoader) object:nil];
    [information loading:NO];
    
    // prepare
    CGPoint informationCenter = information.contentView.center;
    informationCenter.y += self.view.frame.size.height;
    information.contentView.center = informationCenter;
    information.contentView.hidden = NO;
    
    informationCenter.y -= self.view.frame.size.height;
    
    // animate
    [UIView animateWithDuration:animated ? kAnimateTimeInformationShow : 0
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         information.modalView.alpha = kAlphaModalInfo;
                         information.contentView.center = informationCenter;
                     }
                     completion:^(BOOL finished) {
                     }];
    
}
- (void)transitionInformationDismiss:(InformationViewController *)information animated:(BOOL)animated {
    FLog();
    
    // prepare
    CGPoint informationCenter = information.contentView.center;
    informationCenter.y += self.view.frame.size.height;
    
    // animate
    [information willMoveToParentViewController:nil];
    [UIView animateWithDuration:animated ? kAnimateTimeInformationHide : 0
                          delay:0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         information.modalView.alpha = 0.0f;
                         information.contentView.center = informationCenter;
                     }
                     completion:^(BOOL finished) {
                         
                         // controller
                         [information.view removeFromSuperview];
                         [information removeFromParentViewController];
                         
                         // track
                         [Tracker trackView:@"Solyaris"];

                     }];
}

/*
 * Transition settings.
 */
- (void)transitionSettings:(SettingsViewController*)settings animated:(BOOL)animated {
    FLog();
    
    // controller
    [self addChildViewController:settings];
    [self.view addSubview:settings.view];
    [self.view bringSubviewToFront:settings.view];
    
    // calculate centers
    CGPoint settingsCenter = settings.contentView.center;
    settingsCenter.y += kOffsetSettings;
    settings.contentView.center = settingsCenter;
    settingsCenter.y -= kOffsetSettings;
    
    CGPoint searchCenter = _searchBarViewController.view.center;
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
    [UIView animateWithDuration:animated ? kAnimateTimeSettingsShow : 0
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         settings.contentView.center = settingsCenter;
                         _searchBarViewController.view.center = searchCenter;
                         _buttonSettings.center = buttonCenter;
                         _cinderView.center = cinderCenter;
                     }
                     completion:^(BOOL finished) {
                     }];
}
- (void)transitionSettingsDismiss:(SettingsViewController *)settings animated:(BOOL)animated {
    FLog();
    
    // calculate centers
    CGPoint settingsCenter = settings.contentView.center;
    settingsCenter.y += kOffsetSettings;
    
    CGPoint searchCenter = _searchBarViewController.view.center;
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
    [settings willMoveToParentViewController:nil];
    [UIView animateWithDuration:animated ? kAnimateTimeSettingsHide : 0
                          delay:0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         settings.contentView.center = settingsCenter;
                         _searchBarViewController.view.center = searchCenter;
                         _buttonSettings.center = buttonCenter;
                         _cinderView.center = cinderCenter;
                     }
                     completion:^(BOOL finished) {
                         
                         // controller
                         [settings.view removeFromSuperview];
                         [settings removeFromParentViewController];
                         
                         // track
                         [Tracker trackView:@"Solyaris"];
                         
                     }];
}

/*
 * Transition related.
 */
- (void)transitionRelated:(RelatedViewController *)related animated:(BOOL)animated {
    FLog();
    
    // controller
    [self addChildViewController:related];
    [self.view addSubview:related.view];
    [self.view bringSubviewToFront:related.view];
    
    // prepare
    related.modalView.alpha = 0.0f;
    related.contentView.alpha = 0.0f;
    
    // animate
    [UIView animateWithDuration:animated ? kAnimateTimeRelatedShow : 0
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         related.modalView.alpha = kAlphaModalRelated;
                         related.contentView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                     }];
}
- (void)transitionRelatedDismiss:(RelatedViewController *)related animated:(BOOL)animated {
    FLog();
    
    // prepare
    related.modalView.alpha = kAlphaModalRelated;
    related.contentView.alpha = 1.0f;
    
    // animate
    [related willMoveToParentViewController:nil];
    [UIView animateWithDuration:animated ? kAnimateTimeRelatedHide : 0
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         related.modalView.alpha = 0.0f;
                         related.contentView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         
                         // controller
                         [related.view removeFromSuperview];
                         [related removeFromParentViewController];
                         
                         // track
                         [Tracker trackView:@"Solyaris"];
                     }];
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
 * Connection id.
 */
- (NSString*)makeConnectionId:(NSString *)sid to:(NSString *)nid {
    
    // connect this
    return [NSString stringWithFormat:@"%@_connection_%@",sid,nid];
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

/*
 * Generates a random tagline.
 */
- (void)randomTagline {
    FLog();
    
    // random tagline
    NSArray *movies = [tmdb movies];
    NSMutableArray *taglines = [[NSMutableArray alloc] init];
    for (Movie *m in movies) {
        
        // loaded
        if (m.loaded) {
            
            // tagline
            NSString *tagline = m.tagline;
            if (tagline && [tagline length] > 1 && [tagline length] < 36) {
                [taglines addObject:tagline];
            }
        }
        
    }
    
    // check
    NSString *tagline = NSLocalizedString(@"Visual Movie Browser", @"Visual Movie Browser");
    if ([taglines count] > 0) {
        tagline = [taglines objectAtIndex:random() % ([taglines count])];
    }
    
    // release
    [taglines release];
    
    // set
    [_searchBarViewController claim:tagline];
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
            
        // default
		default:
			break;
	}
	
	
}




#pragma mark -
#pragma mark Memory management

/*
 * Deallocates used memory.
 */
- (void)dealloc {
	GLog();
	
    // controllers
    [_noteView release];
    [_searchBarViewController release];
    
    // data
    [_dta_nodes release];
    
    // notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// release global
    [super dealloc];
}

@end
