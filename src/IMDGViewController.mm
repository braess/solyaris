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
    float border = 15;
    
    
    // labels
    float lheight = 15;
    
    // buttons
    float bwidth = 67;
    float bheight = 25;
    float binset = 5;
    
    // search
    float sheight = 30;
    
    
    // background
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, -border, fwidth+border, fheight+border)];
    background.backgroundColor = [UIColor colorWithRed:76/255.0 green:86/255.0 blue:100/255.0 alpha:120/255.0];
    background.layer.cornerRadius = border;
    [self.view addSubview:background];
    
    
    // title
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(border, border, fwidth-border, lheight)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    lblTitle.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:210/255.0];
    lblTitle.numberOfLines = 1;
    lblTitle.text = NSLocalizedString(@"IMDG",@"IMDG");
    [self.view addSubview:lblTitle];
    
    // claim
    UILabel *lblClaim = [[UILabel alloc] initWithFrame:CGRectMake(border, border+lheight, fwidth-border, lheight)];
    lblClaim.backgroundColor = [UIColor clearColor];
    lblClaim.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    lblClaim.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:210/255.0];
    lblClaim.numberOfLines = 1;
    lblClaim.text = NSLocalizedString(@"The Internet Movie Database Graph",@"The Internet Movie Database Graph");
    [self.view addSubview:lblClaim];
    
    // search bar
    UISearchBar *sBar = [[UISearchBar alloc] initWithFrame:CGRectMake(border-7, fheight-border-bheight-binset-sheight, fwidth-2*border+14, sheight)];
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
    self.searchBar = sBar;
	[self.view addSubview:_searchBar];
	[sBar release];
    
    
    
    // button movie (187,176,130)
	UIButton *btnMovie = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMovie.frame = CGRectMake(border, fheight-border-bheight, bwidth, bheight);
    btnMovie.layer.cornerRadius = binset/2.0;
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
    btnActor.frame = CGRectMake(border+bwidth+binset, fheight-border-bheight, bwidth, bheight);
    btnActor.layer.cornerRadius = binset/2.0;
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
    btnDirector.frame = CGRectMake(border+2*bwidth+2*binset, fheight-border-bheight, bwidth, bheight);
    btnDirector.layer.cornerRadius = binset/2.0;
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
    FLog();
}



/*
 * Search.
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    DLog();
    
    // search
	
    // hide keyboard
    [searchBar resignFirstResponder];
    
    // inactive
    _searchBar.alpha = kAlpha;
}

#pragma mark -
#pragma mark Actions


/*
 * Action Movie.
 */
- (void)actionMovie:(id)sender {
	DLog();
    imdgApp->test();
}

/*
 * Action Actor.
 */
- (void)actionActor:(id)sender {
	DLog();
    imdgApp->test();
}

/*
 * Action Director.
 */
- (void)actionDirector:(id)sender {
	DLog();
    imdgApp->test();
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
	
	
	// release global
    [super dealloc];
}

@end
