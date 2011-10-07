//
//  DataNode.h
//  Solyaris
//
//  Created by CNPP on 9.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//
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
@property (nonatomic, retain) DataEdge *edge;
@property bool visible;
@property bool loaded;

// Object
- (id)initData:(NSNumber*)n type:(NSString*)t label:(NSString*)l meta:(NSString*)m edge:(DataEdge*)e visible:(bool)iv loaded:(bool)il;

@end
