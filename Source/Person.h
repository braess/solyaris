//
//  Person.h
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

@class Asset, Movie2Person;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSNumber * known_movies;
@property (nonatomic, retain) NSNumber * loaded;
@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * biography;
@property (nonatomic, retain) NSString * birthplace;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *assets;
@property (nonatomic, retain) NSSet *movies;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet *)values;
- (void)removeAssets:(NSSet *)values;
- (void)addMoviesObject:(Movie2Person *)value;
- (void)removeMoviesObject:(Movie2Person *)value;
- (void)addMovies:(NSSet *)values;
- (void)removeMovies:(NSSet *)values;
@end
