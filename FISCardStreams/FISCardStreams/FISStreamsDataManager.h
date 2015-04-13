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
 *  The source address of the logged-in user's blog. The only blog site currently supported by the date formatter is Medium.com.
 */
@property (strong, nonatomic) NSString *blogURL;

/**
 *  The logged-in user's Github username for pulling commit details from the user's public newsfeed.
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

/**
 *  Downloads all of the posts from the blog specified in the data manager's blogURL property and checks them for uniqueness by title property. 
 *  Unique cards are POSTed to the CardStreams.io API under the currently set userStream's streamID, and the added locally to the userStream's cards array.
 */
- (void)updateRSSFeedWithCompletionBlock:(void (^)(NSArray *newBlogCards))completionBlock;

/**
 *  Downloads all of the commits for the Github username specified in the data manager's githubUsername property and checks them for uniqueness by time stamp among cards which share the "github" value in the "source" property. 
 *  Unique cards are POSTed to the CardStreams.io API under the currently set userStream's streamID, and the added locally to the userStream's cards array.
 */
- (void)updateGithubFeedWithCompletionBlock:(void (^)(NSArray *newGithubCards))completionBlock;

/**
 *  Downloads all of the network-activity for the Stack Exchange account attributed by the access_token granted during the sign up process and checks them for uniqueness by time stamp among cards which share the "stack_exchange" value in the "source" property.
 *  Unique cards are POSTed to the CardStreams.io API under the currently set userStream's streamID, and the added locally to the userStream's cards array.
 */
- (void)updateStackExchangeFeedWithCompletionBlock:(void (^)(NSArray *newStackExchangeCards))completionBlock;

@end
