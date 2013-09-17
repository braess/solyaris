//
//  SearchResult.h
//  Solyaris
//
//  Created by CNPP on 17.09.13.
//
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
