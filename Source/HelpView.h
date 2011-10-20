//
//  HelpView.h
//  Solyaris
//
//  Created by Beat Raess on 20.10.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * Help View.
 */
@interface HelpView : UIView {
    
	// ui
    UIImageView *_imageHelp;
    
    // private
    @private
    BOOL animation_dismiss;
    BOOL animation_show;
    
}


// Business Methods
- (void)showHelp;
- (void)dismissHelp;

@end
