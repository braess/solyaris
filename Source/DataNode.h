//
//  DataNode.h
//  Solyaris
//
//  Created by CNPP on 9.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
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

#import <Foundation/Foundation.h>
#import "DataEdge.h"


/**
 * DataNode.
 */
@interface DataNode : NSObject {
    
}

// Properties
@property (nonatomic, retain) NSNumber *nid;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *meta;
@property (nonatomic, retain) NSString *thumb;
@property (nonatomic, retain) DataEdge *edge;
@property bool visible;
@property bool loaded;

// Object
- (id)initData:(NSNumber*)n type:(NSString*)t label:(NSString*)l meta:(NSString*)m thumb:(NSString*)tmb edge:(DataEdge*)e visible:(bool)iv loaded:(bool)il;

@end
