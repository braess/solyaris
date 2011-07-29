//
//  Search.m
//  IMDG
//
//  Created by CNPP on 29.7.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import "Search.h"
#import "SearchResult.h"


@implementation Search
@dynamic query;
@dynamic type;
@dynamic data;

- (void)addDataObject:(SearchResult *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"data" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"data"] addObject:value];
    [self didChangeValueForKey:@"data" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeDataObject:(SearchResult *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"data" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"data"] removeObject:value];
    [self didChangeValueForKey:@"data" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addData:(NSSet *)value {    
    [self willChangeValueForKey:@"data" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"data"] unionSet:value];
    [self didChangeValueForKey:@"data" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeData:(NSSet *)value {
    [self willChangeValueForKey:@"data" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"data"] minusSet:value];
    [self didChangeValueForKey:@"data" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
