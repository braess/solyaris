//
//  Popular.h
//  Solyaris
//
//  Created by CNPP on 17.09.13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PopularResult;

@interface Popular : NSManagedObject

@property (nonatomic, retain) NSNumber * parsed;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * ident;
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
