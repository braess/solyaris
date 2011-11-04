//
//  LinkButton.h
//  Solyaris
//
//  Created by Beat Raess on 4.11.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * LinkButtonDelegate Protocol.
 */
@class LinkButton;
@protocol LinkButtonDelegate <NSObject>
- (void)linkButtonTouched:(LinkButton*)lb;
@optional
- (void)linkButtonDown:(LinkButton*)lb;
- (void)linkButtonUp:(LinkButton*)lb;
@end


/**
 * Link Button.
 */
@interface LinkButton : UIButton {
    
    // delegate
	id<LinkButtonDelegate>delegate;
    
    // link
    NSString *_link;
}

// Properties
@property (assign) id<LinkButtonDelegate> delegate;
@property (nonatomic, retain) NSString *link;

@end
