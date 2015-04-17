//
//  FISCollectionDataManager.h
//  FISCardStreams
//
//  Created by Mark Murray on 4/10/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FISStream;
@class FISCard;

@interface FISCollectionDataManager : NSObject

@property (strong, nonatomic) NSArray *allStreams;

+ (instancetype)sharedDataManager;

/**
 *  Requests from the CardStreams.io API for all of the application's streams. These are returned without cards which must be requested separately.
 */
- (void)getAllStreamsWithCompletionBlock:(void (^)(BOOL success))completionBlock;

/**
 *  Deprecated.
 *  Requests from the CardStreams.io API all of the cards for the designated stream, filters them for the most recent card of each Github, Blog, and Stack Exchange type, and loads only these three cards into the stream's cards array property.
 */
- (void)getShowcaseCardsForStream:(FISStream *)stream completionBlock:(void (^)(NSArray *showcaseCards))completionBlock;

/**
 *  Returns the FISCard in the submitted array with the latest postAt time stamp of the cards containing "github" in the source property. If the result is nil, a test card is returned.
 */
- (FISCard *)findMostRecentGithubCardInCardsArray:(NSMutableArray *)allCards;

/**
 *  Returns the FISCard in the submitted array with the latest postAt time stamp of the cards containing "blog" in the source property. If the result is nil, a test card is returned.
 */
- (FISCard *)findMostRecentBlogCardInCardsArray:(NSMutableArray *)allCards;

/**
 *  Returns the FISCard in the submitted array with the latest postAt time stamp of the cards containing "stack_exchange" in the source property. If the result is nil, a test card is returned.
 */
- (FISCard *)findMostRecentStackExchangeCardInCardsArray:(NSMutableArray *)allCards;

@end
