//
//  SimilarMovie.h
//  Solyaris
//
//  Created by CNPP on 17.09.13.
//
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
