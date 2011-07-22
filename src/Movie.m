//
//  Movie.m
//  IMDG
//
//  Created by CNPP on 21.7.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import "Movie.h"
#import "MovieActor.h"
#import "MovieDirector.h"


@implementation Movie
@dynamic mid;
@dynamic title;
@dynamic year;
@dynamic loaded;
@dynamic directors;
@dynamic actors;

- (void)addDirectorsObject:(MovieDirector *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"directors" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"directors"] addObject:value];
    [self didChangeValueForKey:@"directors" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeDirectorsObject:(MovieDirector *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"directors" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"directors"] removeObject:value];
    [self didChangeValueForKey:@"directors" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addDirectors:(NSSet *)value {    
    [self willChangeValueForKey:@"directors" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"directors"] unionSet:value];
    [self didChangeValueForKey:@"directors" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeDirectors:(NSSet *)value {
    [self willChangeValueForKey:@"directors" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"directors"] minusSet:value];
    [self didChangeValueForKey:@"directors" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addActorsObject:(MovieActor *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"actors" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"actors"] addObject:value];
    [self didChangeValueForKey:@"actors" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeActorsObject:(MovieActor *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"actors" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"actors"] removeObject:value];
    [self didChangeValueForKey:@"actors" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addActors:(NSSet *)value {    
    [self willChangeValueForKey:@"actors" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"actors"] unionSet:value];
    [self didChangeValueForKey:@"actors" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeActors:(NSSet *)value {
    [self willChangeValueForKey:@"actors" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"actors"] minusSet:value];
    [self didChangeValueForKey:@"actors" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
