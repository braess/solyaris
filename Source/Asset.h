//
//  Asset.h
//  Solyaris
//
//  Created by CNPP on 17.09.13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie, Person;

@interface Asset : NSManagedObject

@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Person *person;
@property (nonatomic, retain) Movie *movie;

@end
