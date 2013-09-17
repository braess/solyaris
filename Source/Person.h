//
//  Person.h
//  Solyaris
//
//  Created by CNPP on 17.09.13.
//
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
@property (nonatomic, retain) NSSet *asts;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(Movie2Person *)value;
- (void)removeMoviesObject:(Movie2Person *)value;
- (void)addMovies:(NSSet *)values;
- (void)removeMovies:(NSSet *)values;

- (void)addAstsObject:(Asset *)value;
- (void)removeAstsObject:(Asset *)value;
- (void)addAsts:(NSSet *)values;
- (void)removeAsts:(NSSet *)values;

@end
