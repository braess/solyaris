//
//  MovieDirector.h
//  IMDG
//
//  Created by CNPP on 28.7.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Director, Movie;

@interface MovieDirector : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * addition;
@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSNumber * did;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) Movie * movie;
@property (nonatomic, retain) Director * director;

@end
