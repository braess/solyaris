//
//  DataDelegate.h
//  Solyaris
//
//  Created by CNPP on 04.01.13.
//
//
#import <UIKit/UIKit.h>
#import "Search.h"
#import "Popular.h"
#import "NowPlaying.h"
#import "Movie.h"

@protocol DataDelegate <NSObject>
- (void)dataSearch:(Search*)search;
- (void)dataPopular:(Popular*)popular more:(BOOL)more;
- (void)dataNowPlaying:(NowPlaying*)nowplaying more:(BOOL)more;
- (void)dataHistory:(NSArray*)history type:(NSString*)type;
- (void)dataRelated:(Movie *)movie more:(BOOL)more;
@end
