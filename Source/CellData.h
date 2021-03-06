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
#define kCellDataHeight  44.0f


/**
 * CellData.
 */
@interface CellData : UITableViewCell {
    
    // ui
    CacheImageView *_thumb;
    UIActivityIndicatorView *_loader;
    UIImageView *_icon;
    UIImageView *_more;
    
    // modes
    BOOL mode_thumb;
    BOOL mode_icon;
    BOOL mode_more;
}

// Business
- (void)reset;
- (void)update;
- (void)dataThumb:(UIImage*)thumb type:(NSString*)type;
- (void)loadThumb:(NSString*)thumb type:(NSString*)type;
- (void)dataIcon:(UIImage*)icon;
- (void)more;
- (void)loading;
- (void)disclosure;


@end