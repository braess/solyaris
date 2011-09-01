//
//  ActionBar.h
//  IMDG
//
//  Created by CNPP on 1.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * ActionBar.
 */
@interface ActionBar : UIToolbar {
    
}

@end

/**
 * Custom ActionBarButton.
 */
@interface ActionBarButton : UIButton {
}

// Constructor
- (id)initWithImage:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action;

@end


/**
 * Custom ActionBarButtonItem.
 */
@interface ActionBarButtonItem : UIBarButtonItem {
    
    // button
    ActionBarButton *_barButton;
}

// Constructor
- (id)initWithImage:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action;
- (void)setSelected:(BOOL)s;
- (void)setTitle:(NSString *)title;
- (void)modeDarkie;

@end
