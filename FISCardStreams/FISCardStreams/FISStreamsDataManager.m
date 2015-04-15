//
//  FISStreamsDataManager.m
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Mark

#import "FISStreamsDataManager.h"
#import "NSDate+DateFromJSONDate.h"
#import "FISConstants.h"

// API Clients
#import "FISCardStreamsAPIClient.h"
#import "FISStackExchangeAPI.h"
#import "FISRSSFeedAPIClient.h"
#import "FISGithubAPIClient.h"
#import "FISStackExchangeAPI.h"

// Data Models
#import "FISStream.h"
#import "FISCard.h"
#import "FISAttachment.h"
#import "FISComment.h"

@implementation FISStreamsDataManager

+ (instancetype)sharedDataManager {
    static FISStreamsDataManager *_sharedDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataManager = [[FISStreamsDataManager alloc] init];
        _sharedDataManager.streams = [[NSMutableArray alloc]init];
//        _sharedDataManager.blogURL = @"https://medium.com/@MarkEdwardMurray";
//        _sharedDataManager.githubUsername = @"markedwardmurray";
    });
    return _sharedDataManager;
}

#pragma mark - API requests

- (void)getStreamForStreamIDWithCompletion:(void (^)(BOOL))completionBlock {
    
    [FISCardStreamsAPIClient getStreamsForAUserWithStreamIDs:self.streamID AndCompletionBlock:^(FISStream *stream) {
        self.userStream = stream;
        completionBlock(YES);
    }];
}

- (void)getAllCardsForUserStreamWithCompletion:(void (^)(BOOL))completionBlock {
    if (self.userStream != nil) {
        [FISCardStreamsAPIClient getAllCardsWithStreamID:self.userStream.streamID AndCheckWithCompletionBlock:^(NSArray *userCards) {
            self.userStream.cards = [[NSMutableArray alloc]init];
            for (NSDictionary *cardDictionary in userCards) {
                FISCard *card = [FISCard createCardFromDictionary:cardDictionary];
                [self.userStream.cards addObject:card];
            }
            completionBlock(YES);
        }];
    } else {
        NSLog(@"userStream has not been fetched from the server");
    }
}

- (void)updateRSSFeedWithCompletionBlock:(void (^)(NSArray *))completionBlock {
    FISRSSFeedAPIClient *rssFeedAPIClient = [[FISRSSFeedAPIClient alloc]initWithBlogUrl:self.blogURL];
    
    NSMutableArray *allBlogCardTitles = [[NSMutableArray alloc]init];
    for (FISCard *currentCard in self.userStream.cards) {
        if ([currentCard.source isEqualToString:SOURCE_BLOG]) {
            [allBlogCardTitles addObject:currentCard.title];
        }
    }
    
    NSArray *allBlogPosts = [rssFeedAPIClient getBlogList];
    
    NSMutableArray *mNewBlogCards = [[NSMutableArray alloc]init];
    for (NSDictionary *blogDictionary in allBlogPosts) {
        
        // check that a card with this blog post's title does not already exist
        if ([allBlogCardTitles containsObject:blogDictionary[@"title"]]) {
            continue;
        }
        
        NSDate *postAt = [NSDate dateFromRSSDate:blogDictionary[@"pubDate"]];
        NSInteger postAtInt = [postAt timeIntervalSince1970] * 1000; // convert to milliseconds
        NSNumber *epochPostAt = @(postAtInt);
        
        NSDictionary *cardBody = @{ @"title" : blogDictionary[@"title"],
                                    @"description" : blogDictionary[@"summary"],
                                    @"postAt" : epochPostAt,
                                    @"postLink" :  blogDictionary[@"link"],
                                    @"source" : SOURCE_BLOG };
        [FISCardStreamsAPIClient createACardWithStreamID:self.userStream.streamID
                                   WithContentDictionary:cardBody
                                     WithCompletionBlock:^(FISCard *card) {
                                         [mNewBlogCards addObject:card];
                                         NSLog(@"card created %@", card.title);
                                     }];
    }
    NSArray *newBlogCards = [NSArray arrayWithArray:mNewBlogCards];
    completionBlock(newBlogCards);
}

