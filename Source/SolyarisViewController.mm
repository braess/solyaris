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


/**
 * Helper Stack.
 */
@interface SolyarisViewController (Animations)
- (NSString*)makeNodeId:(NSNumber*)nid type:(NSString*)type;
- (NSString*)makeEdgeId:(NSString*)pid to:(NSString*)cid;
- (NSNumber*)toDBId:(NSString*)nid;
- (void)randomTagline;
@end



/**
 * Animation Stack.
 */
@interface SolyarisViewController (AnimationHelpers)
- (void)animationInformationLoad;
- (void)animationInformationLoadDone;
- (void)animationInformationShow;
- (void)animationInformationShowDone;
- (void)animationInformationHide;
- (void)animationInformationHideDone;
- (void)animationSettingsShow;
- (void)animationSettingsShowDone;
- (void)animationSettingsHide;
- (void)animationSettingsHideDone;
- (void)animationSearchShow;
- (void)animationSearchShowDone;
- (void)animationSearchHide;
- (void)animationSearchHideDone;
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
#define kDelayTimeNodeLoad              1.3f
#define kDelayTimeStartup               3.3f
#define kAnimateTimeInformationLoad     0.45f
#define kAnimateTimeInformationShow     (iPad ? 0.6f : 0.45f)
#define kAnimateTimeInformationHide     (iPad ? 0.45f : 0.33f)
#define kAnimateTimeSearchShow          0.3f
#define kAnimateTimeSearchHide          0.3f
#define kAnimateTimeSettingsShow        0.6f
#define kAnimateTimeSettingsHide        0.3f
#define kOffsetSettings                 480
#define kAlphaModalInfo                 0.3f
#define kAlphaModalSearch               0.03f


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
    
    // window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // frames
    CGRect frame = iPad ? CGRectMake(0, 0, 768, 1024) : CGRectMake(0, 0, 320, 480);
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        frame = iPad ? CGRectMake(0, 0, 1024, 768) : CGRectMake(0, 0, 480, 320);
    }
    CGRect frameSearchBar = CGRectMake(0, 0, frame.size.width, 40);
    CGRect frameSearch = iPad ? CGRectMake(0, 40, 360,439) : CGRectMake(0, 40, 320,480-40);
    CGRect frameInformation = iPad ? CGRectMake(0, 0, 580, 624) : CGRectMake(0, 0, 320, 480);
    CGRect frameSettings = iPad ? CGRectMake(0, 0, 708, kOffsetSettings) : CGRectMake(0, 0, 320, kOffsetSettings);
    CGRect frameSettingsButton = CGRectMake(frame.size.width-44, frame.size.height-44, 44, 44);
    
    
    // view
    self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.opaque = NO;
    self.view.multipleTouchEnabled = YES;
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor clearColor];
    [window addSubview:self.view];
    
    
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
    [searchBarViewController loadView];
    _searchBarViewController = [searchBarViewController retain];
    [self.view addSubview:_searchBarViewController.view];
    [self.view bringSubviewToFront:_searchBarViewController.view];
    [searchBarViewController release];
    
    
    // search
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithFrame:frameSearch];
    searchViewController.delegate = self;
    searchViewController.view.hidden = YES;
    
    _searchViewController = [searchViewController retain];
    [self.view addSubview:_searchViewController.view];
    [self.view sendSubviewToBack:_searchViewController.view];
	[searchViewController release];

    
    // information
    InformationViewController *informationViewController = [[InformationViewController alloc] initWithFrame:frameInformation];
    informationViewController.delegate = self;
    [informationViewController loadView];
    _informationViewController = [informationViewController retain];
    [self.view addSubview:_informationViewController.view];
    [self.view sendSubviewToBack:_informationViewController.view];
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
    
    
    // fluff cinder view
    for (UIView *subview in window.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"CinderViewCocoaTouch")]) {
            _cinderView = (CinderViewCocoaTouch*) [subview retain];
            break;
        }
    }
    
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
    
    // mode
    mode_splash = iPad ? NO : YES; // avoids rotation
    
    
    // notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activate) name: UIApplicationDidBecomeActiveNotification object:nil];

}



#pragma mark -
#pragma mark Application

/*
 * Activates the controller.
 */
