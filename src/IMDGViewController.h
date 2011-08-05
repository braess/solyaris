//
//  IMDGViewController.h
//  IMDG
//
//  Created by CNPP on 16.6.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMDB.h"
#import "SearchResultViewController.h"
#import "InformationViewController.h"

// Declarations
CPP_CLASS(IMDGApp);

/**
 * IMDG ViewController.
 */
@interface IMDGViewController : UIViewController <UISearchBarDelegate, UIPopoverControllerDelegate, APIDelegate, SearchResultDelegate, InformationViewDelegate> {
    
    // app
    IMDGApp *imdgApp;
    IMDB *imdb;
    
    // controllers
    SearchResultViewController *_searchResultViewController;
    InformationViewController *_informationViewController;
    
    // ui
    UISearchBar *_searchBar;
    UIButton *_buttonMovie;
    UIButton *_buttonActor;
    UIButton *_buttonDirector;
    UIButton *_buttonReset;
    
    // popover
	UIPopoverController *_searchResultsPopoverController;
    
}

// Properties
@property (assign) IMDGApp *imdgApp;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UIButton *buttonMovie;
@property (nonatomic, retain) UIButton *buttonActor;
@property (nonatomic, retain) UIButton *buttonDirector;
@property (nonatomic, retain) UIButton *buttonReset;

// Action Methods
- (void)actionMovie:(id)sender;
- (void)actionActor:(id)sender;
- (void)actionDirector:(id)sender;
- (void)actionReset:(id)sender;

// Business Methods
- (void)search:(NSString*)q type:(NSString*)t;
- (void)nodeInformation:(NSString*)nid;
- (void)nodeLoad:(NSString*)nid;

@end
