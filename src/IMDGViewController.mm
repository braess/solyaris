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
 * IMDG ViewController.
 */
@implementation IMDGViewController


#pragma mark -
#pragma mark Constants

// constants
#define kAlpha 0.9f
#define kAlphaActive 0.96f


#pragma mark -
#pragma mark Properties

// accessors
@synthesize imdgApp;
@synthesize searchBar=_searchBar;
@synthesize buttonMovie=_buttonMovie;
@synthesize buttonActor=_buttonActor;
@synthesize buttonDirector=_buttonDirector;
@synthesize buttonReset=_buttonReset;


#pragma mark -
#pragma mark Object Methods

/**
 * Init.
 */
- (id)initWithFrame:(CGRect)frame {
	
	// init super
	if ((self = [super init])) {
		GLog();
        
        // view
        self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
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
    
    // size
	float fwidth = self.view.frame.size.width;
	float fheight = self.view.frame.size.height;
    float border = 10;
    float inset = 5;
    
    
    // title
    float theight = 15;
    float twidth = 200;
    
    // buttons
    float bwidth = 60;
    float bheight = 24;
    
    // icons
    float iwidth = 24;
    float iheight = 24;
    
    // search
    float swidth = 300;
    float sheight = 30;
    
    
    // background
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fwidth, fheight)];
    background.backgroundColor = [UIColor colorWithRed:76/255.0 green:86/255.0 blue:100/255.0 alpha:120/255.0];
    [self.view addSubview:background];
    
    
    // title
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(border, inset, twidth, theight)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    lblTitle.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:210/255.0];
    lblTitle.numberOfLines = 1;
    lblTitle.text = NSLocalizedString(@"IMDG",@"IMDG");
    [self.view addSubview:lblTitle];
    
    // claim
    UILabel *lblClaim = [[UILabel alloc] initWithFrame:CGRectMake(border, inset+theight-1, twidth, theight)];
    lblClaim.backgroundColor = [UIColor clearColor];
    lblClaim.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    lblClaim.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:210/255.0];
    lblClaim.numberOfLines = 1;
    lblClaim.text = NSLocalizedString(@"The Internet Movie Database Graph",@"The Internet Movie Database Graph");
    [self.view addSubview:lblClaim];
    

    
    // search bar
    UISearchBar *sBar = [[UISearchBar alloc] initWithFrame:CGRectMake(fwidth*0.5-swidth*0.5, ((fheight-sheight)/2.0)+1.5, swidth, sheight)];
    sBar.barStyle = UIBarStyleBlackTranslucent;
    sBar.alpha = kAlpha;
    sBar.showsCancelButton = NO;
    sBar.autocorrectionType = UITextAutocorrectionTypeNo;
    sBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    sBar.delegate = self;
    for (UIView *subview in sBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    sBar.text = @"Kill Bill";
    self.searchBar = sBar;
	[self.view addSubview:_searchBar];
	[sBar release];
    
    
    
    // button movie (187,176,130)
	UIButton *btnMovie = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMovie.frame = CGRectMake(fwidth*0.5+swidth*0.5+inset, (fheight-bheight)/2.0, bwidth, bheight);
    btnMovie.layer.cornerRadius = 3;
    btnMovie.layer.masksToBounds = YES;
    btnMovie.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    btnMovie.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:210/255.0];
    
    [btnMovie setBackgroundColor:[UIColor colorWithRed:187/255.0 green:176/255.0 blue:130/255.0 alpha:kAlpha]];
    [btnMovie setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMovie setTitle:NSLocalizedString(@"Movie",@"Movie") forState:UIControlStateNormal];
	[btnMovie addTarget:self action:@selector(actionMovie:) forControlEvents:UIControlEventTouchUpInside];
    
	self.buttonMovie = btnMovie;
	[self.view addSubview:_buttonMovie];
	[btnMovie release];
    
    
    // button actor (130,153,147)
	UIButton *btnActor = [UIButton buttonWithType:UIButtonTypeCustom];
    btnActor.frame = CGRectMake(fwidth*0.5+swidth*0.5+2*inset+bwidth, (fheight-bheight)/2.0, bwidth, bheight);
    btnActor.layer.cornerRadius = 3;
    btnActor.layer.masksToBounds = YES;
    btnActor.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    btnActor.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:210/255.0];
    
    [btnActor setBackgroundColor:[UIColor colorWithRed:130/255.0 green:153/255.0 blue:147/255.0 alpha:kAlpha]];
    [btnActor setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnActor setTitle:NSLocalizedString(@"Actor",@"Actor") forState:UIControlStateNormal];
	[btnActor addTarget:self action:@selector(actionActor:) forControlEvents:UIControlEventTouchUpInside];
    
	self.buttonActor= btnActor;
	[self.view addSubview:_buttonActor];
	[btnActor release];
    
    
    // button director (94,118,117)
	UIButton *btnDirector = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDirector.frame = CGRectMake(fwidth*0.5+swidth*0.5+3*inset+2*bwidth, (fheight-bheight)/2.0, bwidth, bheight);
    btnDirector.layer.cornerRadius = 3;
    btnDirector.layer.masksToBounds = YES;
    btnDirector.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    btnDirector.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:210/255.0];
    
    [btnDirector setBackgroundColor:[UIColor colorWithRed:94/255.0 green:118/255.0 blue:117/255.0 alpha:kAlpha]];
    [btnDirector setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDirector setTitle:NSLocalizedString(@"Director",@"Director") forState:UIControlStateNormal];
	[btnDirector addTarget:self action:@selector(actionDirector:) forControlEvents:UIControlEventTouchUpInside];
    
	self.buttonDirector = btnDirector;
	[self.view addSubview:_buttonDirector];
	[btnDirector release];
    
    
    // button reset
	UIButton *btnReset = [UIButton buttonWithType:UIButtonTypeCustom]; 
	btnReset.frame = CGRectMake(fwidth-inset-iwidth-2, (fheight-iheight)/2.0, iwidth, iheight);
	[btnReset setImage:[UIImage imageNamed:@"btn_reset.png"] forState:UIControlStateNormal];
	[btnReset addTarget:self action:@selector(actionReset:) forControlEvents:UIControlEventTouchUpInside];
	self.buttonReset = btnReset;
	[self.view addSubview:_buttonReset];
	[btnReset release];
    
    
    // popover
    SearchResultViewController *srViewController = [[SearchResultViewController alloc] initWithStyle:UITableViewStylePlain];
    srViewController.delegate = self;
    srViewController.view.frame = CGRectMake(0, 0, 320, 480);
	[srViewController.view setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ];
	_searchResultViewController = [srViewController retain];
    
    
	UINavigationController *sNavigationController = [[UINavigationController alloc] initWithRootViewController:srViewController];
	UIPopoverController *sPopoverController = [[UIPopoverController alloc] initWithContentViewController:sNavigationController];
	[sPopoverController setPopoverContentSize:CGSizeMake(srViewController.view.frame.size.width, srViewController.view.frame.size.height)];
    sPopoverController.contentViewController.view.alpha = 0.9f;
	_searchResultsPopoverController = [sPopoverController retain];
	[sPopoverController release];
    
  
}

