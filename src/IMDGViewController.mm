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
    return NO;
}


#pragma mark -
#pragma mark API Delegate

/*
 * Search result.
 */
- (void)searchResult:(Search*)result {
    DLog();
    
    
    // results
    [_searchResultViewController showResults:result];
    
	
	// pop it
	[_searchResultsPopoverController presentPopoverFromRect:CGRectMake(400, 40, 30, 30) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


/*
 * Loaded movie.
 */
- (void)loadedMovie:(Movie*)movie {
    DLog();
    
    // add node
    NSString *nid = [self makeNodeId:movie.mid type:typeMovie];
    NodePtr node = imdgApp->getNode([nid UTF8String]);
    
    // check
    if (node != NULL) {
        
        // properties
        node->renderLabel([movie.title UTF8String]);
        
        // actors
        NSSortDescriptor *asorter = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        NSArray *actors = [[movie.actors allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:asorter]];
        //[asorter release];
        
        // create nodes
        int v = 10;
        for (MovieActor *mactor in actors) {
            
            // child
            NSString *cid = [self makeNodeId:mactor.actor.aid type:typeActor];
            NodePtr child = imdgApp->getNode([cid UTF8String]);
            if (child != NULL) {
                 child->show();
            }
            else {
                
                // new child
                child = imdgApp->createNode([cid UTF8String], node->pos.x, node->pos.y);
                child->makechild();
                child->renderLabel([mactor.actor.name UTF8String]);
                if (v <= 0) {
                    child->hide();
                }
                v--;
                
            }
            
            // add to node
            node->addChild(child);
            
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
    
}

/*
 * Loaded director.
 */
- (void)loadedDirector:(Director*)director {
    DLog();
    
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
 * Result selected.
 */
- (void)selectedResult:(SearchResult*)result type:(NSString*)type {
    DLog();
    
    // hide keyboard
    [_searchBar resignFirstResponder];
    
    // inactive
    _searchBar.alpha = kAlpha;
    
    // dismiss popover
    [_searchResultsPopoverController dismissPopoverAnimated:YES];
    

    // add node
    NSString *nid = [self makeNodeId:result.rid type:type];
    NodePtr node = imdgApp->createNode([nid UTF8String], arc4random() % 768, arc4random() % 768);
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

/*
 * Cancel search.
 */
- (void)cancelSearch {
    DLog();
    
    // cancel search
    
    // dismiss popover
    [_searchResultsPopoverController dismissPopoverAnimated:YES];
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
    [_searchResultViewController resetResults];
    
    // api
    [imdb search:s type:t];

    
    
    /*
    // add node
    NSString *nid = [self makeNodeId:0 type:@"movie"];
    NodePtr node = imdgApp->createNode([nid UTF8String], arc4random() % 768, arc4random() % 768);
    node->load = true;
    
    NodePtr cnode = imdgApp->getNode([[self makeNodeId:0 type:@"movie"] UTF8String]);
    std::cout<<"node"<<cnode<<endl;
    
    
    // test
    for (int i = 0; i < 10; i++) {
        NSString *cid = [NSString stringWithFormat:@"actor_%i",i];
        NodePtr child = imdgApp->createNode([cid UTF8String], arc4random() % 768, arc4random() % 768);
        child->makechild();
        node->addChild(child);
    }
     */

    
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
