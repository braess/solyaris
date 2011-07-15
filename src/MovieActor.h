//
//  MovieActor.h
//  IMDG
//
//  Created by CNPP on 15.7.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor, Movie;

@interface MovieActor : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * character;
@property (nonatomic, retain) Movie * movie;
@property (nonatomic, retain) Actor * actor;

@end
