//
//  Movie.h
//  Solyaris
//
//  Created by Beat Raess on 1.6.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Genre, Movie2Person, Similar;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSDate * released;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * loaded;
@property (nonatomic, retain) NSNumber * details;
@property (nonatomic, retain) NSString * imdb;
@property (nonatomic, retain) NSNumber * runtime;
@property (nonatomic, retain) NSString * overview;
@property (nonatomic, retain) NSString * homepage;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * tagline;
@property (nonatomic, retain) NSNumber * related;
@property (nonatomic, retain) NSSet *assets;
@property (nonatomic, retain) Similar *similar;
@property (nonatomic, retain) NSSet *genres;
@property (nonatomic, retain) NSSet *persons;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet *)values;
- (void)removeAssets:(NSSet *)values;
- (void)addGenresObject:(Genre *)value;
- (void)removeGenresObject:(Genre *)value;
- (void)addGenres:(NSSet *)values;
- (void)removeGenres:(NSSet *)values;
- (void)addPersonsObject:(Movie2Person *)value;
- (void)removePersonsObject:(Movie2Person *)value;
- (void)addPersons:(NSSet *)values;
- (void)removePersons:(NSSet *)values;
@end
