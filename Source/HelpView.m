//
//  HelpView.m
//  Solyaris
//
//  Created by Beat Raess on 20.10.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
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

#import "HelpView.h"
#import "SolyarisConstants.h"

/**
 * Help Stack.
 */
@interface HelpView (HelpAnimations)
- (void)animationShowHelp;
- (void)animationShowNoteDone;
- (void)animationDismissHelp;
- (void)animationDismissHelpDone;
@end


/**
 * Gesture Stack.
 */
@interface HelpView (Gestures)
- (void)tapped:(UITapGestureRecognizer*)recognizer;
- (void)swipedRight:(UITapGestureRecognizer*)recognizer;
- (void)swipedLeft:(UITapGestureRecognizer*)recognizer;
@end



/**
 * Help View.
 */
@implementation HelpView


#pragma mark -
#pragma mark Constants

// constants
#define kAnimateTimeHelpShow            1.5f
#define kAnimateTimeHelpDismiss         0.45f



#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
    GLog();
    
	// super
    if ((self = [super initWithFrame:frame])) {
        
        // self
        self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.userInteractionEnabled = YES;
		
        // flags
        animating = NO;
        
				
		// image
		UIImageView *imageHelp = [[UIImageView alloc] initWithFrame:CGRectZero];
		imageHelp.autoresizingMask = UIViewAutoresizingNone;
		imageHelp.backgroundColor = [UIColor clearColor];
		imageHelp.contentMode = UIViewContentModeCenter;
        imageHelp.image = iPad ? [UIImage imageNamed:@"help.png"] : [UIImage imageNamed:@"help_redux.png"];
        
        _imageHelp = [imageHelp retain];
        [self addSubview:_imageHelp];
        [imageHelp release];
        
        // welcome
        HelpLabel *lblWelcome = [[HelpLabel alloc] initWithFrame:CGRectZero];
        lblWelcome.font = iPad ? [UIFont fontWithName:@"Helvetica-Bold" size:21.0] : [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
        lblWelcome.numberOfLines = 2;
        [lblWelcome setText:NSLocalizedString(@"Welcome to Solyaris\nA Visual Movie Browser",@"Welcome to Solyaris\nA Visual Movie Browser")];
        
        _labelWelcome = [lblWelcome retain];
        [self addSubview:_labelWelcome];
        [lblWelcome release];
        
        HelpText *txtWelcome = [[HelpText alloc] initWithFrame:CGRectZero];
        [txtWelcome setText:NSLocalizedString(@"Search the entire Open Movie Database (TMDb) for movies, actors or directors. Expand nodes to gather information about their connections. Learn about the cast and filmography.",@"Search the entire Open Movie Database (TMDb) for movies, actors or directors. Expand nodes to gather information about their connections. Learn about the cast and filmography.")];
        
        _textWelcome = [txtWelcome retain];
        [self addSubview:_textWelcome];
        [txtWelcome release];
        
        // search
        HelpLabel *lblSearch = [[HelpLabel alloc] initWithFrame:CGRectZero];
        [lblSearch setText:NSLocalizedString(@"Search",@"Search")];
        
        _labelSearch = [lblSearch retain];
        [self addSubview:_labelSearch];
        [lblSearch release];
        
        HelpText *txtSearch = [[HelpText alloc] initWithFrame:CGRectZero];
        [txtSearch setText:NSLocalizedString(@"for movies or people.",@"for movies or people.")];
        
        _textSearch = [txtSearch retain];
        [self addSubview:_textSearch];
        [txtSearch release];
        
        // node
        HelpLabel *lblNode1 = [[HelpLabel alloc] initWithFrame:CGRectZero];
        [lblNode1 setText:NSLocalizedString(@"Touch",@"Touch")];
        
        _labelNode1 = [lblNode1 retain];
        [self addSubview:_labelNode1];
        [lblNode1 release];
        
        HelpText *txtNode1 = [[HelpText alloc] initWithFrame:CGRectZero];
        [txtNode1 setText:NSLocalizedString(@"to see their relation.",@"to see their relation.")];
        
        _textNode1 = [txtNode1 retain];
        [self addSubview:_textNode1];
        [txtNode1 release];
        
        HelpLabel *lblNode2 = [[HelpLabel alloc] initWithFrame:CGRectZero];
        [lblNode2 setText:NSLocalizedString(@"Double Tap",@"Double Tap")];
        
        _labelNode2 = [lblNode2 retain];
        [self addSubview:_labelNode2];
        [lblNode2 release];
        
        HelpText *txtNode2 = [[HelpText alloc] initWithFrame:CGRectZero];
        [txtNode2 setText:NSLocalizedString(@"to load and expand the movie or person.",@"to load and expand the movie or person.")];
        
        _textNode2 = [txtNode2 retain];
        [self addSubview:_textNode2];
        [txtNode2 release];
        
        HelpLabel *lblNode3 = [[HelpLabel alloc] initWithFrame:CGRectZero];
        [lblNode3 setText:NSLocalizedString(@"Touch & Hold",@"Touch & Hold")];
        
        _labelNode3 = [lblNode3 retain];
        [self addSubview:_labelNode3];
        [lblNode3 release];
        
        HelpText *txtNode3 = [[HelpText alloc] initWithFrame:CGRectZero];
        [txtNode3 setText:NSLocalizedString(@"to show and select actions.",@"to show and select actions.")];
        
        _textNode3 = [txtNode3 retain];
        [self addSubview:_textNode3];
        [txtNode3 release];
        
        HelpLabel *lblNode4 = [[HelpLabel alloc] initWithFrame:CGRectZero];
        [lblNode4 setText:NSLocalizedString(@"Double Tap Loaded",@"Double Tap Loaded")];
        
        _labelNode4 = [lblNode4 retain];
        [self addSubview:_labelNode4];
        [lblNode4 release];
        
        HelpText *txtNode4 = [[HelpText alloc] initWithFrame:CGRectZero];
        [txtNode4 setText:NSLocalizedString(@"to get additional information about the cast and filmography.",@"to get additional information about the cast and filmography.")];
        
        _textNode4 = [txtNode4 retain];
        [self addSubview:_textNode4];
        [txtNode4 release];
        
        
        // app
        HelpLabel *lblApp1 = [[HelpLabel alloc] initWithFrame:CGRectZero];
        [lblApp1 setText:NSLocalizedString(@"Touch & Drag",@"Touch & Drag")];
        
        _labelApp1 = [lblApp1 retain];
        [self addSubview:_labelApp1];
        [lblApp1 release];
        
        HelpText *txtApp1 = [[HelpText alloc] initWithFrame:CGRectZero];
        [txtApp1 setText:NSLocalizedString(@"to move the selected nodes.",@"to move the selected nodes.")];
        
        _textApp1 = [txtApp1 retain];
        [self addSubview:_textApp1];
        [txtApp1 release];
        
        HelpLabel *lblApp2 = [[HelpLabel alloc] initWithFrame:CGRectZero];
        [lblApp2 setText:NSLocalizedString(@"Drag",@"Drag")];
        
        _labelApp2 = [lblApp2 retain];
        [self addSubview:_labelApp2];
        [lblApp2 release];
        
        HelpText *txtApp2 = [[HelpText alloc] initWithFrame:CGRectZero];
        [txtApp2 setText:NSLocalizedString(@"to move all nodes.",@"to move all nodes.")];
        
        _textApp2 = [txtApp2 retain];
        [self addSubview:_textApp2];
        [txtApp2 release];
        
        HelpLabel *lblApp3 = [[HelpLabel alloc] initWithFrame:CGRectZero];
        [lblApp3 setText:NSLocalizedString(@"Pinch",@"Pinch")];
        
        _labelApp3 = [lblApp3 retain];
        [self addSubview:_labelApp3];
        [lblApp3 release];
        
        HelpText *txtApp3 = [[HelpText alloc] initWithFrame:CGRectZero];
        [txtApp3 setText:NSLocalizedString(@"to zoom in or out.",@"to zoom in or out.")];
        
        _textApp3 = [txtApp3 retain];
        [self addSubview:_textApp3];
        [txtApp3 release];
        
        HelpLabel *lblApp4 = [[HelpLabel alloc] initWithFrame:CGRectZero];
        [lblApp4 setText:NSLocalizedString(@"Tap Corner",@"Tap Corner")];
        
        _labelApp4 = [lblApp4 retain];
        [self addSubview:_labelApp4];
        [lblApp4 release];
        
        HelpText *txtApp4 = [[HelpText alloc] initWithFrame:CGRectZero];
        [txtApp4 setText:NSLocalizedString(@"to adjust and tweak settings.",@"to adjust and tweak settings.")];
        
        _textApp4 = [txtApp4 retain];
        [self addSubview:_textApp4];
        [txtApp4 release];
        
        // page control
        PageControl *pControl = [[PageControl alloc] initWithFrame:CGRectZero];
        _pageControl = [pControl retain];
        [self addSubview:_pageControl];
        [pControl release];
        
        // gestures
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRight];
        [swipeRight release];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeLeft];
        [swipeLeft release];
        
	}
	
	// self
	return self;
}

