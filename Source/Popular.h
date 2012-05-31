//
//  Popular.h
//  Solyaris
//
//  Created by Beat Raess on 30.5.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PopularResult;

@interface Popular : NSManagedObject

@property (nonatomic, retain) NSString * ident;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) NSSet *results;
@end

@interface Popular (CoreDataGeneratedAccessors)

- (void)addResultsObject:(PopularResult *)value;
- (void)removeResultsObject:(PopularResult *)value;
- (void)addResults:(NSSet *)values;
- (void)removeResults:(NSSet *)values;
@end