- (void)updateGithubFeedWithCompletionBlock:(void (^)(NSArray *))completionBlock {
    NSMutableArray *allGithubCardTimeStamps = [[NSMutableArray alloc]init];
    for (FISCard *currentCard in self.userStream.cards) {
            if ([currentCard.source isEqualToString:SOURCE_GITHUB]) {
                NSInteger postAtInt = [currentCard.postAt timeIntervalSince1970] * 1000; // convert to milliseconds
                NSNumber *epochCardDate = @(postAtInt);
                [allGithubCardTimeStamps addObject:epochCardDate];
        }
    }
    
    NSMutableArray *newGithubCards = [[NSMutableArray alloc]init];
    [FISGithubAPIClient getPublicFeedsWithUsername:self.githubUsername
                               WithCompletionBlock:^(NSArray *commits) {
        for (NSDictionary *githubDictionary in commits) {
            NSDate *postAt = [NSDate dateFromGithubDate:githubDictionary[@"commited_date"]];
            NSInteger postAtInt = [postAt timeIntervalSince1970] * 1000; // convert to milliseconds
            NSNumber *epochPostAt = @(postAtInt);
            
            // checks via timestamp that the item has not been previously assimilated
            if ([allGithubCardTimeStamps containsObject:epochPostAt]) {
                continue;
            }
            
            NSString *cardDescription = [NSString stringWithFormat:@"%@ pushed to %@ \"%@\"",
                                         githubDictionary[@"username"],
                                         githubDictionary[@"repo_name"],
                                         githubDictionary[@"commit_message"]];
            
            NSDictionary *cardBody = @{ @"title" : @"Github Commit",
                                        @"description" : cardDescription,
                                        @"postAt" : epochPostAt,
                                        @"source" : SOURCE_GITHUB };
            
            [FISCardStreamsAPIClient createACardWithStreamID:self.userStream.streamID
                                       WithContentDictionary:cardBody
                                         WithCompletionBlock:^(FISCard *card) {
                                             
                                             [newGithubCards addObject:card];
                                             
                                             if ([githubDictionary isEqual:[commits lastObject]]) {
                                                 completionBlock(newGithubCards);
                                             }
                                         }];
        }
    }];
}

- (void)updateStackExchangeFeedWithCompletionBlock:(void (^)(NSArray *))completionBlock {
    NSMutableArray *allSECardTimeStamps = [[NSMutableArray alloc]init];
    for (FISCard *currentCard in self.userStream.cards) {
        if ([currentCard.source isEqualToString:SOURCE_STACK_EXCHANGE]) {
            NSInteger postAtInt = [currentCard.postAt timeIntervalSince1970] * 1000; // convert to milliseconds
            NSNumber *epochCardDate = @(postAtInt);
            [allSECardTimeStamps addObject:epochCardDate];
        }
    }
    
    NSMutableArray *newStackExchangeCards = [[NSMutableArray alloc]init];
    [FISStackExchangeAPI getNetworkActivityForCurrentUserWithCompletionBlock:^(NSArray *userNetworkActivities) {
        for (NSDictionary *activityDictionary in userNetworkActivities) {
            NSInteger postAtInt = [activityDictionary[@"creation_date"] integerValue] * 1000; // convert to milliseconds
            NSNumber *epochPostAt = @(postAtInt);
            
            if ([allSECardTimeStamps containsObject:epochPostAt]) {

                continue;
            }
            
            NSString *cardDescription = [NSString stringWithFormat:@"%@: %@\n%@",
                                         activityDictionary[@"activity_type"],
                                         activityDictionary[@"title"],
                                         activityDictionary[@"description"]  ];
            
            NSDictionary *cardBody = @{ @"title" : activityDictionary[@"api_site_parameter"],
                                        @"description" : cardDescription,
                                        @"postAt" : epochPostAt,
                                        @"postLink" : activityDictionary[@"link"],
                                        @"source" : SOURCE_STACK_EXCHANGE };
            
            [FISCardStreamsAPIClient createACardWithStreamID:self.userStream.streamID
                                       WithContentDictionary:cardBody
                                         WithCompletionBlock:^(FISCard *card) {
                                             [newStackExchangeCards addObject:card];
                                             
                                             if ([activityDictionary isEqual:[userNetworkActivities lastObject]]) {
                                                 completionBlock(newStackExchangeCards);
                                             }
                                         }];
        }
    }];
}


#pragma mark - Test Data

- (void)generateTestData {
    FISCard *card1 = [[FISCard alloc]init];
    card1.cardID = @"001";
    card1.title = @"Sample Card";
    card1.cardDescription = @"This is a sample card.";
    
    
    NSMutableArray *cards = [[NSMutableArray alloc]initWithArray:@[card1]];
    FISStream *stream = [[FISStream alloc]initWithStreamID:@"streamID"
                                                streamName:@"streamName"
                                         streamDescription:@"streamDescription"
                                                 createdAt:[NSDate date]
                                                     cards:cards            ];
    [self.streams addObject:stream];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "edu.self.FISCardStreams" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FISCardStreams" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FISCardStreams.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