- (void)activate {
    FLog();
    
    // track
    if (_informationViewController.view.hidden && _settingsViewController.view.hidden) {
        [Tracker trackPageView:@"/graph"];
    }
    
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
    
    // note deprecated
    Note *deprecated = [Note retrieveNote:noteAppDeprecated];
    if (deprecated) {
        
        // view
        [self.view bringSubviewToFront:_noteView];
        
        // note
        [_noteView noteInfo:deprecated.title message:deprecated.message];
        [_noteView showNoteAfterDelay:kDelayTimeStartup*1.5];
    }
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
        [_noteView dismissNoteAfterDelay:kDelayTimeStartup*1.25+3.9];
    }
}




#pragma mark -
#pragma mark Rotation support

/*
 * Rotate is the new black.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    // maybe baby
    return ! (mode_settings || mode_splash);
}

/*
 * Prepare rotation.
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    FLog();

    // hide settings
    if (! iPad) {
        _buttonSettings.hidden = (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) ? YES : NO;
    }

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
        _cinderView.bounds = iPad ? CGRectMake(0.0, 0.0, 768, 1024) : CGRectMake(0.0, 0.0, 320, 480);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {      
        _cinderView.transform = CGAffineTransformIdentity;
        _cinderView.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        _cinderView.bounds = iPad ? CGRectMake(0.0, 0.0, 1024, 768) : CGRectMake(0.0, 0.0, 480, 320);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {      
        _cinderView.transform = CGAffineTransformIdentity;
        _cinderView.transform = CGAffineTransformMakeRotation(M_PI);
        _cinderView.bounds = iPad ? CGRectMake(0.0, 0.0, 768, 1024) : CGRectMake(0.0, 0.0, 320, 480);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {      
        _cinderView.transform = CGAffineTransformIdentity;
        _cinderView.transform = CGAffineTransformMakeRotation(- M_PI * 0.5);
        _cinderView.bounds = iPad ? CGRectMake(0.0, 0.0, 1024, 768) : CGRectMake(0.0, 0.0, 480, 320);
    }
    [UIView commitAnimations];

    
    // resize
    [_searchBarViewController resize];
    [_searchViewController resize];
    [_informationViewController resize];
}


/*
 * Cleanup rotation.
 */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    GLog();
    
    // resize
    [_searchBarViewController resize];
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
#pragma mark Gestures




/*
 * Pinched.
 */
- (void)pinched:(UIPinchGestureRecognizer *)recognizer {
    GLog();
    
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
    [_searchViewController loadedSearch:result];
    
}

/*
 * Loaded popular.
 */
- (void)loadedPopular:(Popular*)popular more:(BOOL)more {
    DLog();

    // loaded
    [_searchViewController loadedPopular:popular more:more];
}

/*
 * Loaded now playing.
 */
- (void)loadedNowPlaying:(NowPlaying*)nowplaying more:(BOOL)more {
    DLog();
    
    // loaded
    [_searchViewController loadedNowPlaying:nowplaying more:more];
}

/*
 * Loaded now playing.
 */
- (void)loadedHistory:(NSArray *)history type:(NSString *)type {
    DLog();
    
    // loaded
    [_searchViewController loadedHistory:history type:type];
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
        node->renderLabel([movie.name UTF8String]);
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
    [_informationViewController informationMovie:movie nodes:nodes];
    
    // animate
    [self animationInformationShow]; 
}

/*
 * Loaded person data.
 */
