//
//  SegmentedControl.m
//  Solyaris
//
//  Created by Beat Raess on 27.4.2012.
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

#import "SegmentedControl.h"



#pragma mark -
#pragma mark SegmentedControl
#pragma mark -

/*
 * Helper Stack.
 */
@interface SegmentedControl (Helpers)
- (void)buttonTouchUpInside:(UIButton*)b;
- (void)buttonTouchDown:(UIButton*)b;
- (void)buttonTouchOther:(UIButton*)b;
- (void)selectButton:(UIButton*)b;
@end


/**
 * Custom SegmentedControl.
 */
@implementation SegmentedControl


#pragma mark -
#pragma mark Properties

// accessors
@synthesize delegate;


#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initWithTitles:(NSArray*)titles {
    return [self initWithTitles:titles size:CGSizeMake(116, 32) gap:1 cap:10 image:@"segment.png" selected:@"segment_selected.png" divider:@"segment_divider.png"];
}
- (id)initWithTitles:(NSArray*)titles size:(CGSize)size gap:(int)gap cap:(int)cap image:(NSString*)image selected:(NSString*)selected divider:(NSString*)divider {
    GLog();
    
    // super
    if ((self = [super init])) {
        
        // self
        self.frame = CGRectMake(0, 0, (size.width * titles.count) + (gap * (titles.count - 1)), size.height);
        
        // buttons
        NSMutableArray *btns = [[NSMutableArray alloc] init];
        _buttons = [btns retain];
        [btns release];
        
        // init segments
        CGFloat offset = 0;
        for (NSUInteger i = 0 ; i < [titles count] ; i++) {
            
            // cap
            SegmentCapLocation capLocation = SegmentCapMiddle;
            if (i == 0) {
                capLocation = SegmentCapLeft;
            }
            else if (i == titles.count - 1) {
                capLocation = SegmentCapRight;
            }
            
            // create segment
            UIButton* button = [[SegmentedControlItem alloc] initSegmentedControlItem:size capLocation:capLocation capWidth:cap title:[titles objectAtIndex:i] image:image selected:selected];
            
            // events
            [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(buttonTouchOther:) forControlEvents:UIControlEventTouchUpOutside];
            [button addTarget:self action:@selector(buttonTouchOther:) forControlEvents:UIControlEventTouchDragOutside];
            [button addTarget:self action:@selector(buttonTouchOther:) forControlEvents:UIControlEventTouchDragInside];
            
            // add
            [_buttons addObject:button];
            
            
            // frame
            button.frame = CGRectMake(offset, 0.0, button.frame.size.width, button.frame.size.height);
            
            // subview
            [self addSubview:button];
            [button release];
            
            // divider
            if (i != titles.count - 1) {
                UIImageView* div = [[UIImageView alloc] initWithImage:[UIImage imageNamed:divider]];
                div.frame = CGRectMake(offset + size.width, 0.0, gap, size.height);
                div.backgroundColor = [UIColor clearColor];
                div.contentMode = UIViewContentModeTopLeft;
                [self addSubview:div];
                [div release];
            }
            
            // offset
            offset += (size.width + gap);
        }
    }
    return self;
}


#pragma mark -
#pragma mark Business

/**
 * Select.
 */
- (void)select:(int)ndx {
    FLog();
    [self selectButton:[_buttons objectAtIndex:ndx]];
}

/**
 * Returns the segment buttons for customisation.
 */
- (NSArray*)segmentButtons {
    return _buttons;
}

#pragma mark -
#pragma mark Helpers


/*
 * Selects a button.
 */
- (void)selectButton:(UIButton *)b {
    GLog();
    
    // select
    for (UIButton* button in _buttons) {
        
        // select
        if (button == b) {
            button.selected = YES;
            button.highlighted = button.selected ? NO : YES;
        }
        // deselect
        else {
            button.selected = NO;
            button.highlighted = NO;
        }
    }
}

/*
 * Touch down.
 */
