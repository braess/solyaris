//
//  Director.h
//  IMDG
//
//  Created by CNPP on 21.7.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MovieDirector;

@interface Director : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * did;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * loaded;
@property (nonatomic, retain) NSSet* movies;

@end
