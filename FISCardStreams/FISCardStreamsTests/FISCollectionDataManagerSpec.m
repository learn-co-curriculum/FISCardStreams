//
//  FISCollectionDataManagerSpec.m
//  FISCardStreams
//
//  Created by Mark Murray on 4/17/15.
//  Copyright 2015 Mark Edward Murray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import "Expecta.h"

#import "FISCollectionDataManager.h"

#import "FISConstants.h"

#import "FISStream.h"
#import "FISCard.h"


SpecBegin(FISCollectionDataManager)

describe(@"FISCollectionDataManager", ^{
    
    __block FISCard   *github1;
    __block FISCard   *github2;
    __block FISCard   *github3;
    __block FISCard   *blog1;
    __block FISCard   *blog2;
    __block FISCard   *blog3;
    __block FISCard   *stackExchange1;
    __block FISCard   *stackExchange2;
    __block FISCard   *stackExchange3;
    
    __block FISStream *stream1;
    __block FISStream *stream2;
    
    __block FISCollectionDataManager *collectionDataManager;
    
    beforeEach(^{
        github1 = [[FISCard alloc]init];
        github1.title = @"github1";
        github1.source = SOURCE_GITHUB;
        github1.postAt = [NSDate date];
        github2 = [[FISCard alloc]init];
        github2.title = @"github2";
        github2.source = SOURCE_GITHUB;
        github2.postAt = [NSDate dateWithTimeIntervalSinceNow:-100];
        github3 = [[FISCard alloc]init];
        github3.title = @"github3";
        github3.source = SOURCE_GITHUB;
        github3.postAt = [NSDate dateWithTimeIntervalSinceNow:-700000];
        
        
        blog1 = [[FISCard alloc]init];
        blog1.title = @"blog1";
        blog1.source = SOURCE_BLOG;
        blog1.postAt = [NSDate date];
        blog2 = [[FISCard alloc]init];
        blog2.title = @"blog2";
        blog2.source = SOURCE_BLOG;
        blog2.postAt = [NSDate dateWithTimeIntervalSinceNow:-100];
        blog3 = [[FISCard alloc]init];
        blog3.title = @"blog3";
        blog3.source = SOURCE_BLOG;
        blog3.postAt = [NSDate dateWithTimeIntervalSinceNow:-700000];
        

        stackExchange1 = [[FISCard alloc]init];
        stackExchange1.title = @"stackExchange1";
        stackExchange1.source = SOURCE_STACK_EXCHANGE;
        stackExchange1.postAt = [NSDate date];
        stackExchange2 = [[FISCard alloc]init];
        stackExchange2.title = @"stackExchange2";
        stackExchange2.source = SOURCE_STACK_EXCHANGE;
        stackExchange2.postAt = [NSDate dateWithTimeIntervalSinceNow:-100];
        stackExchange3 = [[FISCard alloc]init];
        stackExchange3.title = @"stackExchange3";
        stackExchange3.source = SOURCE_STACK_EXCHANGE;
        stackExchange3.postAt = [NSDate dateWithTimeIntervalSinceNow:-700000];
        
        
        stream1 = [[FISStream alloc]init];
        stream1.streamName = @"stream1";
        [stream1.cards addObjectsFromArray:@[github1, github2, github3,
                                             blog1, blog2, blog3,
                                             stackExchange1, stackExchange2, stackExchange3]];
        stream2 = [[FISStream alloc]init];
        stream2.streamName = @"stream2";
        stream2.cards = [stream1.cards copy];
        
        collectionDataManager = [FISCollectionDataManager sharedDataManager];
        collectionDataManager.allStreams = @[stream1, stream2];
    
    });
    
    describe(@"github counter", ^{
        it(@"correctly counts recent github cards in array", ^{
            FISStream *firstStream = collectionDataManager.allStreams[0];
            NSMutableArray *firstStreamCards = firstStream.cards;
            NSInteger githubCount = [collectionDataManager findCountOfGithubCommitsInLastSevenDaysInCardsArray:firstStreamCards];
            
            expect(githubCount).to.equal(2);
        });
    });
    describe(@"last blog fetcher", ^{
        it(@"returns the most recent blog card", ^{
            FISStream *firstStream = collectionDataManager.allStreams[0];
            NSMutableArray *firstStreamCards = firstStream.cards;
            FISCard *mostRecentBlogCard = [collectionDataManager findMostRecentBlogCardInCardsArray:firstStreamCards];
            
            expect(mostRecentBlogCard).to.equal(blog1);
        });
    });
    describe(@"last stack exchange fetcher", ^{
        it(@"returns the most recent stack exchange card", ^{
            FISStream *firstStream = collectionDataManager.allStreams[0];
            NSMutableArray *firstStreamCards = firstStream.cards;
            FISCard *mostRecentStackExchangeCard = [collectionDataManager findMostRecentStackExchangeCardInCardsArray:firstStreamCards];

            expect(mostRecentStackExchangeCard).to.equal(stackExchange1);
        });
    });
    
    
    afterEach(^{

    });
    
    afterAll(^{

    });
});

SpecEnd