- (void)buttonTouchDown:(UIButton*)button {
    GLog();
    
    // select
    [self selectButton:button];
    
    // delegate
    if ([delegate respondsToSelector:@selector(segmentedControlDown:)]) {
        [delegate segmentedControlDown:[_buttons indexOfObject:button]];
    }
}

/*
 * Touch up.
 */
- (void)buttonTouchUpInside:(UIButton*)button {
    GLog();
    
    // select
    [self selectButton:button];
    
    // delegate
    if ([delegate respondsToSelector:@selector(segmentedControlTouched:)]) {
        [delegate segmentedControlTouched:[_buttons indexOfObject:button]];
    }
}

/*
 * Touch other.
 */
- (void)buttonTouchOther:(UIButton*)button {
    GLog();
    
    // select
    [self selectButton:button];
}



#pragma mark -
#pragma mark Memory Management


/*
 * Deallocates all used memory.
 */
- (void)dealloc {	
	GLog();
	
	// release
	[_buttons release];
	
	// done
	[super dealloc];
}

@end





/*
 * Helper Stack.
 */
@interface SegmentedControlItem (Helpers)
-(UIImage*)image:(UIImage*)image withCap:(SegmentCapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth;
@end

/**
 * SegmentedControlItem.
 */
@implementation SegmentedControlItem


#pragma mark -
#pragma mark Object Methods

/*
 * Initialize.
 */
- (id)initSegmentedControlItem:(CGSize)size capLocation:(SegmentCapLocation)capLocation capWidth:(NSUInteger)capWidth title:(NSString*)title image:(NSString*)image selected:(NSString*)selected {
    GLog();
    
    // init
    if ((self = [super init])) {
        
        // self
        self.frame = CGRectMake(0.0, 0.0, size.width, size.height);
        
        // image
        UIImage* buttonImage = nil;
        UIImage* buttonSelectedImage = nil;
        if (capLocation == SegmentCapLeftAndRight) {
            buttonImage = [[UIImage imageNamed:image] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
            buttonSelectedImage = [[UIImage imageNamed:selected] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
        }
        else {
            buttonImage = [self image:[[UIImage imageNamed:image] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0] withCap:capLocation capWidth:capWidth buttonWidth:size.width];
            buttonSelectedImage = [self image:[[UIImage imageNamed:selected] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0] withCap:capLocation capWidth:capWidth buttonWidth:size.width];
        }
        
        // background
        [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [self setBackgroundImage:buttonSelectedImage forState:UIControlStateHighlighted];
        [self setBackgroundImage:buttonSelectedImage forState:UIControlStateSelected];
        self.adjustsImageWhenHighlighted = NO;
        
        
        // title
        [self setTitle:title forState:UIControlStateNormal];
        
        // fonts
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [self setTitleColor:[UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] forState:UIControlStateSelected];
        
        self.titleLabel.shadowOffset = CGSizeMake(1,1);
        [self setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
        [self setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateSelected];
        

    }
    return self;

}

/*
 * Layout.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // adjust label
    CGRect tFrame = self.titleLabel.frame;
    tFrame.origin.y += 1;
    self.titleLabel.frame = tFrame;
}

                           
#pragma mark -
#pragma mark Helpers
                           
/*
 * Generates a custom image.
 */
-(UIImage*)image:(UIImage*)image withCap:(SegmentCapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth {
    
    // create image
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, image.size.height), NO, 0.0);
                
    if (location == SegmentCapLeft) {
        // To draw the left cap and not the right, we start at 0, and increase the width of the image by the cap width to push the right cap out of view
        [image drawInRect:CGRectMake(0, 0, buttonWidth + capWidth, image.size.height)];
    }
    else if (location == SegmentCapRight) {
        // To draw the right cap and not the left, we start at negative the cap width and increase the width of the image by the cap width to push the left cap out of view
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + capWidth, image.size.height)];
    }
    else if (location == SegmentCapMiddle) {
        // To draw neither cap, we start at negative the cap width and increase the width of the image by both cap widths to push out both caps out of view
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + (capWidth * 2), image.size.height)];
    }

    
    // result
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // return
    return resultImage;
}
@end
