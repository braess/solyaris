//
//  CellSearch.h
//  Solyaris
//
//  Created by Beat Raess on 3.5.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheImageView.h"


// Constants
#define kCellSearchHeight  44.0f


/**
 * CellSearch.
 */
@interface CellSearch : UITableViewCell {
    
    // ui
    UILabel *_labelData;
    CacheImageView *_thumbImageView;
    UIActivityIndicatorView *_loader;
    UIImageView *_disclosure;
    UIImageView *_more;
    
    // modes
    BOOL mode_thumb;
    BOOL mode_more;
}

// Properties
@property (nonatomic,retain) UILabel *labelData;

// Business
- (void)reset;
- (void)update;
- (void)loadThumb:(NSString*)thumb type:(NSString*)type;
- (void)more;
- (void)loading;
- (void)disclosure;


@end