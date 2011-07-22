//
//  Actor.m
//  IMDG
//
//  Created by CNPP on 21.7.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import "Actor.h"
#import "MovieActor.h"


@implementation Actor
@dynamic loaded;
@dynamic aid;
@dynamic name;
@dynamic movies;

- (void)addMoviesObject:(MovieActor *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"movies" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"movies"] addObject:value];
    [self didChangeValueForKey:@"movies" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeMoviesObject:(MovieActor *)value {
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
