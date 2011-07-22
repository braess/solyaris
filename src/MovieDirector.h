//
//  MovieDirector.h
//  IMDG
//
//  Created by CNPP on 21.7.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Director, Movie;

@interface MovieDirector : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * addition;
@property (nonatomic, retain) Movie * movie;
@property (nonatomic, retain) Director * director;

@end
