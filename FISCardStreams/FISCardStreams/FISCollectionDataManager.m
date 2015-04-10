//
//  FISCollectionDataManager.m
//  FISCardStreams
//
//  Created by Mark Murray on 4/10/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "FISCollectionDataManager.h"
#import "NSDate+DateFromJSONDate.h"

// API Clients
#import "FISCardStreamsAPIClient.h"

// Data Models
#import "FISStream.h"
#import "FISCard.h"
#import "FISAttachment.h"
#import "FISComment.h"


@implementation FISCollectionDataManager

+ (instancetype)sharedDataManager {
    static FISCollectionDataManager *_sharedDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataManager = [[FISCollectionDataManager alloc] init];
        _sharedDataManager.allStreams = [[NSMutableArray alloc]init];
    });
    return _sharedDataManager;
}

- (void)getAllStreamsWithCompletionBlock:(void (^)(NSArray *, BOOL))completionBlock {
    [FISCardStreamsAPIClient getAllStreamsWithCompletionBlock:^(NSArray *allStreams) {
        self.allStreams = [FISStream createArrayOfStreamsFromDictionaries:allStreams];
    }];
}

- (void)getShowcaseCardsForStream:(FISStream *)stream completionBlock:(void (^)(NSArray *))completionBlock {
    NSString *streamID = stream.streamID;
    [FISCardStreamsAPIClient getAllCardsWithStreamID:streamID AndCheckWithCompletionBlock:^(NSArray *userCards) {
        NSArray *allCards = [FISCard createArrayOfCardsFromDictionaries:userCards];
        
        FISCard *githubCard = [self findMostRecentGithubCardInCardsArray:allCards];
        FISCard *blogCard = [self findMostRecentBlogCardInCardsArray:allCards];
        FISCard *stackExchangeCard = [self findMostRecentStackExchangeCardInCardsArray:allCards];
        
        completionBlock(@[githubCard, blogCard, stackExchangeCard]);
    }];
}

#pragma mark - Helper Methods

- (FISCard *)findMostRecentGithubCardInCardsArray:(NSArray *)allCards {
    FISCard *githubCard = [FISCard init];
    githubCard.title = @"Github";
    return githubCard;
}

- (FISCard *)findMostRecentBlogCardInCardsArray:(NSArray *)allCards {
    FISCard *blogCard = [FISCard init];
    blogCard.title = @"Blog Post";
    return blogCard;
}

- (FISCard *)findMostRecentStackExchangeCardInCardsArray:(NSArray *)allCards {
    FISCard *stackExchangeCard = [FISCard init];
    stackExchangeCard.title = @"Stack Exchange";
    return stackExchangeCard;
}

@end
