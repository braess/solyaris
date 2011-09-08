//
//  Person.h
//  IMDG
//
//  Created by CNPP on 8.9.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Movie2Person;

@interface Person : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * known_movies;
@property (nonatomic, retain) NSNumber * loaded;
@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * biography;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * birthplace;
@property (nonatomic, retain) NSSet* assets;
@property (nonatomic, retain) NSSet* movies;

@end
