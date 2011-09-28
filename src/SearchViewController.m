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
 * Helper Stack.
 */
@interface SearchViewController (HelperStack)
- (void)buttonDown:(id)sender;
- (void)buttonUp:(id)sender;
@end


/**
 * SearchTerm Stack.
 */
@interface SearchViewController (SearchTermStack)
- (void)persistSearchTerm:(NSString*)term;
- (NSString*)retrieveSearchTerm;
@end


/**
 * SearchViewController.
 */
@implementation SearchViewController

#pragma mark -
#pragma mark Constants

// constants
#define kAlphaSearch 0.75f
#define kAlphaSearchActive 0.96f
#define kAlphaBtn 0.75f
#define kAlphaBtnActive 0.5f
#define kAlphaTxt 0.75f



#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
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
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    // size
	float fwidth = self.view.frame.size.width;
	float fheight = self.view.frame.size.height;
    float border = 10;
    float inset = 5;
    float swidth = 300;
    float sheight = 30;
    
    
    // title
    float theight = 15;
    float twidth = 200;
    
    // icons
    float iwidth = 32;
    float iheight = 32;
    
    // frames
    CGRect bgframe = CGRectMake(0, 0, fwidth, fheight);
    CGRect sbframe = CGRectMake(fwidth*0.5-swidth*0.5, ((fheight-sheight)/2.0)+1.5, swidth, sheight);
    CGRect ltframe = CGRectMake(border, inset, twidth, theight);
    CGRect lcframe = CGRectMake(border, inset+theight-1, twidth, theight);
    CGRect brframe = CGRectMake(fwidth-inset-iwidth, (fheight-iheight)/2.0, iwidth, iheight);
    
    
    // background
    UIView *background = [[UIView alloc] initWithFrame:bgframe];
    background.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    background.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    _background = [background retain];
    [self.view addSubview:_background];
    [background release];
   
    
    // title
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:ltframe];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    lblTitle.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt];
    lblTitle.numberOfLines = 1;
    lblTitle.text = NSLocalizedString(@"SOLYARIS",@"SOLYARIS");
    _labelTitle = [lblTitle retain];
    [self.view addSubview:_labelTitle];
    [lblTitle release];
    
    // claim
    UILabel *lblClaim = [[UILabel alloc] initWithFrame:lcframe];
    lblClaim.backgroundColor = [UIColor clearColor];
    lblClaim.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    lblClaim.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt];
    lblClaim.numberOfLines = 1;
    lblClaim.text = NSLocalizedString(@"A Visual Movie Browser",@"A Visual Movie Browser");
    _labelClaim = [lblClaim retain];
    [self.view addSubview:_labelClaim];
    [lblClaim release];
     
    
    // search bar
    UISearchBar *sBar = [[UISearchBar alloc] initWithFrame:sbframe];
    sBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
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
    sBar.text = [self retrieveSearchTerm];
    _searchBar = [sBar retain];
	[self.view addSubview:_searchBar];
	[sBar release];
    
    // button movie 
	UIButton *btnMovie = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMovie.layer.cornerRadius = 3;
    btnMovie.layer.masksToBounds = YES;
    btnMovie.alpha = kAlphaBtn;
    btnMovie.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    [btnMovie setBackgroundColor:[UIColor colorWithRed:135/255.0 green:138/255.0 blue:84/255.0 alpha:1]];
    [btnMovie setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt] forState:UIControlStateNormal];
    [btnMovie setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt] forState:UIControlStateSelected | UIControlStateHighlighted];
    [btnMovie setTitle:NSLocalizedString(@"Movie",@"Movie") forState:UIControlStateNormal];
	[btnMovie addTarget:self action:@selector(actionMovie:) forControlEvents:UIControlEventTouchUpInside];
    [btnMovie addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [btnMovie addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];
    [btnMovie addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    
	self.buttonMovie = [btnMovie retain];
	[self.view addSubview:_buttonMovie];
	[btnMovie release];
    
    
    // button actor
	UIButton *btnActor = [UIButton buttonWithType:UIButtonTypeCustom];
    btnActor.layer.cornerRadius = 3;
    btnActor.layer.masksToBounds = YES;
    btnActor.alpha = kAlphaBtn;
    btnActor.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    [btnActor setBackgroundColor:[UIColor colorWithRed:28/255.0 green:92/255.0 blue:138/255.0 alpha:1]];
    [btnActor setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt] forState:UIControlStateNormal];
    [btnActor setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt] forState:UIControlStateSelected | UIControlStateHighlighted];
    [btnActor setTitle:NSLocalizedString(@"Actor",@"Actor") forState:UIControlStateNormal];
	[btnActor addTarget:self action:@selector(actionActor:) forControlEvents:UIControlEventTouchUpInside];
    [btnActor addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [btnActor addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];
    [btnActor addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    
	self.buttonActor = [btnActor retain];
	[self.view addSubview:_buttonActor];
	[btnActor release];
    
    
    // button director 
	UIButton *btnDirector = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDirector.layer.cornerRadius = 3;
    btnDirector.layer.masksToBounds = YES;
    btnDirector.alpha = kAlphaBtn;
    btnDirector.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    [btnDirector setBackgroundColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1]];
    [btnDirector setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt] forState:UIControlStateNormal];
    [btnDirector setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt] forState:UIControlStateSelected | UIControlStateHighlighted];
    [btnDirector setTitle:NSLocalizedString(@"Director",@"Director") forState:UIControlStateNormal];
	[btnDirector addTarget:self action:@selector(actionDirector:) forControlEvents:UIControlEventTouchUpInside];
    [btnDirector addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [btnDirector addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];
    [btnDirector addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    
	self.buttonDirector = [btnDirector retain];
	[self.view addSubview:_buttonDirector];
	[btnDirector release];
    
    
    // button reset
	UIButton *btnReset = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnReset.frame = brframe;
    btnReset.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	[btnReset setImage:[UIImage imageNamed:@"btn_reset.png"] forState:UIControlStateNormal];
	[btnReset addTarget:self action:@selector(actionReset:) forControlEvents:UIControlEventTouchUpInside];
	_buttonReset = [btnReset retain];
	[self.view addSubview:_buttonReset];
	[btnReset release];

    // resize
    [self resize];
}


/*
 * Resize.
 */
- (void)resize {
    GLog();
    
    // size
    float fwidth = self.view.frame.size.width;
	float fheight = self.view.frame.size.height;
    
    
    // buttons
    float bwidth = 60;
    float bheight = 24;
    float inset = 5;
    float swidth = 300;
    
    // frames
    CGRect bframe =  CGRectMake(fwidth*0.5+swidth*0.5+inset, (fheight-bheight)/2.0, 3*(bwidth+inset), bheight);
    CGRect bmframe = CGRectMake(bframe.origin.x, bframe.origin.y, bwidth, bheight);
    CGRect baframe = CGRectMake(bframe.origin.x+inset+bwidth, bframe.origin.y, bwidth, bheight);
    CGRect bdframe = CGRectMake(bframe.origin.x+2*inset+2*bwidth, bframe.origin.y, bwidth, bheight);
    
    // buttons
    _buttonMovie.frame = bmframe;
    _buttonActor.frame = baframe;
    _buttonDirector.frame = bdframe;
    
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
    
    // persist
    [self persistSearchTerm:searchBar.text];
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
        [delegate search:[_searchBar text] type:typeAll];
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
        [delegate search:[_searchBar text] type:typePersonActor];
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
        [delegate search:[_searchBar text] type:typePersonDirector];
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
#pragma mark SearchTerm

/*
 * Search Term.
 */
- (void)persistSearchTerm:(NSString *)term {
    
    // user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // set
    [userDefaults setObject:term forKey:udSearchTerm];
    [userDefaults synchronize];
    
}
- (NSString*)retrieveSearchTerm {
    
    // user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// return
	NSObject *v = [userDefaults objectForKey:udSearchTerm];
	return v ? (NSString*)v : NSLocalizedString(@"Kill Bill", @"Kill Bill");
}


#pragma mark -
#pragma mark Helper

/*
 * Button down/up.
 */
- (void)buttonDown:(id)sender {
    UIButton *b = (UIButton*)sender;
    b.alpha = kAlphaBtnActive;
}
- (void)buttonUp:(id)sender {
    UIButton *b = (UIButton*)sender;
    b.alpha = kAlphaBtn;
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
