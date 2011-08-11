//
//  SearchViewController.m
//  IMDG
//
//  Created by CNPP on 5.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IMDGConstants.h"


/**
 * SearchViewController.
 */
@implementation SearchViewController

#pragma mark -
#pragma mark Constants

// constants
#define kAlphaSearch 0.8f
#define kAlphaSearchActive 0.96f
#define kAlphaBtn 0.6f
#define kAlphaBtnActive 0.96f
#define kAlphaTxt 0.6f
#define kAlphaTxtActive 0.6f


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize buttonMovie=_buttonMovie;
@synthesize buttonActor=_buttonActor;
@synthesize buttonDirector=_buttonDirector;

// local vars
CGRect vframe;


#pragma mark -
#pragma mark Object Methods

/**
 * Init.
 */
- (id)initWithFrame:(CGRect)frame {
	
	// init super
	if ((self = [super init])) {
        
        // frame
        vframe = frame;
        
		// return
		return self;
	}
	
	// back
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
    
    // view
    self.view = [[[UIView alloc] initWithFrame:vframe] autorelease];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
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
    float iwidth = 32;
    float iheight = 32;
    
    // search
    float swidth = 300;
    float sheight = 30;
    
    
    // background
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fwidth, fheight)];
    background.backgroundColor = [UIColor colorWithRed:76/255.0 green:86/255.0 blue:100/255.0 alpha:0.5];
    [self.view addSubview:background];
    
   
    
    // title
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(border, inset, twidth, theight)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    lblTitle.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt];
    lblTitle.numberOfLines = 1;
    lblTitle.text = NSLocalizedString(@"IMDG",@"IMDG");
    [self.view addSubview:lblTitle];
    
    // claim
    UILabel *lblClaim = [[UILabel alloc] initWithFrame:CGRectMake(border, inset+theight-1, twidth, theight)];
    lblClaim.backgroundColor = [UIColor clearColor];
    lblClaim.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    lblClaim.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt];
    lblClaim.numberOfLines = 1;
    lblClaim.text = NSLocalizedString(@"The Internet Movie Database Graph",@"The Internet Movie Database Graph");
    [self.view addSubview:lblClaim];
     
    
    // search bar
    UISearchBar *sBar = [[UISearchBar alloc] initWithFrame:CGRectMake(fwidth*0.5-swidth*0.5, ((fheight-sheight)/2.0)+1.5, swidth, sheight)];
    sBar.barStyle = UIBarStyleBlackTranslucent;
    sBar.alpha = kAlphaSearch;
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
    _searchBar = [sBar retain];
	[self.view addSubview:_searchBar];
	[sBar release];
    
    
    // button movie 
	UIButton *btnMovie = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMovie.frame = CGRectMake(fwidth*0.5+swidth*0.5+inset, (fheight-bheight)/2.0, bwidth, bheight);
    btnMovie.layer.cornerRadius = 3;
    btnMovie.layer.masksToBounds = YES;
    btnMovie.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    [btnMovie setBackgroundColor:[UIColor colorWithRed:126/255.0 green:128/255.0 blue:102/255.0 alpha:kAlphaBtn]];
    [btnMovie setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt] forState:UIControlStateNormal];
    [btnMovie setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt] forState:UIControlStateSelected | UIControlStateHighlighted];
    [btnMovie setTitle:NSLocalizedString(@"Movie",@"Movie") forState:UIControlStateNormal];
	[btnMovie addTarget:self action:@selector(actionMovie:) forControlEvents:UIControlEventTouchUpInside];
    
	self.buttonMovie = [btnMovie retain];
	[self.view addSubview:_buttonMovie];
	[btnMovie release];
    
    
    // button actor
	UIButton *btnActor = [UIButton buttonWithType:UIButtonTypeCustom];
    btnActor.frame = CGRectMake(fwidth*0.5+swidth*0.5+2*inset+bwidth, (fheight-bheight)/2.0, bwidth, bheight);
    btnActor.layer.cornerRadius = 3;
    btnActor.layer.masksToBounds = YES;
    btnActor.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    [btnActor setBackgroundColor:[UIColor colorWithRed:82/255.0 green:108/255.0 blue:128/255.0 alpha:kAlphaBtn]];
    [btnActor setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt] forState:UIControlStateNormal];
    [btnActor setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt] forState:UIControlStateSelected | UIControlStateHighlighted];
    [btnActor setTitle:NSLocalizedString(@"Actor",@"Actor") forState:UIControlStateNormal];
	[btnActor addTarget:self action:@selector(actionActor:) forControlEvents:UIControlEventTouchUpInside];
    
	self.buttonActor = [btnActor retain];
	[self.view addSubview:_buttonActor];
	[btnActor release];
    
  
    // button director 
	UIButton *btnDirector = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDirector.frame = CGRectMake(fwidth*0.5+swidth*0.5+3*inset+2*bwidth, (fheight-bheight)/2.0, bwidth, bheight);
    btnDirector.layer.cornerRadius = 3;
    btnDirector.layer.masksToBounds = YES;
    btnDirector.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    [btnDirector setBackgroundColor:[UIColor colorWithRed:121/255.0 green:125/255.0 blue:128/255.0 alpha:kAlphaBtn]];
    [btnDirector setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt] forState:UIControlStateNormal];
    [btnDirector setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt] forState:UIControlStateSelected | UIControlStateHighlighted];
    [btnDirector setTitle:NSLocalizedString(@"Director",@"Director") forState:UIControlStateNormal];
	[btnDirector addTarget:self action:@selector(actionDirector:) forControlEvents:UIControlEventTouchUpInside];
    
	self.buttonDirector = [btnDirector retain];
	[self.view addSubview:_buttonDirector];
	[btnDirector release];
    
    
    // button reset
	UIButton *btnReset = [UIButton buttonWithType:UIButtonTypeCustom]; 
	btnReset.frame = CGRectMake(fwidth-inset-iwidth, (fheight-iheight)/2.0, iwidth, iheight);
	[btnReset setImage:[UIImage imageNamed:@"btn_reset.png"] forState:UIControlStateNormal];
	[btnReset addTarget:self action:@selector(actionReset:) forControlEvents:UIControlEventTouchUpInside];
	_buttonReset = [btnReset retain];
	[self.view addSubview:_buttonReset];
	[btnReset release];

    
}


