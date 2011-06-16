//
//  IMDGViewController.h
//  IMDG
//
//  Created by CNPP on 16.6.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>


// Declarations
CPP_CLASS(IMDGApp);

/**
 * IMDG ViewController.
 */
@interface IMDGViewController : UIViewController <UISearchBarDelegate> {
    
    // app
    IMDGApp *imdgApp;
    
    // ui
    UISearchBar *_searchBar;
    UIButton *_buttonMovie;
    UIButton *_buttonActor;
    UIButton *_buttonDirector;
    
}

// Properties
@property (assign) IMDGApp *imdgApp;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UIButton *buttonMovie;
@property (nonatomic, retain) UIButton *buttonActor;
@property (nonatomic, retain) UIButton *buttonDirector;

// Action Methods
- (void)actionMovie:(id)sender;
- (void)actionActor:(id)sender;
- (void)actionDirector:(id)sender;

@end
