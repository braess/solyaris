//
//  Movie.m
//  IMDG
//
//  Created by CNPP on 8.9.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import "Movie.h"
#import "Asset.h"
#import "Movie2Person.h"


@implementation Movie
@dynamic released;
@dynamic mid;
@dynamic trailer;
@dynamic loaded;
@dynamic runtime;
@dynamic overview;
@dynamic homepage;
@dynamic tagline;
@dynamic imdb_id;
@dynamic name;
@dynamic assets;
@dynamic persons;

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


- (void)addPersonsObject:(Movie2Person *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"persons" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"persons"] addObject:value];
    [self didChangeValueForKey:@"persons" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePersonsObject:(Movie2Person *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"persons" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"persons"] removeObject:value];
    [self didChangeValueForKey:@"persons" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPersons:(NSSet *)value {    
    [self willChangeValueForKey:@"persons" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"persons"] unionSet:value];
    [self didChangeValueForKey:@"persons" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePersons:(NSSet *)value {
    [self willChangeValueForKey:@"persons" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"persons"] minusSet:value];
    [self didChangeValueForKey:@"persons" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
