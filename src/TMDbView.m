//
//  TMDbView.m
//  IMDG
//
//  Created by CNPP on 9.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "TMDbView.h"


/**
 * TMDbView.
 */
@implementation TMDbView

#pragma mark -
#pragma mark Object Methods


/*
 * Initialize.
 */
- (id) initWithFrame:(CGRect)frame {
	GLog();
	
	// init UIView
    self = [super initWithFrame:frame];
	
	// init HTMLView
    if (self != nil) {
        
        // view
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.opaque = YES;
        self.userInteractionEnabled = YES;
        self.scrollEnabled = YES;
        
        
        // text
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
        textView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        textView.textAlignment = UITextAlignmentLeft;
        textView.backgroundColor = [UIColor clearColor];
        textView.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        textView.textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
        textView.opaque = YES;
        textView.userInteractionEnabled = NO;
        textView.editable = NO;
        textView.scrollEnabled = NO;
        
        // add text to content
        _textView = [textView retain];
        [self addSubview:_textView];
        [textView release];
        
        
        
    }
    return self; 
}

/*
 * Layout.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // text
    _textView.frame = CGRectMake(8, 6, self.frame.size.width-20, self.frame.size.height-20);
}


#pragma mark -
#pragma mark Interface

/**
 * Resets the component.
 */
- (void)reset:(NSString*)text slides:(NSArray*)slides {
	FLog();
    
    // text
    [_textView setText:text];
    
}

/**
 * Loads the component.
 */
- (void)load {
    FLog();
    

}


/**
 * Scroll to top.
 */
- (void)scrollTop:(bool)animated {
    FLog();
    
    // scroll to top
}





#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
	
	// release
    [_textView release];
	
	// superduper
	[super dealloc];
}



@end
