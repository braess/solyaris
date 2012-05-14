//
//  DataCounter.h
//  Solyaris
//
//  Created by Beat Raess on 9.5.2012.
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
 * DataCounter.
 */
@interface DataCounter: NSObject {
    
}

// Object
- (id)initCounter:(NSString*)nm count:(int)cnt sort:(int)srt;

// Properties
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, retain) NSNumber *sort;

@end