- (void)loadedPersonData:(Person *)person {
    DLog();
    
    // nodes
    NSArray *nodes = [_dta_nodes objectForKey:[self makeNodeId:person.pid type:typePerson]];
    
    // information
    [_informationViewController informationPerson:person nodes:nodes];
    
    // animate
    [self animationInformationShow]; 
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
    if (mode_search) {
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
    if (mode_search) {
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
    if (mode_search) {
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
#pragma mark Search Delegate


/* 
 * Data selected.
 */
- (void)dataSelected:(DBData*)data {
    FLog();
    
    // disable
    [_searchBarViewController enable:NO];
    
    // un tab
    [self animationSearchHide];
    
    
    // node
    NSString *nid = [self makeNodeId:data.ref type:data.type];
    NodePtr node = solyaris->getNode([nid UTF8String]);
    if (node == NULL) {
        node = solyaris->createNode([nid UTF8String],[data.type UTF8String]);
    }
    
    // active
    if (! (node->isActive() || node->isLoading())) {
        
        // track
        [Tracker trackEvent:TEventLoad action:@"Search" label:data.type];
        
        // load
        node->load();
            
        // movie
        if ([data.type isEqualToString:typeMovie]) {
            [tmdb movie:data.ref];
        }
        
        // person
        if ([data.type isEqualToString:typePerson]) {
            [tmdb person:data.ref];
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
    [self animationSearchHide];
}





#pragma mark -
#pragma mark Information Delegate


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
#pragma mark SearchBarDelegate 

/**
 * Search bar.
 */
- (void)searchBarPrepare {
    FLog();
    
    // show
    [self animationSearchShow];
    
}
- (void)searchBarChanged:(NSString*)txt {
    GLog();
    
    // reset
    [_searchViewController searchChanged:txt];
}
- (void)searchBarCancel {
    FLog();
    
    // hide
    [self animationSearchHide];
}



#pragma mark -
#pragma mark Search 


/*
 * Search.
 */
- (void)search:(NSString*)q type:(NSString*)type {
    FLog();
    
    // track
    [Tracker trackEvent:TEventSearch action:type label:q];
    
    // reset
    [_searchViewController dataLoading];
    
    
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
    
    // track
    [Tracker trackEvent:TEventSearch action:@"Popular" label:type];
    
    // loading
    if (!more) {
        [_searchViewController dataLoading];
    }
    
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
    
    // track
    [Tracker trackEvent:TEventSearch action:@"Now Playing" label:type];
    
    // loading
    if (!more) {
        [_searchViewController dataLoading];
    }
    
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
    
    // track
    [Tracker trackEvent:TEventSearch action:@"History" label:type];
    
    // loading
    [_searchViewController dataLoading];
    
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
    [tmdb resetCache];
    
    // images
    [CacheImageView clearCache];
    
    // search
    [_searchViewController reset];
    
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
    mode_splash = NO;
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
        
        // track
        [Tracker trackPageView:@"/settings"];
        
        // show
        [self animationSettingsShow];
    }
    else {
        
        // track
        [Tracker trackPageView:@"/graph"];
        
        // hide
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
- (void)nodeInformation:(NSString*)nid {
    DLog();
    
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
        
        // loader
        [self animationInformationLoad];
        
        
        // movie
        if ([ntype isEqualToString:typeMovie]) {
            
            // data
            [tmdb dataMovie:[self toDBId:pid]];

        }
        else {
            
            // data
            [tmdb dataPerson:[self toDBId:pid]];

        }
        

    }
    
}




#pragma mark -
#pragma mark Animations


/**
 * Shows the information loader.
 */
- (void)animationInformationLoad {
	GLog();
	
    // prepare controllers
	[_informationViewController viewWillAppear:YES];
    
	// prepare views
    _informationViewController.view.hidden = NO;
	_informationViewController.modalView.alpha = 0.0f;
    [self.view bringSubviewToFront:_informationViewController.view];
    
	// animate
	[UIView beginAnimations:@"information_load" context:nil];
	[UIView setAnimationDuration:kAnimateTimeInformationLoad];
    _informationViewController.modalView.alpha = kAlphaModalInfo;
	[UIView commitAnimations];
    
	// clean it up
	[self performSelector:@selector(animationInformationLoadDone) withObject:nil afterDelay:kAnimateTimeInformationLoad];
}
- (void)animationInformationLoadDone {
	GLog();
    
    // starts the loader
    [_informationViewController loading:YES];
    
}


/**
 * Shows the information.
 */
- (void)animationInformationShow {
	GLog();
    
    // cancel
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animationInformationLoad) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animationInformationLoadDone) object:nil];
    
	// offset
    CGPoint informationCenter = _informationViewController.contentView.center;
    informationCenter.y += self.view.frame.size.height;
    _informationViewController.contentView.center = informationCenter;

    informationCenter.y -= self.view.frame.size.height;
    
    
    // prepare controlers
    [_informationViewController loading:NO];
    
    // prepare views
    _informationViewController.view.hidden = NO;
    [self.view bringSubviewToFront:_informationViewController.view];
    
    
	// animate
	[UIView beginAnimations:@"information_show" context:nil];
	[UIView setAnimationDuration:kAnimateTimeInformationShow];
    _informationViewController.modalView.alpha = kAlphaModalInfo;
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
	GLog();
	
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
    [_informationViewController.contentView setHidden:YES];
    [self.view sendSubviewToBack:_informationViewController.view];
    
    // controller
    [_informationViewController viewDidDisappear:YES];
    
    // center
    CGPoint informationCenter = _informationViewController.contentView.center;
    informationCenter.y -= self.view.frame.size.height;
    _informationViewController.contentView.center = informationCenter;
    
    // modal
     _informationViewController.modalView.alpha = 0.0f;
    
}


/**
 * Shows the search.
 */
- (void)animationSearchShow {
	GLog();
    
    // state
    mode_search = YES;
	
	// prepare controllers
	[_searchViewController viewWillAppear:YES];
    
	// prepare views
    _searchViewController.view.hidden = NO;
    [self.view bringSubviewToFront:_searchViewController.view];
    
    // modal view
    _searchViewController.modalView.alpha = 0.0f;
    
    // content view
    CGRect contentFrame = _searchViewController.contentView.frame;
    contentFrame.origin.y = self.view.frame.size.height;
    _searchViewController.contentView.frame = contentFrame;
    
    contentFrame.origin.y = 0;
    
	// animate
	[UIView beginAnimations:@"search_show" context:nil];
	[UIView setAnimationDuration:kAnimateTimeSearchShow];
    _searchViewController.modalView.alpha = kAlphaModalSearch;
    _searchViewController.contentView.frame = contentFrame;
	[UIView commitAnimations];
    
	// clean it up
	[self performSelector:@selector(animationSearchShowDone) withObject:nil afterDelay:kAnimateTimeSearchShow];
}
- (void)animationSearchShowDone {
	GLog();
    
    // appeared
    [_searchViewController viewDidAppear:YES];
    
}


/**
 * Hides the search.
 */
- (void)animationSearchHide {
	GLog();
	
	// prepare controllers
	[_searchViewController viewWillDisappear:YES];
    
    // content view
    CGRect contentFrame = _searchViewController.contentView.frame;
    contentFrame.origin.y = self.view.frame.size.height;
    
	// animate
	[UIView beginAnimations:@"search_hide" context:nil];
	[UIView setAnimationDuration:kAnimateTimeSearchHide];
    _searchViewController.modalView.alpha = 0.0f;
    _searchViewController.contentView.frame = contentFrame;
	[UIView commitAnimations];
    
	// clean it up
	[self performSelector:@selector(animationSearchHideDone) withObject:nil afterDelay:kAnimateTimeSearchHide];
}
- (void)animationSearchHideDone {
	GLog();
    
    // view
	[_searchViewController.view setHidden:YES];
    [self.view sendSubviewToBack:_searchViewController.view];
    
    // controller
    [_searchViewController viewDidDisappear:YES];
    
    // state
    mode_search = NO;
    
}



/**
 * Shows the settings.
 */
- (void)animationSettingsShow {
	GLog();
    
    // state
    mode_settings = YES;
    
	
	// prepare controllers
	[_settingsViewController viewWillAppear:YES];
    
    // prepare views
    [_settingsViewController.view setHidden:NO];
    
    // calculate centers
    CGPoint settingsCenter = _settingsViewController.contentView.center;
    settingsCenter.y += kOffsetSettings;
    _settingsViewController.contentView.center = settingsCenter;
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
	[UIView beginAnimations:@"settings_show" context:nil];
	[UIView setAnimationDuration:kAnimateTimeSettingsShow];
    _settingsViewController.contentView.center = settingsCenter;
    _searchBarViewController.view.center = searchCenter;
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
	GLog();
    
    // state
    mode_settings = NO;
	
	// prepare controllers
	[_settingsViewController viewWillDisappear:YES];
    
    // calculate centers
    CGPoint settingsCenter = _settingsViewController.contentView.center;
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
	[UIView beginAnimations:@"settings_hide" context:nil];
	[UIView setAnimationDuration:kAnimateTimeSettingsHide];
    _settingsViewController.contentView.center = settingsCenter;
    _searchBarViewController.view.center = searchCenter;
    _buttonSettings.center = buttonCenter;
    _cinderView.center = cinderCenter;
	[UIView commitAnimations];
    
    
	// clean it up
	[self performSelector:@selector(animationSettingsHideDone) withObject:nil afterDelay:kAnimateTimeSettingsHide];
}
- (void)animationSettingsHideDone {
	GLog();
    
    // view
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

/*
 * Generates a random tagline.
 */
- (void)randomTagline {
    FLog();
    
    // random tagline
    NSArray *movies = [tmdb dataMovies];
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
#pragma mark Memory management

/*
 * Deallocates used memory.
 */
- (void)dealloc {
	GLog();
	
    // controllers
    [_noteView release];
    [_searchBarViewController release];
    [_searchViewController release];
    [_informationViewController release];
    [_settingsViewController release];
    
    // data
    [_dta_nodes release];
    
    // notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// release global
    [super dealloc];
}

@end
