//
//  Actor.h
//  IMDG
//
//  Created by CNPP on 28.7.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MovieActor;

@interface Actor : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * loaded;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * aid;
@property (nonatomic, retain) NSSet* movies;

@end