/*
 * Layout.
 */
- (void)layoutSubviews {
    GLog();
    
    // orientation
    BOOL portrait = UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    
    // frames
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect fSelf = portrait ? CGRectMake(0, 0, screen.size.width, screen.size.height) : CGRectMake(0, 0, screen.size.height, screen.size.width);

    
    // self
    self.frame = fSelf;
    _imageHelp.frame = fSelf;
    
    // steps
    _labelWelcome.frame = iPad ? CGRectMake(30, 60, 360, 50) 
                               : CGRectMake(10, 50, 320, 50);
    _textWelcome.frame = CGRectMake(_labelWelcome.frame.origin.x, _labelWelcome.frame.origin.y+(iPad?50:45), _labelWelcome.frame.size.width, 120);
    
    _labelSearch.frame = iPad ? CGRectMake(fSelf.size.width/2.0+20, 50, 360, 20)
                              : CGRectMake(fSelf.size.width/2.0-85, 50, 240, 20);
    _textSearch.frame = CGRectMake(_labelSearch.frame.origin.x, _labelSearch.frame.origin.y+10, _labelSearch.frame.size.width, 45);
    
    _labelNode1.frame = iPad ? CGRectMake(fSelf.size.width/2.0-160, fSelf.size.height/2.0-205, 360, 20)
                             : (portrait ? CGRectMake(fSelf.size.width/2.0-150, fSelf.size.height/2.0-190, 240, 20) 
                                         : CGRectMake(fSelf.size.width/2.0-200, fSelf.size.height/2.0-75, 240, 20));
    _textNode1.frame = CGRectMake(_labelNode1.frame.origin.x, _labelNode1.frame.origin.y+10, _labelNode1.frame.size.width, 45);
    
    _labelNode2.frame = iPad ? CGRectMake(fSelf.size.width/2.0+50, fSelf.size.height/2.0-160, 360, 20)
                             : (portrait ? CGRectMake(fSelf.size.width/2.0-20, fSelf.size.height/2.0-145, 180, 20) 
                                         : CGRectMake(fSelf.size.width/2.0+50, fSelf.size.height/2.0-105, 180, 20));
    _textNode2.frame = CGRectMake(_labelNode2.frame.origin.x, _labelNode2.frame.origin.y+10, _labelNode2.frame.size.width, 45);
    
    _labelNode3.frame = iPad ? CGRectMake(fSelf.size.width/2.0+135, fSelf.size.height/2.0+60, 360, 20)
                             : CGRectMake(fSelf.size.width/2.0-140, fSelf.size.height/2.0+0, 240, 20);
    _textNode3.frame = CGRectMake(_labelNode3.frame.origin.x, _labelNode3.frame.origin.y+10, _labelNode3.frame.size.width, 45);
    
    _labelNode4.frame = iPad ? CGRectMake(fSelf.size.width/2.0-50, fSelf.size.height/2.0+170, 420, 20)
                              : (portrait ? CGRectMake(fSelf.size.width/2.0-70, fSelf.size.height/2.0+135, 240, 20) 
                                         :  CGRectMake(fSelf.size.width/2.0+10, fSelf.size.height/2.0+90, 240, 20));
    _textNode4.frame = CGRectMake(_labelNode4.frame.origin.x, _labelNode4.frame.origin.y+10, _labelNode4.frame.size.width, 45);
    
    
    _labelApp1.frame = iPad ? CGRectMake(fSelf.size.width/2.0-210, fSelf.size.height/2.0+230, 360, 20)
                            : (portrait ? CGRectMake(fSelf.size.width/2.0-140, fSelf.size.height/2.0+85, 240, 20)
                                        : CGRectMake(fSelf.size.width/2.0-200, fSelf.size.height/2.0+85, 240, 20));
    _textApp1.frame = CGRectMake(_labelApp1.frame.origin.x, _labelApp1.frame.origin.y+10, _labelApp1.frame.size.width, 45);
    
    _labelApp2.frame = iPad ? CGRectMake(fSelf.size.width/2.0-280, fSelf.size.height/2.0+275, 360, 20)
                            : (portrait ? CGRectMake(fSelf.size.width/2.0-130, fSelf.size.height/2.0-40, 280, 20) 
                                        : CGRectMake(fSelf.size.width/2.0-160, fSelf.size.height/2.0-40, 280, 20));
    _textApp2.frame = CGRectMake(_labelApp2.frame.origin.x, _labelApp2.frame.origin.y+10, _labelApp2.frame.size.width, 45);
    
    _labelApp3.frame = iPad ? CGRectMake(fSelf.size.width/2.0-120, fSelf.size.height/2.0+320, 360, 20)
                            : (portrait ? CGRectMake(fSelf.size.width/2.0-40, fSelf.size.height/2.0-180, 240, 20) 
                                        : CGRectMake(fSelf.size.width/2.0+45, fSelf.size.height/2.0-122, 240, 20));
    _textApp3.frame = CGRectMake(_labelApp3.frame.origin.x, _labelApp3.frame.origin.y+10, _labelApp3.frame.size.width, 45);
    
    _labelApp4.frame = iPad ? CGRectMake(fSelf.size.width-260, fSelf.size.height-60, 220, 20)
                            : (portrait ? CGRectMake(fSelf.size.width-240, fSelf.size.height-60, 240, 20) 
                                        : CGRectMake(fSelf.size.width-220, fSelf.size.height-55, 220, 20));
    _textApp4.frame = CGRectMake(_labelApp4.frame.origin.x, _labelApp4.frame.origin.y+10, _labelApp4.frame.size.width, 45);
    
    
    // page control
    _pageControl.frame = CGRectMake(0, fSelf.size.height-25, fSelf.size.width, 30);
    _pageControl.numberOfPages = 4;
    
    
}


