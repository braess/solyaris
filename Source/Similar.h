//
//  Similar.h
//  Solyaris
//
//  Created by CNPP on 17.09.13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie, SimilarMovie;

@interface Similar : NSManagedObject

@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSNumber * parsed;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) Movie *movie;
@property (nonatomic, retain) NSSet *movies;
@end

@interface Similar (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(SimilarMovie *)value;
- (void)removeMoviesObject:(SimilarMovie *)value;
- (void)addMovies:(NSSet *)values;
- (void)removeMovies:(NSSet *)values;

@end
