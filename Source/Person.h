//
//  Person.h
//  Solyaris
//
//  Created by Beat Raess on 9.5.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Movie2Person;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * loaded;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * biography;
@property (nonatomic, retain) NSNumber * casts;
@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) NSDate * deathday;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * birthplace;
@property (nonatomic, retain) NSSet *movies;
@property (nonatomic, retain) NSSet *assets;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(Movie2Person *)value;
- (void)removeMoviesObject:(Movie2Person *)value;
- (void)addMovies:(NSSet *)values;
- (void)removeMovies:(NSSet *)values;
- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet *)values;
- (void)removeAssets:(NSSet *)values;
@end
