//
//  SearchResult.h
//  Solyaris
//
//  Created by Beat Raess on 1.6.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Search;

@interface SearchResult : NSManagedObject

@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) NSString * thumb;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * ref;
@property (nonatomic, retain) Search *search;

@end