#pragma mark -
#pragma mark Rotation

/*
 * Rotate is the new black.
 */
- (BOOL)shouldAutorotate {
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}




#pragma mark -
#pragma mark Gestures

/*
 * Tapped.
 */
- (void)tapped:(UITapGestureRecognizer*) recognizer  {
	FLog();
    
    // next
    if (step < 3) {
        [self nextHelp];
    }
    else {
        [self dismissHelp];
    }
}

/*
 * Swiped.
 */
- (void)swipedLeft:(UITapGestureRecognizer *)recognizer {
    FLog();
    
    // next
    if (step < 3) {
        [self nextHelp];
    }
    else {
        [self dismissHelp];
    }
}
- (void)swipedRight:(UITapGestureRecognizer *)recognizer {
    FLog();
    
    // next
    if (step > 0) {
        [self previousHelp];
    }

}



#pragma mark -
#pragma mark Business Methods

/**
 * Update.
 */
- (void)update {
    
    // step
    switch (step) {
        
        // welcome
        case HelpStepWelcome: {
            FLog("HelpStepWelcome");
            
            // page
            _pageControl.currentPage = 0;
            
            // hide
            _imageHelp.hidden = YES;
            
            _labelSearch.hidden = YES;
            _textSearch.hidden = YES;
            
            _labelNode1.hidden = YES;
            _textNode1.hidden = YES;
            _labelNode2.hidden = YES;
            _textNode2.hidden = YES;
            _labelNode3.hidden = YES;
            _textNode3.hidden = YES;
            _labelNode4.hidden = YES;
            _textNode4.hidden = YES;
            
            _labelApp1.hidden = YES;
            _textApp1.hidden = YES;
            _labelApp2.hidden = YES;
            _textApp2.hidden = YES;
            _labelApp3.hidden = YES;
            _textApp3.hidden = YES;
            _labelApp4.hidden = YES;
            _textApp4.hidden = YES;
            
            // show
            _labelWelcome.hidden = NO;
            _textWelcome.hidden = NO;
            
            // done
            break;
        }
            
        // search
        case HelpStepSearch: {
            FLog("HelpStepSearch");
            
            // page
            _pageControl.currentPage = 1;
            
            // unhide
            _labelWelcome.hidden = iPad ? NO : YES;
            _textWelcome.hidden = iPad ? NO : YES;
            
            // hide
            _imageHelp.hidden = YES;
            
            _labelNode1.hidden = YES;
            _textNode1.hidden = YES;
            _labelNode2.hidden = YES;
            _textNode2.hidden = YES;
            _labelNode3.hidden = YES;
            _textNode3.hidden = YES;
            _labelNode4.hidden = YES;
            _textNode4.hidden = YES;
            
            _labelApp1.hidden = YES;
            _textApp1.hidden = YES;
            _labelApp2.hidden = YES;
            _textApp2.hidden = YES;
            _labelApp3.hidden = YES;
            _textApp3.hidden = YES;
            _labelApp4.hidden = YES;
            _textApp4.hidden = YES;
            
            // show
            _labelSearch.hidden = NO;
            _textSearch.hidden = NO;
            
            // done
            break;
        }
            
        // node interaction
        case HelpStepNodeInteraction: {
            FLog("HelpStepNodeInteraction");
            
            // page
            _pageControl.currentPage = 2;
            
            // unhide
            _labelWelcome.hidden = iPad ? NO : YES;
            _textWelcome.hidden = iPad ? NO : YES;
            
            _labelSearch.hidden = iPad ? NO : YES;
            _textSearch.hidden =iPad ? NO : YES;
            
            // hide
            _labelApp1.hidden = YES;
            _textApp1.hidden = YES;
            _labelApp2.hidden = YES;
            _textApp2.hidden = YES;
            _labelApp3.hidden = YES;
            _textApp3.hidden = YES;
            _labelApp4.hidden = YES;
            _textApp4.hidden = YES;
            
            // show
            _imageHelp.hidden = NO;
            
            _labelNode1.hidden = NO;
            _textNode1.hidden = NO;
            _labelNode2.hidden = NO;
            _textNode2.hidden = NO;
            _labelNode3.hidden = NO;
            _textNode3.hidden = NO;
            _labelNode4.hidden = NO;
            _textNode4.hidden = NO;
            
            // done
            break;
        }
            
        // node interaction
        case HelpStepAppInteraction: {
            FLog("HelpStepAppInteraction");
            
            // page
            _pageControl.currentPage = 3;
            
            // unhide
            _labelWelcome.hidden = iPad ? NO : YES;
            _textWelcome.hidden = iPad ? NO : YES;
            
            _labelSearch.hidden = iPad ? NO : YES;
            _textSearch.hidden = iPad ? NO : YES;
            
            _labelNode1.hidden = iPad ? NO : YES;
            _textNode1.hidden = iPad ? NO : YES;
            _labelNode2.hidden = iPad ? NO : YES;
            _textNode2.hidden = iPad ? NO : YES;
            _labelNode3.hidden = iPad ? NO : YES;
            _textNode3.hidden = iPad ? NO : YES;
            _labelNode4.hidden = iPad ? NO : YES;
            _textNode4.hidden = iPad ? NO : YES;
            
            // show
            _labelApp1.hidden = NO;
            _textApp1.hidden = NO;
            _labelApp2.hidden = NO;
            _textApp2.hidden = NO;
            _labelApp3.hidden = NO;
            _textApp3.hidden = NO;
            _labelApp4.hidden = NO;
            _textApp4.hidden = NO;
            
            // done
            break;
        }
            
            
        // something's broken
        default:
            break;
    }
    
}

