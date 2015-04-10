//
//  FISCardStreamsAPIClient.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Anish

#import <Foundation/Foundation.h>

@class FISStream;
@class FISCard;
@interface FISCardStreamsAPIClient : NSObject

/**
 *  Get all Streams to check the userame during signUp.
 */
+ (void) getAllStreamsAndCheckWithUsername: (NSString *)username CompletionBlock:(void (^)(FISStream *))completionBlock SecondCompletionBlock: (void (^)(BOOL unique))secondCompletionBlock;


/**
*  Create a stream for user with a unique Title given by the User as Username.
 */
+ (void) createAStreamForName: (NSString *)name WithCompletionBlock:(void (^)(FISStream *userStream))completionBlock;



/**
*  Get the user stream using the StreamID persisiting in the device (as CoreData or something else).
 */
+ (void) getStreamsForAUserWithStreamIDs: (NSString *)streamIDs AndCompletionBlock: (void (^)(FISStream *stream))completionBlock;



/**
 *  Create a card for the user using the unique StreamID and the JSON content passed as an NSDictionary wherever the method is called. This method returns the entire card to be displayed/stored.
 Example of content Dictionary:
 { "title": "BIGGGG3", "description": "sdfsdf", "attachments": [ { "filename": "", "mimeType": ".", "sourceUrl": "ww.sac.com" } ]}
 */
+ (void) createACardWithStreamID: (NSString *)streamID WithContentDictionary: (NSDictionary *)cardBody WithCompletionBlock:(void (^)(FISCard *card))completionBlock;



/**
 Get all Cards with the unique Stream ID and return the array of cards which can be stored in the dataStore. This may be used when the user logs in.
 */
+ (void) getAllCardsWithStreamID:(NSString *)streamID AndCheckWithCompletionBlock:(void (^)(NSArray *userCards))completionBlock;



/**
Used to update the Title, Description, Attachments, Tags of the card with a unique Card ID which belongs to the user's Steam ID. It takes the new dictionary of data and returns the updated FISCard.
 */
+ (void) updateACardsWithStreamID:(NSString *)streamID ACardID:(NSString *)cardID TheContentDictionary: (NSDictionary *)cardBody AndCheckWithCompletionBlock:(void (^)(FISCard *))completionBlock;



/**
 Delete a card.
 */
+ (void) deleteACardsWithStreamID:(NSString *)streamID ACardID:(NSString *)cardID AndCheckWithCompletionBlock:(void (^)(void))completionBlock;


+ (void) getAllStreamsWithCompletionBlock:(void (^)(NSArray *allStreams))completionBlock;

@end
