//
//  SettingsViewController.m
//  IMDG
//
//  Created by CNPP on 5.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "SettingsViewController.h"

/**
 * SettingsViewController.
 */
@implementation SettingsViewController


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;

// local vars
CGRect vframe;


#pragma mark -
#pragma mark Object Methods

/*
 * Init.
 */
-(id)init {
	return [self initWithFrame:CGRectMake(0, 0, 320, 480)];
}
-(id)initWithFrame:(CGRect)frame {
	GLog();
	// self
	if ((self = [super init])) {
        
		// view
		vframe = frame;
		
	}
	return self;
}


#pragma mark -
#pragma mark View lifecycle


/*
 * Loads the view.
 */
- (void)loadView {
	[super loadView];
	DLog();
    
    // window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // frames
    CGRect wframe = window.frame;
    CGRect cframe = CGRectMake(wframe.size.width-vframe.size.width, wframe.size.height-vframe.size.height, vframe.size.width, vframe.size.height);

    
    // view
    self.view = [[UIView alloc] initWithFrame:wframe];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.hidden = YES;
    
    // background
    UIView *bgView = [[UIView alloc] initWithFrame:wframe];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.opaque = NO;
    [self.view addSubview:bgView];
    [bgView release];
    
	
	// content
    UIView *ctView = [[UIView alloc] initWithFrame:cframe];
    
    // add & release content
    [self.view addSubview:ctView];
    [self.view bringSubviewToFront:ctView];
    [ctView release];
    
    
}


@end