/**
 * Shows / dismisses the help.
 */
- (void)showHelp {
    DLog();
    
    // reset
    step = HelpStepWelcome;
    
    // update
    [self update];
    
    // layout & show
    [self layoutSubviews];
	[self animationShowHelp];
}
- (void)dismissHelp {
    DLog();
    
    // dismiss
    [self animationDismissHelp];
}

/**
 * Next/previous step.
 */
- (void)nextHelp {
    DLog();
    
    // step
    step++;
    
    // update
    [self update];
    
    // layout & show
    [self layoutSubviews];
}
- (void)previousHelp {
    DLog();
    
    // step
    step--;
    
    // update
    [self update];
    
    // layout & show
    [self layoutSubviews];
}




#pragma mark -
#pragma mark Animations

/*
 * Animation help show.
 */
- (void)animationShowHelp {
	GLog();
    
    // flag
    if (! animating) {
        animating = YES;
        
        // prepare view
        self.alpha = 0.0f;
        
        // animate
        [UIView beginAnimations:@"help_show" context:nil];
        [UIView setAnimationDuration:kAnimateTimeHelpShow];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.alpha = 1.0;
        [UIView commitAnimations];
        
        // clean it up
        [self performSelector:@selector(animationShowHelpDone) withObject:nil afterDelay:kAnimateTimeHelpShow];
    }
    
	
}
- (void) animationShowHelpDone {
	GLog();
    
    // flag
    animating = NO;
}


