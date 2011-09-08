//
//  Search.m
//  IMDG
//
//  Created by CNPP on 8.9.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import "Search.h"
#import "SearchResult.h"


@implementation Search
@dynamic query;
@dynamic count;
@dynamic type;
@dynamic results;

- (void)addResultsObject:(SearchResult *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"results" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"results"] addObject:value];
    [self didChangeValueForKey:@"results" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeResultsObject:(SearchResult *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"results" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"results"] removeObject:value];
    [self didChangeValueForKey:@"results" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addResults:(NSSet *)value {    
    [self willChangeValueForKey:@"results" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"results"] unionSet:value];
    [self didChangeValueForKey:@"results" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeResults:(NSSet *)value {
    [self willChangeValueForKey:@"results" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"results"] minusSet:value];
    [self didChangeValueForKey:@"results" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
