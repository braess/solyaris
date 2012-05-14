//
//  Movie.h
//  Solyaris
//
//  Created by Beat Raess on 9.5.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Genre, Movie2Person;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSDate * released;
@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * details;
@property (nonatomic, retain) NSNumber * loaded;
@property (nonatomic, retain) NSString * imdb;
@property (nonatomic, retain) NSNumber * runtime;
@property (nonatomic, retain) NSString * overview;
@property (nonatomic, retain) NSString * homepage;
@property (nonatomic, retain) NSString * tagline;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSSet *assets;
@property (nonatomic, retain) NSSet *persons;
@property (nonatomic, retain) NSSet *genres;
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
- (void)addGenresObject:(Genre *)value;
- (void)removeGenresObject:(Genre *)value;
- (void)addGenres:(NSSet *)values;
- (void)removeGenres:(NSSet *)values;
@end
