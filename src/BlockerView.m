//
//  BlockerView.m
//  IMDG
//
//  Created by CNPP on 3.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "BlockerView.h"


/**
 * BlockerView.
 */
@implementation BlockerView

#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
	GLog();
    
	// init UIView
    self = [super initWithFrame:frame];
	
	// init self
    if (self != nil) {
		
		// init
		self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin);
        
		// return
		return self;
	}
	
	// nop
	return nil;
}



#pragma mark -
#pragma mark Touch

/*
 * Touches.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    // ignore
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    // ignore
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    GLog();
    // ignore
}



@end
