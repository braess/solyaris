//
//  SolyarisDataManager.h
//  Solyaris
//
//  Created by CNPP on 03.01.13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Favorite.h"

// Alerts
enum {
	AlertDataError
};

// favorite
#define kFav        @"favorite"
#define kFavType    @"favorite_type"
#define kFavDBID    @"favorite_dbid"
#define kFavTitle   @"favorite_title"
#define kFavMeta    @"favorite_meta"
#define kFavThumb   @"favorite_thumb"
#define kFavLink    @"favorite_link"

/**
 * SolyarisDataManager.
 */
@interface SolyarisDataManager : NSObject <UIAlertViewDelegate> {
    
    // core data
	NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    
}

// Properties
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

// Setup
- (void)setup;
- (void)reset;

// Manager
- (void)managerFavoriteAdd:(NSDictionary*)fav;
- (void)managerFavoriteRemove:(NSDictionary*)fav;
- (NSString*)managerExportFavorites:(NSString*)type;

// Core Data
- (void)save;
- (void)cdTransactionBegin:(NSString*)trx;
- (void)cdTransactionEnd:(NSString*)trx persist:(BOOL)persist;
- (void)cdObjectDelete:(NSManagedObject*)object;

// Objects
- (Favorite*)solyarisObjectFavorite:(NSString*)type;

// Data
- (NSMutableArray*)solyarisDataFavorites:(NSString*)type;
- (Favorite*)solyarisDataFavorite:(NSString*)type dbid:(NSNumber*)dbid;

@end
