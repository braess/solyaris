//
//  SettingsViewController.m
//  IMDG
//
//  Created by CNPP on 5.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>


/**
 * SettingsViewController.
 */
@implementation SettingsViewController


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;
@synthesize contentView = _contentView;

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
    CGRect cframe = CGRectMake(border, wframe.size.height-vframe.size.height, vframe.size.width, vframe.size.height);
    CGRect aframe = CGRectMake(0, border, 320, vframe.size.height-border);
    CGRect pframe = CGRectMake(cframe.size.width-320, border, 320, vframe.size.height-border);

    
    // view
    self.view = [[UIView alloc] initWithFrame:wframe];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.hidden = YES;
    
    
	// content
    UIView *ctView = [[UIView alloc] initWithFrame:cframe];
    ctView.autoresizesSubviews = NO;
    ctView.contentMode = UIViewContentModeRedraw; // Thats the one
    ctView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    ctView.backgroundColor = [UIColor clearColor];
	ctView.opaque = YES;
    
    // drop that shadow
    float dx = 1024-768;
	CAGradientLayer *dropShadow = [[[CAGradientLayer alloc] init] autorelease];
	dropShadow.frame = CGRectMake(-border-dx, 0, cframe.size.width+2*border+2*dx, 12);
	dropShadow.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:1.0].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.3].CGColor,(id)[UIColor colorWithWhite:0 alpha:0].CGColor,nil];
	[ctView.layer insertSublayer:dropShadow atIndex:0];
    
    
    // about
    AboutViewController *aboutViewController = [[AboutViewController alloc] initWithFrame:aframe];
    [aboutViewController loadView];
    _aboutViewController = [aboutViewController retain];
    [ctView addSubview:_aboutViewController.view];
    [aboutViewController release];
    
    // Preferences
    PreferencesViewController *preferencesViewController = [[PreferencesViewController alloc] initWithStyle:UITableViewStylePlain];
    preferencesViewController.delegate = self;
    [preferencesViewController.view setFrame:pframe];
    _preferencesViewController = [preferencesViewController retain];
    [ctView addSubview:_preferencesViewController.view];
    [preferencesViewController release];
    
    
    // add & release content
    self.contentView = [ctView retain];
    [self.view addSubview:_contentView];
    [self.view bringSubviewToFront:_contentView];
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



#pragma mark -
#pragma mark Preferences Delegate

/*
 * Get/Set/Reset preference.
 */
- (void)setPreference:(NSString*)key value:(NSObject*)value {
    GLog();
    
    // user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// set
    if (value != NULL) {
        [userDefaults setObject:value forKey:key];
    }
    else {
        [userDefaults removeObjectForKey:key];
    }
    
    // sync
	[userDefaults synchronize];
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(settingsApply)]) {
        [delegate settingsApply];
    }
    
}
- (NSObject*)getPreference:(NSString*)key {
    GLog();
    
    // user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// return
	NSObject *v = [userDefaults objectForKey:key];
	return v;
                
}
- (void)resetPreferences {
    GLog();
    
	// user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
	// clear defaults
	[userDefaults setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
	[userDefaults synchronize];
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(settingsApply)]) {
        [delegate settingsApply];
    }
}





@end
