//
//  TMDbView.h
//  IMDG
//
//  Created by CNPP on 9.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * TMDbView.
 */
@interface TMDbView : UIScrollView {
    
    // ui
    UITextView *_textView;
    
}

// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Methods
- (void)reset:(NSString*)text slides:(NSArray*)slides;
- (void)load;
- (void)scrollTop:(bool)animated;

@end
