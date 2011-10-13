//
//  Asset.h
//  Solyaris
//
//  Created by Beat Raess on 13.10.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie, Person;

@interface Asset : NSManagedObject

@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) Movie *movie;
@property (nonatomic, retain) Person *person;

@end
