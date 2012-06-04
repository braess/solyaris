//
//  Movie2Person.h
//  Solyaris
//
//  Created by Beat Raess on 1.6.2012.
//  Copyright (c) 2012 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie, Person;

@interface Movie2Person : NSManagedObject

@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * character;
@property (nonatomic, retain) NSDate * year;
@property (nonatomic, retain) NSString * job;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) Person *person;
@property (nonatomic, retain) Movie *movie;

@end
