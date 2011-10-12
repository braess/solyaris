//
//  SearchViewController.m
//  Solyaris
//
//  Created by CNPP on 5.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SearchViewController.h"
#import "SolyarisAppDelegate.h"
#import "SolyarisConstants.h"


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
@synthesize buttonPerson=_buttonPerson;




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
    
    // logo
    float lwidth = 24;
    float lheight = 24;
    
    // title
    float theight = 15;
    float twidth = 200;
    
    // icons
    float iwidth = 44;
    float iheight = 44;
    
    // offset
    float oysbar = 0;
    if (iOS4) {
        oysbar = 1;
    }
    
    // frames
    CGRect bgframe = CGRectMake(0, 0, fwidth, fheight);
    CGRect sbframe = CGRectMake(fwidth*0.5-swidth*0.5, ((fheight-sheight)/2.0)+oysbar, swidth, sheight);
    CGRect lframe = CGRectMake(border, ((fheight-lheight)/2.0), lwidth, lheight);
    CGRect ltframe = CGRectMake(border+lwidth+inset, inset+1, twidth, theight);
    CGRect lcframe = CGRectMake(border+lwidth+inset, inset+theight-1, twidth, theight);
    CGRect brframe = CGRectMake(fwidth-iwidth, (fheight-iheight)/2.0, iwidth, iheight);
    
    
    // background
    UIView *background = [[UIView alloc] initWithFrame:bgframe];
    background.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    background.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    _background = [background retain];
    [self.view addSubview:_background];
    [background release];
    
    // logo
    UIImageView *logo = [[UIImageView alloc] initWithFrame:lframe];
    logo.image = [UIImage imageNamed:@"logo_solyaris.png"];
    logo.autoresizingMask = UIViewAutoresizingNone;
    logo.backgroundColor = [UIColor clearColor];
    logo.contentMode = UIViewContentModeCenter;
    _logo = [logo retain];
    [self.view addSubview:_logo];
    [logo release];
   
    
    // title
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:ltframe];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    lblTitle.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt];
    lblTitle.numberOfLines = 1;
    lblTitle.text = NSLocalizedString(@"Solyaris",@"Solyaris");
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
    
    [btnMovie setBackgroundColor:[UIColor colorWithRed:15/255.0 green:96/255.0 blue:153/255.0 alpha:1]];
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
    
    
    // button person
	UIButton *btnPerson = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPerson.layer.cornerRadius = 3;
    btnPerson.layer.masksToBounds = YES;
    btnPerson.alpha = kAlphaBtn;
    btnPerson.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    [btnPerson setBackgroundColor:[UIColor colorWithRed:118/255.0 green:125/255.0 blue:130/255.0 alpha:1]];
    [btnPerson setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt] forState:UIControlStateNormal];
    [btnPerson setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:kAlphaTxt] forState:UIControlStateSelected | UIControlStateHighlighted];
    [btnPerson setTitle:NSLocalizedString(@"Person",@"Person") forState:UIControlStateNormal];
	[btnPerson addTarget:self action:@selector(actionPerson:) forControlEvents:UIControlEventTouchUpInside];
    [btnPerson addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [btnPerson addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];
    [btnPerson addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    
	self.buttonPerson = [btnPerson retain];
	[self.view addSubview:_buttonPerson];
	[btnPerson release];
        
    
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
    CGRect bpframe = CGRectMake(bframe.origin.x+inset+bwidth, bframe.origin.y, bwidth, bheight);
    
    // buttons
    _buttonMovie.frame = bmframe;
    _buttonPerson.frame = bpframe;
    
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
 * Action Person.
 */
- (void)actionPerson:(id)sender {
	DLog();
    
    // hide keyboard
    [_searchBar resignFirstResponder];
    
    // inactive
    _searchBar.alpha = kAlphaSearch;
    
    // search
    if (delegate && [delegate respondsToSelector:@selector(search:type:)]) {
        [delegate search:[_searchBar text] type:typePerson];
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
    [(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] setUserDefault:udSearchTerm value:term];
    
}
- (NSString*)retrieveSearchTerm {
    
    // user defaults
    return (NSString*) [(SolyarisAppDelegate*)[[UIApplication sharedApplication] delegate] getUserDefault:udSearchTerm];
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
    [_buttonPerson release];
    [_buttonReset release];
	
	// release global
    [super dealloc];
}



@end
