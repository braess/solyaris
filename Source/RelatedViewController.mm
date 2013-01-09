//
//  RelatedViewController.m
//  Solyaris
//
//  Created by Beat Raess on 29.5.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
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

#import "RelatedViewController.h"
#import "SolyarisConstants.h"
#import "Tracker.h"
#import <QuartzCore/QuartzCore.h>


/**
 * Gesture Stack.
 */
@interface RelatedViewController (GestureStack)
- (void)gestureTap:(UITapGestureRecognizer *)recognizer;
@end


/**
 * RelatedViewController.
 */
@implementation RelatedViewController


#pragma mark -
#pragma mark Properties

// synthesize
@synthesize delegate;
@synthesize modalView = _modalView;
@synthesize contentView = _contentView;


#pragma mark -
#pragma mark Object

/**
 * Init.
 */
- (id)initWithFrame:(CGRect)frame {
    
    // self
	if ((self = [super init])) {
        
		// view
		vframe = frame;
        vPos = CGPointMake(0, 0);
        
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
    
    // view
    UIView *sview = [[UIView alloc] initWithFrame:CGRectZero];
    sview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view = sview;
    [sview release];
    
    
    // modal
    UIView *modalView = [[UIView alloc] initWithFrame:CGRectZero];
    modalView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    modalView.backgroundColor = [UIColor whiteColor];
    modalView.opaque = NO;
    modalView.alpha = 0.1;
    _modalView = [modalView retain];
    [self.view addSubview:_modalView];
    [modalView release];
    
    // content view
    UIView *contentView = [[RelatedView alloc] initWithFrame:vframe];
    
    _contentView = [contentView retain];
    [self.view addSubview:_contentView];
    [contentView release];
    
    
    // container
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    containerView.autoresizesSubviews = YES;
    
    _containerView = [containerView retain];
    [self.contentView addSubview:_containerView];
    [containerView release];
    
    
    // close
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnClose.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    [btnClose setImage:[UIImage imageNamed:@"btn_close_plain.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(actionClose:) forControlEvents:UIControlEventTouchUpInside];
    _buttonClose = [btnClose retain];
    [self.contentView addSubview:_buttonClose];
    
    
    // data view
    DBDataViewController *dbDataViewController = [[DBDataViewController alloc] init];
    [dbDataViewController loadView];
    dbDataViewController.delegate = self;
    dbDataViewController.header.back = NO;
    [dbDataViewController.header.labelTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
    
	_dbDataViewController = [dbDataViewController retain];
    [_containerView addSubview:_dbDataViewController.view];
    [dbDataViewController release];
    
    // gestures
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setDelegate:self];
    [_modalView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    
    // resize
    [self resize];
}

/*
 * View appears.
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog();
    
    // track
    [Tracker trackView:@"Related"];
}


/*
 * Cleanup rotation.
 */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    GLog();
    
    // resize
    [self resize];
}


/**
 * Resize.
 */
- (void)resize {
    FLog();
    
    // vars
    BOOL landscape = UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    
    // screen
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    // frames
    CGRect selfFrame = landscape ? CGRectMake(0,0,screen.size.height,screen.size.width) : CGRectMake(0,0,screen.size.width,screen.size.height);
    CGRect contentFrame = CGRectMake(MIN(vPos.x,selfFrame.size.width-vframe.size.width-10), MIN(vPos.y,selfFrame.size.height-vframe.size.height-10), vframe.size.width, vframe.size.height);
    if (!iPad) {
        contentFrame = CGRectMake((int)((selfFrame.size.width-vframe.size.width)/2.0), (int)((selfFrame.size.height-vframe.size.height)/2.0), vframe.size.width, vframe.size.height);
        contentFrame.origin.y += landscape ? 0 : -30;
    }
    
    CGRect containerFrame = CGRectMake(10, 0, contentFrame.size.width-20, contentFrame.size.height-10);
    CGRect dataFrame = CGRectMake(0,1,containerFrame.size.width,containerFrame.size.height-1);

    
    // views
    self.view.frame = selfFrame;
    _modalView.frame = selfFrame;
    _contentView.frame = contentFrame;
    _containerView.frame = containerFrame;
    _dbDataViewController.view.frame = dataFrame;

    // buttons
    _buttonClose.frame = CGRectMake(contentFrame.size.width-44-5, 5, 44, 44);
    
}


#pragma mark -
#pragma mark Business

/**
 * Positions the thing.
 */
- (CGPoint)position:(double)r posx:(double)px posy:(double)py {
    FLog();
    
    // offset
    CGPoint offset = CGPointMake(0, 0);
    
    // ipad
    if (iPad) {
        vPos = CGPointMake(px-vframe.size.width/2.0, py-r-vframe.size.height);
        if (vPos.x < 10) {
            offset.x = (vPos.x < 0) ? (-vPos.x+10) : (10-vPos.x);
            vPos.x = 10;
        }
        else if (vPos.x > self.view.frame.size.width-10-vframe.size.width) {
            offset.x = - (vPos.x+vframe.size.width - (self.view.frame.size.width-10));
            vPos.x = self.view.frame.size.width-10-vframe.size.width;
        }
        if (vPos.y < 10) {
           offset.y = (vPos.y < 0) ? (-vPos.y+10) : (10-vPos.y);
           vPos.y = 10;
        }
    }
    
    // fluff
    vPos.x = (int)vPos.x;
    vPos.y = (int)vPos.y;
    
    // resize
    [self resize];
    
    // offset
    return offset;
    
}


/**
 * Loaded related.
 */
- (void)loadedRelated:(Movie *)movie more:(BOOL)more {
    FLog();
    
    // db data
    [_dbDataViewController dataRelated:movie more:more];
    
}


#pragma mark -
#pragma mark DBData Delegate

/*
 * Data selected.
 */
- (void)dbDataSelected:(DBData*)data {
    FLog();
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(relatedSelected:)]) {
        [delegate relatedSelected:data];
    }
    
}

/*
 * Load more.
 */
- (void)dbDataLoadMore:(DBData*)data {
    FLog();
    
    // switch
    switch (data.dta) {
            
        // related
        case DBDataMovieRelated: {
            
            // delegate
            if (delegate && [delegate respondsToSelector:@selector(relatedLoadMore:)]) {
                [delegate relatedLoadMore:data];
            }
            break;
        }
            
        // default
        default:
            break;
    }
}



#pragma mark -
#pragma mark Actions

/*
 * Action close.
 */
- (void)actionClose:(id)sender {
    DLog();
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(relatedClose)]) {
        [delegate relatedClose];
    }
}


