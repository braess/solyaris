//
//  Search.h
//  Solyaris
//
//  Created by Beat Raess on 1.6.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SearchResult;

@interface Search : NSManagedObject

@property (nonatomic, retain) NSString * query;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *results;
@end

@interface Search (CoreDataGeneratedAccessors)

- (void)addResultsObject:(SearchResult *)value;
- (void)removeResultsObject:(SearchResult *)value;
- (void)addResults:(NSSet *)values;
- (void)removeResults:(NSSet *)values;
@end
