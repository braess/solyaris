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

//  Tags
enum {
    TagInformationHeader,
	TagInformationContent,
	TagInformationFooter
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
@property bool visible;
@property bool loaded;

// Initializer
- (id)initWithValue:(NSString*)v meta:(NSString*)m type:(NSString*)t nid:(NSNumber*)n visible:(bool)iv loaded:(bool)il;

@end


/*
 * Info Delegate.
 */
@protocol InformationViewDelegate <NSObject>
- (void)informationDismiss;
- (void)informationSelected:(NSNumber*)nid type:(NSString*)type;
@end


/**
 * InformationViewController.
 */
@interface InformationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    // delegate
	id<InformationViewDelegate> delegate;
    
    // ui
    UILabel *_labelTitle;
    UITableView *_tableView;
    
    // data
	NSMutableArray *_movies;
	NSMutableArray *_actors;
	NSMutableArray *_directors;
    
}

// Properties
@property (assign) id<InformationViewDelegate> delegate;
@property (nonatomic, assign) NSMutableArray* movies;
@property (nonatomic, assign) NSMutableArray* actors;
@property (nonatomic, assign) NSMutableArray* directors;

// Object Methods
- (id)initWithFrame:(CGRect)frame;

// Business Methods
- (void)informationTitle:(NSString*)title;

@end



/**
 * InformationBackgroundView.
 */
@interface InformationBackgroundView : UIView {
}
@end


/**
 * InformationCell.
 */
@interface InformationCell : UITableViewCell {
    
    // ui
    UILabel *labelInfo;
    UILabel *labelMeta;
    UIImageView *_iconLoaded;
    UIImageView *_iconVisible;
    
    // state
    bool loaded;

}

// Properties
@property (nonatomic,retain) UILabel *labelInfo;
@property (nonatomic,retain) UILabel *labelMeta;
@property bool loaded;
@property bool visible;

@end