#pragma mark -
#pragma mark Gestures

/*
 * Gesture tap.
 */
- (void)gestureTap:(UITapGestureRecognizer *)recognizer {
    FLog();
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(relatedClose)]) {
        [delegate relatedClose];
    }
    
}



#pragma mark -
#pragma mark Memory management

/*
 * Deallocates used memory.
 */
- (void)dealloc {
	FLog();
    
    // ui
    [_modalView release];
    [_contentView release];
    [_containerView release];
    [_buttonClose release];
    
    // controller
    [_dbDataViewController release];
    
	
	// release 
    [super dealloc];
}

@end




#pragma mark -
#pragma mark RelatedView
#pragma mark -

/**
 * RelatedView.
 */
@implementation RelatedView


#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
	GLog();
	
	// init self
    if ((self = [super initWithFrame:frame])) {
        
        // self
        self.autoresizingMask = UIViewAutoresizingNone;
        self.autoresizesSubviews = YES;
        self.contentMode = UIViewContentModeRedraw;
        
        // image view
        UIImageView *backdrop = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backdrop = [backdrop retain];
        [backdrop release];
        
        // background
        UIImage *img = [UIImage imageNamed:@"bd_related.png"];
        if ([img respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
             self.backgroundColor = [UIColor clearColor];
            _backdrop.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
            [self addSubview:_backdrop];
        }
        else {
            self.backgroundColor = [UIColor whiteColor];
            self.layer.cornerRadius = 8;
            self.layer.cornerRadius = 8;
            self.layer.shadowColor = [[UIColor blackColor] CGColor];
            self.layer.shadowOpacity = 0.3;
            self.layer.shadowRadius = 3.0;
            self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);    
            self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        }
        
        // line
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor colorWithWhite:0.82 alpha:1];
        
        _line = [line retain];
        [self addSubview:_line];
        [line release];
        
	}
	
	// return
	return self;
}

/*
 * Layout.
 */
- (void)layoutSubviews {
    
    // backdrop
    _backdrop.frame = CGRectMake(-5, -5, self.frame.size.width+10, self.frame.size.height+10);
    
    // line
    _line.frame = CGRectMake(10, 44, self.frame.size.width-20, 1);
}





#pragma mark -
#pragma mark Memory management

/*
 * Deallocates used memory.
 */
- (void)dealloc {
	GLog();
    
    // self
    [_line release];
    [_backdrop release];
	
	// release 
    [super dealloc];
}


@end
