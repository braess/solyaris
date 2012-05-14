//
//  DBData.h
//  Solyaris
//
//  Created by Beat Raess on 7.5.2012.
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

#import <UIKit/UIKit.h>


/**
 * DBData.
 */
@interface DBData : NSObject {
    
}

// Object
- (id)initData:(NSNumber *)dta_ref type:(NSString *)dta_type label:(NSString *)dta_label thumb:(NSString *)dta_thumb;

// Properties
@property (nonatomic, retain) NSNumber *ref;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *thumb;
@property (nonatomic, retain) NSNumber *sort;
@property BOOL more;

@end
