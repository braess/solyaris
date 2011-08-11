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
	return [self initWithFrame:CGRectMake(0, 0, 708, 480)];
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
    CGRect wframe = window.frame;
    float border = (wframe.size.width-vframe.size.width)/2.0;
    
    // frames
    CGRect cframe = CGRectMake(border, wframe.size.height-vframe.size.height-border, vframe.size.width, vframe.size.height);
    CGRect aframe = CGRectMake(0, 0, 320, 480);
    CGRect pframe = CGRectMake(cframe.size.width-320, 0, 320, 480);

    
    // view
    self.view = [[UIView alloc] initWithFrame:wframe];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.hidden = YES;
    
    // background
    UIView *bgView = [[UIView alloc] initWithFrame:wframe];
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"texture_settings.png"]];
    bgView.opaque = NO;
    [self.view addSubview:bgView];
    [bgView release];
    
	// content
    UIView *ctView = [[UIView alloc] initWithFrame:cframe];
    ctView.backgroundColor = [UIColor clearColor];
	ctView.opaque = YES;
    
    // about
    AboutViewController *aboutViewController = [[AboutViewController alloc] initWithFrame:aframe];
    [aboutViewController loadView];
    _aboutViewController = [aboutViewController retain];
    [ctView addSubview:_aboutViewController.view];
    [aboutViewController release];
    
    // Preferences
    PreferencesViewController *preferencesViewController = [[PreferencesViewController alloc] initWithStyle:UITableViewStylePlain];
    [preferencesViewController.view setFrame:pframe];
    _preferencesViewController = [preferencesViewController retain];
    [ctView addSubview:_preferencesViewController.view];
    [preferencesViewController release];
    
    
    // add & release content
    [self.view addSubview:ctView];
    [self.view bringSubviewToFront:ctView];
    [ctView release];
    
    
}

/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	DLog();
    
    // reload
    [_aboutViewController viewWillAppear:NO];
    [_preferencesViewController viewWillAppear:NO];
    
}



#pragma mark -
#pragma mark Touch

/*
 * Touches.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    DLog();
    
    // dismiss
    if (delegate && [delegate respondsToSelector:@selector(settingsDismiss)]) {
        [delegate settingsDismiss];
    }
}


@end
