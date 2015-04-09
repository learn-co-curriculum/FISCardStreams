//
//  FISStreamsDataManager.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Mark

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FISStream;

@interface FISStreamsDataManager : NSObject

@property (strong, nonatomic) NSMutableArray *streams; // may be going unused

@property (strong, nonatomic) NSString *streamID;
@property (strong, nonatomic) FISStream *userStream;

/**
 The source address of the logged-in user's blog. The only blog site currently supported by the date formatter is Medium.com.
 */
@property (strong, nonatomic) NSString *blogURL;

/**
 The logged-in user's Github username for pulling commit details from the user's public newsfeed.
 */
@property (strong, nonatomic) NSString *githubUsername;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

+ (instancetype)sharedDataManager;

- (void)generateTestData;

- (void)getStreamForStreamIDWithCompletion:(void (^)(BOOL success))completionBlock;
- (void)getAllCardsForUserStreamWithCompletion:(void (^)(BOOL success))completionBlock;

- (void)updateRSSFeedWithCompletionBlock:(void (^)(NSArray *newBlogCards))completionBlock;
- (void)updateGithubFeedWithCompletionBlock:(void (^)(NSArray *newGithubCards))completionBlock;

@end
