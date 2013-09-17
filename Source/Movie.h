//
//  Movie.h
//  Solyaris
//
//  Created by CNPP on 17.09.13.
//
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
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * overview;
@property (nonatomic, retain) NSString * homepage;
@property (nonatomic, retain) NSString * tagline;
@property (nonatomic, retain) NSNumber * related;
@property (nonatomic, retain) NSSet *asts;
@property (nonatomic, retain) Similar *similar;
@property (nonatomic, retain) NSSet *genres;
@property (nonatomic, retain) NSSet *persons;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addAstsObject:(Asset *)value;
- (void)removeAstsObject:(Asset *)value;
- (void)addAsts:(NSSet *)values;
- (void)removeAsts:(NSSet *)values;

- (void)addGenresObject:(Genre *)value;
- (void)removeGenresObject:(Genre *)value;
- (void)addGenres:(NSSet *)values;
- (void)removeGenres:(NSSet *)values;

- (void)addPersonsObject:(Movie2Person *)value;
- (void)removePersonsObject:(Movie2Person *)value;
- (void)addPersons:(NSSet *)values;
- (void)removePersons:(NSSet *)values;

@end
