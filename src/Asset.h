//
//  Asset.h
//  IMDG
//
//  Created by CNPP on 31.8.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie, Person;

@interface Asset : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Movie * movie;
@property (nonatomic, retain) Person * person;

@end
