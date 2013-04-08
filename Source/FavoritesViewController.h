//
//  FavoritesViewController.h
//  Solyaris
//
//  Created by CNPP on 04.01.13.
//
//

#import <UIKit/UIKit.h>
#import "SolyarisDataManager.h"
#import "Appearance.h"
#import "ExportDelegate.h"
#import "HeaderView.h"


/*
 * Delegate.
 */
@protocol FavoritesDelegate <NSObject>
- (void)favoriteSelected:(Favorite*)favorite;
@optional;
- (void)favoritesDismiss;
@end

// Alerts
enum {
    AlertFavoritesNone
};


/**
 * FavoritesViewController.
 */
@interface FavoritesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, HeaderDelegate, ExportDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate> {
    
    // delegate
	id<FavoritesDelegate>delegate;
    
    // data manager
    SolyarisDataManager *_solyarisDataManager;
    
    // fetch
    NSString *type__;
    NSFetchedResultsController *fetched_favorites__;
    
    // private
    @private
    
    // ui
    HeaderView *_header;
    UITableView *_favorites;
    
    // mode
    BOOL mode_editing;
    
}

// Properties
@property (assign) id<FavoritesDelegate> delegate;
@property (nonatomic, retain) NSFetchedResultsController *fetched_favorites;
@property (nonatomic, retain) NSString *type;
@property (nonatomic,retain) HeaderView* header;

// Business
- (void)update;

@end