/*
 * Animation dismiss help.
 */
- (void)animationDismissHelp {
	GLog();
    
    // flag
    if (! animating) {
        animating = YES;
        
        // animate
        [UIView beginAnimations:@"help_dismiss" context:nil];
        [UIView setAnimationDuration:kAnimateTimeHelpDismiss];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.alpha = 0.0f;
        [UIView commitAnimations];
        
        // clean it up
        [self performSelector:@selector(animationDismissHelpDone) withObject:nil afterDelay:kAnimateTimeHelpDismiss];
    }
	
}
- (void)animationDismissHelpDone {
	GLog();
    
    // flag
    animating = NO;
    
	// hide
	self.hidden = YES;
	
	// remove
	[self removeFromSuperview];
}



#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
	
	// release
	[_imageHelp release];
    
    [_labelWelcome release];
    [_textWelcome release];
    
    [_labelSearch release];
    [_textSearch release];
    
    [_labelNode1 release];
    [_textNode1 release];
    [_labelNode2 release];
    [_textNode2 release];
    [_labelNode3 release];
    [_textNode3 release];
    [_labelNode4 release];
    [_textNode4 release];
    
    [_labelApp1 release];
    [_textApp1 release];
    [_labelApp2 release];
    [_textApp2 release];
    [_labelApp3 release];
    [_textApp3 release];
    [_labelApp4 release];
    [_textApp4 release];
    
    [_pageControl release];
	
	// & done
	[super dealloc];
}

@end


/**
 * HelpLabel.
 */
@implementation HelpLabel 
    
/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
    GLog();
    
    // super
    if ((self = [super initWithFrame:frame])) {
        
        // style
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        self.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
        self.opaque = YES;
        self.numberOfLines =1;
        
    }
    return self;
}

@end


/**
 * HelpText.
 */
@implementation HelpText 

/*
 * Initialize.
 */
- (id)initWithFrame:(CGRect)frame {
    GLog();
    
    // super
    if ((self = [super initWithFrame:frame])) {
        
        // style
        self.contentInset = UIEdgeInsetsMake(0,-8,0,-8);
        self.textAlignment = UITextAlignmentLeft;
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        self.textColor = [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
        self.opaque = YES;
        self.userInteractionEnabled = NO;
        self.scrollEnabled = NO; 
        self.canCancelContentTouches = NO;
        self.editable = NO;
        
    }
    return self;
}


@end
