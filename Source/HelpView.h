//
//  HelpView.h
//  Solyaris
//
//  Created by Beat Raess on 20.10.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
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

#import <UIKit/UIKit.h>
#import "PageControl.h"

// Steps
enum {
    HelpStepWelcome,
    HelpStepSearch,
    HelpStepNodeInteraction,
    HelpStepAppInteraction
};

/**
 * HelpLabel.
 */
@interface HelpLabel : UILabel {
}
@end

/**
 * HelpText.
 */
@interface HelpText : UITextView {
}
@end


/**
 * Help View.
 */
@interface HelpView : UIView {
    
	// ui
    UIImageView *_imageHelp;
    
    HelpLabel *_labelWelcome;
    HelpText *_textWelcome;
    
    HelpLabel *_labelSearch;
    HelpText *_textSearch;
    
    HelpLabel *_labelNode1;
    HelpText *_textNode1;
    
    HelpLabel *_labelNode2;
    HelpText *_textNode2;
    
    HelpLabel *_labelNode3;
    HelpText *_textNode3;
    
    HelpLabel *_labelNode4;
    HelpText *_textNode4;
    
    HelpLabel *_labelApp1;
    HelpText *_textApp1;
    
    HelpLabel *_labelApp2;
    HelpText *_textApp2;
    
    HelpLabel *_labelApp3;
    HelpText *_textApp3;
    
    HelpLabel *_labelApp4;
    HelpText *_textApp4;
    
    PageControl *_pageControl;
    
    // private
    @private
    
    // step
    int step;
    
    // state
    BOOL animating;
    
}


// Business Methods
- (void)update;
- (void)showHelp;
- (void)nextHelp;
- (void)dismissHelp;

@end
