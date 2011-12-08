//
//  Movie2Person.h
//  Solyaris
//
//  Created by Beat Raess on 13.10.2011.
//  Copyright (c) 2011 Beat Raess. All rights reserved.
//
//  This file is part of Solyaris.
//  
//  Solyaris is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  Solyaris is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with Solyaris.  If not, see www.gnu.org/licenses/.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie, Person;

@interface Movie2Person : NSManagedObject

@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * character;
@property (nonatomic, retain) NSDate * year;
@property (nonatomic, retain) NSString * job;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) Person *person;
@property (nonatomic, retain) Movie *movie;

@end
