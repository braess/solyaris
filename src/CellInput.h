//
//  CellInput.h
//  IMDG
//
//  Created by CNPP on 6.8.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
* Abstract CellInput.
*/
@interface CellInput : UITableViewCell {

	// data
	NSString *key;
    NSString *help;
    
    // data
    @protected

}

// Properties
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *help;

// Business
- (void)update:(BOOL)reset;

@end
