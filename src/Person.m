//
//  Person.m
//  IMDG
//
//  Created by CNPP on 31.8.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import "Person.h"
#import "Asset.h"
#import "Movie2Person.h"


@implementation Person
@dynamic known_movies;
@dynamic loaded;
@dynamic pid;
@dynamic birthday;
@dynamic type;
@dynamic biography;
@dynamic birthplace;
@dynamic name;
@dynamic assets;
@dynamic movies;

- (void)addAssetsObject:(Asset *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"assets" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"assets"] addObject:value];
    [self didChangeValueForKey:@"assets" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAssetsObject:(Asset *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"assets" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"assets"] removeObject:value];
    [self didChangeValueForKey:@"assets" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAssets:(NSSet *)value {    
    [self willChangeValueForKey:@"assets" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"assets"] unionSet:value];
    [self didChangeValueForKey:@"assets" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAssets:(NSSet *)value {
    [self willChangeValueForKey:@"assets" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"assets"] minusSet:value];
    [self didChangeValueForKey:@"assets" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addMoviesObject:(Movie2Person *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"movies" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"movies"] addObject:value];
    [self didChangeValueForKey:@"movies" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeMoviesObject:(Movie2Person *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"movies" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"movies"] removeObject:value];
    [self didChangeValueForKey:@"movies" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addMovies:(NSSet *)value {    
    [self willChangeValueForKey:@"movies" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"movies"] unionSet:value];
    [self didChangeValueForKey:@"movies" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeMovies:(NSSet *)value {
    [self willChangeValueForKey:@"movies" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"movies"] minusSet:value];
    [self didChangeValueForKey:@"movies" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
