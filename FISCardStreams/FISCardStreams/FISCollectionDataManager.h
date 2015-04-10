//
//  FISCollectionDataManager.h
//  FISCardStreams
//
//  Created by Mark Murray on 4/10/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FISStream;

@interface FISCollectionDataManager : NSObject

@property (strong, nonatomic) NSArray *allStreams;

+ (instancetype)sharedDataManager;

- (void)getAllStreamsWithCompletionBlock:(void (^)(NSArray *allStreams, BOOL success))completionBlock;

- (void)getShowcaseCardsForStream:(FISStream *)stream completionBlock:(void (^)(NSArray *showcaseCards))completionBlock;

@end
