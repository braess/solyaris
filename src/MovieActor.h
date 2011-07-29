//
//  MovieActor.h
//  IMDG
//
//  Created by CNPP on 29.7.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor, Movie;

@interface MovieActor : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSString * character;
@property (nonatomic, retain) NSNumber * aid;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) Actor * actor;
@property (nonatomic, retain) Movie * movie;

@end