#pragma mark -
#pragma mark SearchBar Delegate


/**
 * Begin editing.
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    FLog();
    
    // active
    _searchBar.alpha = kAlphaSearchActive;
}


/*
 * End editing.
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    // inactive
    _searchBar.alpha = kAlphaSearch;
}


/*
 * Search.
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    DLog();
    
	
    // hide keyboard
    [_searchBar resignFirstResponder];
    
    // inactive
    _searchBar.alpha = kAlphaSearch;
    
    // search
    if (delegate && [delegate respondsToSelector:@selector(search:type:)]) {
        [delegate search:[_searchBar text] type:typeMovie];
    }
    
}


#pragma mark -
#pragma mark Actions


/*
 * Action Movie.
 */
- (void)actionMovie:(id)sender {
	DLog();
    
    // hide keyboard
    [_searchBar resignFirstResponder];
    
    // inactive
    _searchBar.alpha = kAlphaSearch;
    
    // search
    if (delegate && [delegate respondsToSelector:@selector(search:type:)]) {
        [delegate search:[_searchBar text] type:typeMovie];
    }
}

/*
 * Action Actor.
 */
- (void)actionActor:(id)sender {
	DLog();
    
    // hide keyboard
    [_searchBar resignFirstResponder];
    
    // inactive
    _searchBar.alpha = kAlphaSearch;
    
    // search
    if (delegate && [delegate respondsToSelector:@selector(search:type:)]) {
        [delegate search:[_searchBar text] type:typeActor];
    }
}

/*
 * Action Director.
 */
- (void)actionDirector:(id)sender {
	DLog();
    
    // hide keyboard
    [_searchBar resignFirstResponder];
    
    // inactive
    _searchBar.alpha = kAlphaSearch;
    
    // search
    if (delegate && [delegate respondsToSelector:@selector(search:type:)]) {
        [delegate search:[_searchBar text] type:typeDirector];
    }
}


/*
 * Action Reset.
 */
- (void)actionReset:(id)sender {
	DLog();

    // reset
    if (delegate && [delegate respondsToSelector:@selector(reset)]) {
        [delegate reset];
    }
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
