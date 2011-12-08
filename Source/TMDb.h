//
//  TMDb.h
//  Solyaris
//
//  Created by CNPP on 26.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
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
#import "Search.h"
#import "SearchResult.h"
#import "Movie.h"
#import "Person.h"
#import "Movie2Person.h"
#import "Asset.h"


/**
 * APIError.
 */
@interface APIError : NSObject {
    
}

// Properties
@property (nonatomic, retain) NSNumber *dataId;
@property (nonatomic, retain) NSString *dataType;
@property (nonatomic, retain) NSString *errorTitle;
@property (nonatomic, retain) NSString *errorMessage;

// Object
- (id)initError:(NSString*)type title:(NSString*)title message:(NSString*)message;

@end


/*
 * Delegate.
 */
@protocol APIDelegate <NSObject>
- (void)loadedSearch:(Search*)result;
- (void)loadedMovie:(Movie*)movie;
- (void)loadedPerson:(Person*)person;
- (void)apiGlitch:(APIError*)error;
- (void)apiError:(APIError*)error;
- (void)apiFatal:(NSString*)title message:(NSString*)msg;
@end

/**
 * API TMDb.
 */
@interface TMDb : NSObject {
    
    // delegate
	NSObject<APIDelegate> *delegate;
    
    // queue
    NSOperationQueue *queue;
    
    // core data
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
// Properties
@property (nonatomic, assign) NSObject <APIDelegate> *delegate;

// Business
- (void)reset;
- (void)searchMovie:(NSString*)q;
- (void)searchPerson:(NSString*)q;
- (void)movie:(NSNumber*)mid;
- (void)person:(NSNumber*)mid;
- (void)clearCache;
- (Movie*)dataMovie:(NSNumber*)mid;
- (Person*)dataPerson:(NSNumber*)pid;
- (NSArray*)dataMovies;


@end
