//
//  SearchResult.h
//  IMDG
//
//  Created by CNPP on 15.7.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Search;

@interface SearchResult : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) Search * search;

@end
