//
//  Search.h
//  IMDG
//
//  Created by CNPP on 8.7.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SearchResult;

@interface Search : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * query;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet* data;
- (void)addDataObject:(SearchResult *)value;

@end
