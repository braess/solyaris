//
//  SearchBarViewController.m
//  Solyaris
//
//  Created by CNPP on 5.8.2011.
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
#import "SearchBarViewController.h"
#import "SolyarisConstants.h"
#import "Tracker.h"



/**
 * SearchTerm Stack.
 */
@interface SearchBarViewController (SearchTermStack)
- (void)persistSearchTerm:(NSString*)term;
- (NSString*)retrieveSearchTerm;
@end


/**
 * SearchBarViewController.
 */
@implementation SearchBarViewController

#pragma mark -
#pragma mark Constants

// constants
#define kAlphaSearch 0.5f
#define kAlphaSearchActive 0.85f
#define kAlphaTxt 0.75f



#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize searchBar=_searchBar;



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
    float swidth = iPad ? 300 : (self.view.frame.size.width-80);
    float sheight = 30;
    
    // logo
    float lwidth = 26;
    float lheight = 26;
    
    // title
    float theight = 15;
    float twidth = 200;
    
    // icons
    float iwidth = 44;
    float iheight = 44;
    
    // offset
    float oysbar = 0;
    
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
    UIButton *btnLogo = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnLogo.autoresizingMask = UIViewAutoresizingNone;
	btnLogo.frame = lframe;
	[btnLogo setImage:[UIImage imageNamed:@"logo_solyaris.png"] forState:UIControlStateNormal];
    if (iPad) {
        [btnLogo addTarget:self action:@selector(actionLogo:) forControlEvents:UIControlEventTouchUpInside];
    }
    _buttonLogo = [btnLogo retain];
    [self.view addSubview:_buttonLogo];
    
    // title
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:ltframe];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    lblTitle.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
    lblTitle.numberOfLines = 1;
    lblTitle.text = NSLocalizedString(@"Solyaris",@"Solyaris");
    _labelTitle = [lblTitle retain];
    [lblTitle release];
    
    // claim
    UILabel *lblClaim = [[UILabel alloc] initWithFrame:lcframe];
    lblClaim.backgroundColor = [UIColor clearColor];
    lblClaim.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    lblClaim.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
    lblClaim.numberOfLines = 1;
    lblClaim.text = NSLocalizedString(@"Visual Movie Browser",@"Visual Movie Browser");
    _labelClaim = [lblClaim retain];
    [lblClaim release];
    
    // ipad
    if (iPad) {
        
        // add labels
        [self.view addSubview:_labelTitle];
        [self.view addSubview:_labelClaim];
    }
     
    
    // search bar
    UISearchBar *sBar = [[UISearchBar alloc] initWithFrame:sbframe];
    sBar.autoresizingMask = iPad ? (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin) : (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin);
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
    self.searchBar = sBar;
	[self.view addSubview:_searchBar];
	[sBar release];
    
    
    // button reset
	UIButton *btnReset = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnReset.frame = brframe;
    btnReset.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	[btnReset setImage:[UIImage imageNamed:@"btn_reset.png"] forState:UIControlStateNormal];
	[btnReset addTarget:self action:@selector(actionReset:) forControlEvents:UIControlEventTouchUpInside];
	_buttonReset = [btnReset retain];
	[self.view addSubview:_buttonReset];

    // resize
    [self resize];
}

/*
 * Prepare rotation animation.
 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self resize];
}


#pragma mark -
#pragma mark Business

/**
 * Enables the search.
 */
- (void)enable:(BOOL)enabled {
    FLog();
    
    // mode
    mode_enabled = enabled;
    
    // iphone
    if (! iPad) {
        
        // hide reset
        [_buttonReset setHidden:enabled];
        
        // resize
        [self resize];
        
    }
    
    // search bar
    [_searchBar setShowsCancelButton:enabled animated:YES]; 

    
    // dismiss
    if (! enabled) {
        [_searchBar resignFirstResponder];
    }
}



/**
 * Resize.
 */
- (void)resize {
    FLog();
    
    // not ipad
    if (! iPad) {
        
        // size search bar
        float swidth = self.view.frame.size.width - (mode_enabled ? 40 : 80);
        CGRect sbFrame = _searchBar.frame;
        sbFrame.origin.x = 40;
        sbFrame.size.width = swidth;
        _searchBar.frame = sbFrame;
    }
    
}

/**
 * Updates the claim.
 */
- (void)claim:(NSString *)claim {
    FLog();
    
    // set
    [_labelClaim setText:claim];
}




#pragma mark -
#pragma mark SearchBar Delegate


/*
 * Should begin editing.
 */
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {  
    FLog();
    
    // enable
    [self enable:YES];
    
    // search
    if (delegate && [delegate respondsToSelector:@selector(searchBarPrepare)]) {
        [delegate searchBarPrepare];
    }
    
    // return
    return YES;  
}  


/*
 * Should end editing.
 */
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar { 
    FLog();
    
    // disable
    [self enable:NO];
    
    // return
    return YES;
} 

/*
 * Begin editing.
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    FLog();
    
    // active
    _searchBar.alpha = kAlphaSearchActive;
    
}

/*
 * Changed.
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    // persist
    [self persistSearchTerm:searchText];
    
    // notify
    NSMutableDictionary *infoSearch = [NSMutableDictionary dictionary];
    [infoSearch setObject:searchText forKey:ntvSearchTerm];
    [[NSNotificationCenter defaultCenter] postNotificationName:ntSearchTerm object:self userInfo:infoSearch];
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
    
    // type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *searchType = (NSString*) [defaults objectForKey:udSearchType];
    searchType = searchType ? searchType : typeMovie;
    
    // search
    if (delegate && [delegate respondsToSelector:@selector(search:type:)]) {
        [delegate search:[_searchBar text] type:searchType];
    }
    
}

/*
 * Cancel.
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    DLog();
    
    // disable
    [self enable:NO];
    
    // search
    if (delegate && [delegate respondsToSelector:@selector(searchBarCancel)]) {
        [delegate searchBarCancel];
    }
    
}


#pragma mark -
#pragma mark Actions

/*
 * Action Logo.
 */
- (void)actionLogo:(id)sender {
	DLog();
    
    // logo
    if (delegate && [delegate respondsToSelector:@selector(logo)]) {
        [delegate logo];
    }
    
}




/*
 * Action Reset.
 */
- (void)actionReset:(id)sender {
	DLog();
    
    // track
    [Tracker trackEvent:TEventSearch action:@"reset" label:@""];

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:term forKey:udSearchTerm];
    [defaults synchronize];
    
}
- (NSString*)retrieveSearchTerm {
    
    // user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *trm = (NSString*) [defaults objectForKey:udSearchTerm];
    return trm ? trm : @"";
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
    [_buttonReset release];
    [_buttonLogo release];
    [_labelClaim release];
    [_labelTitle release];
	
	// release global
    [super dealloc];
}



@end
