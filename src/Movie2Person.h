//
//  Movie2Person.h
//  IMDG
//
//  Created by CNPP on 31.8.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie, Person;

@interface Movie2Person : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * character;
@property (nonatomic, retain) NSDate * year;
@property (nonatomic, retain) NSString * job;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) Person * person;
@property (nonatomic, retain) Movie * movie;

@end
