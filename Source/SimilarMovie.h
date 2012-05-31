//
//  SimilarMovie.h
//  Solyaris
//
//  Created by Beat Raess on 30.5.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Similar;

@interface SimilarMovie : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSString * thumb;
@property (nonatomic, retain) Similar *similar;

@end
