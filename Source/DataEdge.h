//
//  DataEdge.h
//  Solyaris
//
//  Created by CNPP on 30.9.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * DataEdge.
 */
@interface DataEdge : NSObject {
    
}

// Properties
@property (nonatomic, retain) NSString *eid;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *label;

// Object
- (id)initData:(NSString*)e type:(NSString*)t label:(NSString*)l;

@end
