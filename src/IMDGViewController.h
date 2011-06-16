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
@interface IMDGViewController : UIViewController {
    
    // app
    IMDGApp *imdgApp;
    
    // ui
    UIButton *buttonMovie;
    
}

// Properties
@property (assign) IMDGApp *imdgApp;
@property (nonatomic, retain) UIButton *buttonMovie;

// Action Methods
- (void)actionMovie:(id)sender;

@end