/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	FLog();

    
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
                edge = imdgApp->createEdge([eid UTF8String],node,child);
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
                edge = imdgApp->createEdge([eid UTF8String],node,child);
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
                edge = imdgApp->createEdge([eid UTF8String],node,child);
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
                edge = imdgApp->createEdge([eid UTF8String],node,child);
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
    
    // hide keyboard
    [_searchBar resignFirstResponder];
    
    // inactive
    _searchBar.alpha = kAlpha;
    
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

/*
 * Search cancel.
 */
- (void)searchCancel {
    FLog();
    
    // cancel search
    
    // dismiss popover
    [_searchResultsPopoverController dismissPopoverAnimated:YES];
}


#pragma mark -
#pragma mark Information Delegate


/* 
 * Dismiss information.
 */
- (void)informationDismiss {
    FLog();
    
    // dismiss modal
	[self dismissModalViewControllerAnimated:YES];
}





#pragma mark -
#pragma mark SearchBar Delegate


/**
 * Begin editing.
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    FLog();
    
    // active
    _searchBar.alpha = kAlphaActive;
}

/**
 * Text changed.
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    GLog();
}



/*
 * Search.
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    DLog();
    
    // search
	
    // hide keyboard
    [_searchBar resignFirstResponder];
    
    // inactive
    _searchBar.alpha = kAlpha;
    
    // search
    [self search:[_searchBar text] type:typeMovie];
    
}


#pragma mark -
#pragma mark Business

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
    CGRect srframe = _buttonMovie.frame;
    if (t == typeActor) {
        srframe = _buttonActor.frame;
    }
    else if (t == typeDirector) {
        srframe = _buttonDirector.frame;
    }
    
    // pop it
	[_searchResultsPopoverController presentPopoverFromRect:srframe inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    
}

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
        
        // info view controller
        InformationViewController *nfoController = [[InformationViewController alloc] initWithStyle:UITableViewStyleGrouped];
        nfoController.delegate = self;
        nfoController.view.frame = CGRectMake(0, 0, 320, 480);
        [nfoController.view setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ];
        
        // information
        nfoController.title = [NSString stringWithCString:node->label.c_str() encoding:[NSString defaultCStringEncoding]];
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
            if (edge != NULL) {
                
                // label
                meta = [NSString stringWithCString:edge->label.c_str() encoding:[NSString defaultCStringEncoding]];
                
            }
            
            
            // information
            Information *nfo = [[Information alloc] initWithValue:value meta:meta type:type nid:nid];
            
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
        
        // set & release
        nfoController.movies = movies;
        nfoController.actors = actors;
        nfoController.directors = directors;

        
        
        // navigation controller
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nfoController];
        navController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture.png"]];
        navController.navigationBar.barStyle = UIBarStyleBlack;
        navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        
        // show the navigation controller modally
        [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentModalViewController:navController animated:YES];
        
        // Clean up resources
        [navController release];
        [nfoController release];
        
    }
    
}

#pragma mark -
#pragma mark Actions


/*
 * Action Movie.
 */
- (void)actionMovie:(id)sender {
	DLog();
    
    // search
    [self search:[_searchBar text] type:typeMovie];
}

/*
 * Action Actor.
 */
- (void)actionActor:(id)sender {
	DLog();
    
    // search
    [self search:[_searchBar text] type:typeActor];
}

/*
 * Action Director.
 */
- (void)actionDirector:(id)sender {
	DLog();
    
    // search
    [self search:[_searchBar text] type:typeDirector];
}


/*
 * Action Reset.
 */
- (void)actionReset:(id)sender {
	DLog();
    
    // search
	
    // hide keyboard
    [_searchBar resignFirstResponder];
    
    // inactive
    _searchBar.alpha = kAlpha;
    
    // results
    [_searchResultsPopoverController dismissPopoverAnimated:YES];
    
    // test
    imdgApp->reset();
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
    
    // ui
    [_searchBar release];
    [_buttonMovie release];
    [_buttonActor release];
    [_buttonDirector release];
    [_buttonReset release];
	
	
	// release global
    [super dealloc];
}

@end
