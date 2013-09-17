//
//  NowPlayingResult.h
//  Solyaris
//
//  Created by CNPP on 17.09.13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NowPlaying;

@interface NowPlayingResult : NSManagedObject

@property (nonatomic, retain) NSNumber * ref;
@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) NSString * thumb;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NowPlaying *nowplaying;

@end
