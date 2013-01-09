//
//  Favorite.h
//  Solyaris
//
//  Created by CNPP on 07.01.13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favorite : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * dbid;
@property (nonatomic, retain) NSString * meta;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) id thumb;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * link;

@end
