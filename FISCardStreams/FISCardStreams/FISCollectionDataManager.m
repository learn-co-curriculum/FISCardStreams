//
//  FISCollectionDataManager.m
//  FISCardStreams
//
//  Created by Mark Murray on 4/10/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "FISCollectionDataManager.h"
#import "NSDate+DateFromJSONDate.h"

#import "FISConstants.h"

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

- (void)getAllStreamsWithCompletionBlock:(void (^)(BOOL))completionBlock {
    [FISCardStreamsAPIClient getAllStreamsWithCompletionBlock:^(NSArray *allStreams) {
        self.allStreams = [FISStream createArrayOfStreamsFromDictionaries:allStreams];
        NSLog(@"%@", self.allStreams);
        
        completionBlock(YES);
    }];
}

- (void)getShowcaseCardsForStream:(FISStream *)stream completionBlock:(void (^)(NSArray *))completionBlock {
    NSString *streamID = stream.streamID;
    [FISCardStreamsAPIClient getAllCardsWithStreamID:streamID AndCheckWithCompletionBlock:^(NSArray *userCards) {
        NSArray *allCards = [FISCard createArrayOfCardsFromDictionaries:userCards];
        
        FISCard *githubCard = [self findMostRecentGithubCardInCardsArray:allCards];
        FISCard *blogCard = [self findMostRecentBlogCardInCardsArray:allCards];
        FISCard *stackExchangeCard = [self findMostRecentStackExchangeCardInCardsArray:allCards];
        NSArray *arrayOFCards = @[githubCard, blogCard, stackExchangeCard];
        completionBlock(arrayOFCards);
    }];
}

#pragma mark - Predicate methods

- (FISCard *)findMostRecentGithubCardInCardsArray:(NSArray *)allCards {
    NSPredicate *githubPredicate = [NSPredicate predicateWithFormat:@"source == %@", SOURCE_GITHUB];
    NSArray *githubArray = [allCards filteredArrayUsingPredicate:githubPredicate];
    FISCard *githubCard = [githubArray firstObject];
    
    if (!githubCard) {
        githubCard = [[FISCard alloc] init];
        githubCard.title = @"Github";
        githubCard.cardDescription = @"Test github commit.";
    }
    return githubCard;
}

- (FISCard *)findMostRecentBlogCardInCardsArray:(NSArray *)allCards {
    NSPredicate *blogPredicate = [NSPredicate predicateWithFormat:@"source == %@", SOURCE_BLOG];
    NSArray *blogArray = [allCards filteredArrayUsingPredicate:blogPredicate];
    FISCard *blogCard = [blogArray firstObject];
    
    if (!blogCard) {
        blogCard = [[FISCard alloc]init];
        blogCard.title = @"Blog Post";
        blogCard.cardDescription = @"Test blog post.";
    }
    return blogCard;
}

- (FISCard *)findMostRecentStackExchangeCardInCardsArray:(NSArray *)allCards {
    NSPredicate *stackExchangePredicate = [NSPredicate predicateWithFormat:@"source == %@", SOURCE_STACK_EXCHANGE];
    NSArray *stackExchangeArray = [allCards filteredArrayUsingPredicate:stackExchangePredicate];
    FISCard *stackExchangeCard = [stackExchangeArray firstObject];
    
    if (!stackExchangeCard) {
        stackExchangeCard = [[FISCard alloc]init];
        stackExchangeCard.title = @"Stack Exchange";
        stackExchangeCard.cardDescription = @"Test stack exchange card.";
    }
    return stackExchangeCard;
}

@end
