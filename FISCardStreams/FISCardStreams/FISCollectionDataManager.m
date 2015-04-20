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
//        NSLog(@"%@", self.allStreams);
        
        for (FISStream *currentStream in self.allStreams) {
            [FISCardStreamsAPIClient getAllCardsWithStreamID:currentStream.streamID AndCheckWithCompletionBlock:^(NSArray *userCards) {
                currentStream.cards = [[NSMutableArray alloc]init];
                for (NSDictionary *cardDictionary in userCards) {
                    FISCard *card = [FISCard createCardFromDictionary:cardDictionary];
                    [currentStream.cards addObject:card];
                }
                NSLog(@"cards fetched for %@", currentStream);
                if ([currentStream isEqual:[self.allStreams lastObject]]) {
                    completionBlock(YES);
                }
            }];
        }
    }];
}


#pragma mark - Predicate methods

- (FISCard *)findMostRecentGithubCardInCardsArray:(NSMutableArray *)userCards {
    NSPredicate *githubPredicate = [NSPredicate predicateWithFormat:@"source == %@", SOURCE_GITHUB];
    NSArray *githubArray = [userCards filteredArrayUsingPredicate:githubPredicate];
    FISCard *githubCard = [githubArray firstObject];
    
    if (!githubCard) {
        githubCard = [[FISCard alloc] init];
        githubCard.title = @"Github";
        githubCard.cardDescription = @"Test github commit.";
    }
    return githubCard;
}

- (NSInteger)findCountOfGithubCommitsInLastSevenDaysInCardsArray:(NSArray *)userCards {
    NSPredicate *githubPredicate = [NSPredicate predicateWithFormat:@"source == %@", SOURCE_GITHUB];
    NSArray *githubArray = [[NSArray alloc]init];
    githubArray = [userCards filteredArrayUsingPredicate:githubPredicate];
    
    NSInteger secondsInOneWeekNeg = -604800;
    NSDate *oneWeekAgo = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsInOneWeekNeg];
    
    NSPredicate *withinOneWeekAgoPredicate = [NSPredicate predicateWithFormat:@"postAt > %@", oneWeekAgo];
    NSArray *githubWithinOneWeekAgoArray = [githubArray filteredArrayUsingPredicate:withinOneWeekAgoPredicate];
    
//    NSLog(@"%@", githubWithinOneWeekAgoArray);
    
    return [githubWithinOneWeekAgoArray count];
}

- (FISCard *)findMostRecentBlogCardInCardsArray:(NSMutableArray *)userCards {
    NSPredicate *blogPredicate = [NSPredicate predicateWithFormat:@"source == %@", SOURCE_BLOG];
    NSArray *blogArray = [userCards filteredArrayUsingPredicate:blogPredicate];
    FISCard *blogCard = [blogArray firstObject];
    
    if (!blogCard) {
        blogCard = [[FISCard alloc]init];
        blogCard.title = @"No blog posts found";
        blogCard.cardDescription = @"No blog posts found.";
    }
    return blogCard;
}

- (FISCard *)findMostRecentStackExchangeCardInCardsArray:(NSMutableArray *)userCards {
    NSPredicate *stackExchangePredicate = [NSPredicate predicateWithFormat:@"source == %@", SOURCE_STACK_EXCHANGE];
    NSArray *stackExchangeArray = [userCards filteredArrayUsingPredicate:stackExchangePredicate];
    FISCard *stackExchangeCard = [stackExchangeArray firstObject];
    
    if (!stackExchangeCard) {
        stackExchangeCard = [[FISCard alloc]init];
        stackExchangeCard.title = @"No Stack Exchange cards found.";
        stackExchangeCard.cardDescription = @"No Stack Exchange posts found.";
    }
    return stackExchangeCard;
}

@end
