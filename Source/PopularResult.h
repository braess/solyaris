//
//  PopularResult.h
//  Solyaris
//
//  Created by CNPP on 17.09.13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Popular;

@interface PopularResult : NSManagedObject

@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) NSString * thumb;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSNumber * ref;
@property (nonatomic, retain) Popular *popular;

@end
