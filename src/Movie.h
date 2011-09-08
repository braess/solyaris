//
//  Movie.h
//  IMDG
//
//  Created by CNPP on 8.9.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Movie2Person;

@interface Movie : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * released;
@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSString * trailer;
@property (nonatomic, retain) NSNumber * loaded;
@property (nonatomic, retain) NSNumber * runtime;
@property (nonatomic, retain) NSString * overview;
@property (nonatomic, retain) NSString * homepage;
@property (nonatomic, retain) NSString * tagline;
@property (nonatomic, retain) NSString * imdb_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* assets;
@property (nonatomic, retain) NSSet* persons;

@end
