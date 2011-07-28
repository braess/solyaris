//
//  InformationViewController.h
//  IMDG
//
//  Created by CNPP on 28.7.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>



//  Sections
enum {
    SectionInformationDirectors,
	SectionInformationActors,
	SectionInformationMovies
};


/**
 * Information.
 */
@interface Information : NSObject {
    
}

// Properties
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *meta;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSNumber *nid;

// Initializer
- (id)initWithValue:(NSString*)v meta:(NSString*)m type:(NSString*)t nid:(NSNumber*)n;

@end


/*
 * Info Delegate.
 */
@protocol InformationViewDelegate <NSObject>
- (void)informationDismiss;
@end


/**
 * InformationViewController.
 */
@interface InformationViewController : UITableViewController {
    
    // delegate
	id<InformationViewDelegate> delegate;
    
    // data
	NSMutableArray *_movies;
	NSMutableArray *_actors;
	NSMutableArray *_directors;
    
    // private
    @private
    int _sectionGapHeight;
    int _sectionGapInset;
    int _sectionGapOffset;
    
}

// Properties
@property (assign) id<InformationViewDelegate> delegate;
@property (nonatomic, assign) NSMutableArray* movies;
@property (nonatomic, assign) NSMutableArray* actors;
@property (nonatomic, assign) NSMutableArray* directors;

// Action Methods
- (void)actionDone:(id)sender;

@end
