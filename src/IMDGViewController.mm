//
//  IMDGViewController.m
//  IMDG
//
//  Created by CNPP on 16.6.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import "IMDGViewController.h"
#import "IMDGApp.h"

/**
 * IMDG ViewController.
 */
@implementation IMDGViewController


#pragma mark -
#pragma mark Properties

// accessors
@synthesize imdgApp;
@synthesize buttonMovie;


#pragma mark -
#pragma mark Object Methods

/**
 * Init.
 */
- (id)initWithFrame:(CGRect)frame {
	
	// init super
	if ((self = [super init])) {
		GLog();
        
        
        // view
        self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
        self.view.backgroundColor = [UIColor redColor];
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		
		// return
		return self;
	}
	
	// nil not nile
	return nil;
}



#pragma mark -
#pragma mark View lifecycle

/*
 * Loads the view.
 */
-(void)loadView {
	[super loadView];
	FLog();
    
    // size
	float swidth = self.view.frame.size.width;
	float sheight = self.view.frame.size.height;
    
	
	
	// button movie
	UIButton *btnMovie = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
	btnMovie.frame = CGRectMake(swidth-50, sheight-50, 50, 50);
	[btnMovie addTarget:self action:@selector(actionMovie:) forControlEvents:UIControlEventTouchUpInside];
	self.buttonMovie = btnMovie;
	[self.view addSubview:buttonMovie];
	[btnMovie release];
    
  
}

/*
 * Prepares the view.
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	FLog();

    
}


#pragma mark -
#pragma mark Rotation support

/*
 * Rotate is the new black.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


#pragma mark -
#pragma mark Actions


/*
 * Action Movie.
 */
- (void)actionMovie:(id)sender {
	DLog();
    imdgApp->test();
}


#pragma mark -
#pragma mark Memory management

/*
 * Deallocates used memory.
 */
- (void)dealloc {
	GLog();
	
	
	// release global
    [super dealloc];
}

@end
