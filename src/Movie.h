//
//  Movie.h
//  IMDG
//
//  Created by CNPP on 21.7.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MovieActor, MovieDirector;

@interface Movie : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSNumber * loaded;
@property (nonatomic, retain) NSSet* directors;
@property (nonatomic, retain) NSSet* actors;

@end
