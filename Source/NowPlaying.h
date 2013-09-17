//
//  NowPlaying.h
//  Solyaris
//
//  Created by CNPP on 17.09.13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NowPlayingResult;

@interface NowPlaying : NSManagedObject

@property (nonatomic, retain) NSNumber * parsed;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * ident;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) NSSet *results;
@end

@interface NowPlaying (CoreDataGeneratedAccessors)

- (void)addResultsObject:(NowPlayingResult *)value;
- (void)removeResultsObject:(NowPlayingResult *)value;
- (void)addResults:(NSSet *)values;
- (void)removeResults:(NSSet *)values;

@end
