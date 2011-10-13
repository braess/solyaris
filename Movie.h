//
//  Movie.h
//  Solyaris
//
//  Created by Beat Raess on 13.10.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Movie2Person;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSDate * released;
@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSString * trailer;
@property (nonatomic, retain) NSNumber * loaded;
@property (nonatomic, retain) NSNumber * runtime;
@property (nonatomic, retain) NSString * overview;
@property (nonatomic, retain) NSString * homepage;
@property (nonatomic, retain) NSString * tagline;
@property (nonatomic, retain) NSString * imdb_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *assets;
@property (nonatomic, retain) NSSet *persons;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet *)values;
- (void)removeAssets:(NSSet *)values;
- (void)addPersonsObject:(Movie2Person *)value;
- (void)removePersonsObject:(Movie2Person *)value;
- (void)addPersons:(NSSet *)values;
- (void)removePersons:(NSSet *)values;
@end
