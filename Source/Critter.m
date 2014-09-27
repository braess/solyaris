//
//  Critter.m
//  Solyaris
//
//  Created by Beat Raess on 27/09/14.
//
//

#import "Critter.h"
#import "Crittercism/Crittercism.h"

/**
 * Critter.
 */
@implementation Critter

#pragma mark -
#pragma mark Class

/**
 * Setup.
 */
+ (void)setup {
    
    #ifdef DEBUG
    NSLog(@"Critter: Setup");
    #else
    @try {
        
        // init
        [Crittercism enableWithAppID:kCrittercismAppID];
        
    }
    @catch (id exception) {
    }
    #endif
}

@end
