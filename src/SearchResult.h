//
//  SearchResult.h
//  IMDG
//
//  Created by CNPP on 31.8.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Search;

@interface SearchResult : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * ref;
@property (nonatomic, retain) NSString * thumb;
@property (nonatomic, retain) Search * search;

@end
