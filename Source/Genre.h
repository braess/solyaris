//
//  Genre.h
//  Solyaris
//
//  Created by CNPP on 17.09.13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

@interface Genre : NSManagedObject

@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *movies;
@end

@interface Genre (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(Movie *)value;
- (void)removeMoviesObject:(Movie *)value;
- (void)addMovies:(NSSet *)values;
- (void)removeMovies:(NSSet *)values;

@end
