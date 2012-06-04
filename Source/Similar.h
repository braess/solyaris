//
//  Similar.h
//  Solyaris
//
//  Created by Beat Raess on 1.6.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie, SimilarMovie;

@interface Similar : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) NSNumber * parsed;
@property (nonatomic, retain) Movie *movie;
@property (nonatomic, retain) NSSet *movies;
@end

@interface Similar (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(SimilarMovie *)value;
- (void)removeMoviesObject:(SimilarMovie *)value;
- (void)addMovies:(NSSet *)values;
- (void)removeMovies:(NSSet *)values;
@end
