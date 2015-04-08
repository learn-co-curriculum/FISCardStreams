//
//  FISCardStreamsAPIClient.m
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Anish

#import "FISCardStreamsAPIClient.h"
#import "FISConstants.h"
#import "FISStream.h"
#import "FISCard.h"

#import <AFNetworking.h>
#import <AFHTTPRequestSerializer+OAuth2.h>

@implementation FISCardStreamsAPIClient


+ (void) getAllStreamsAndCheckWithUsername: (NSString *)username CompletionBlock:(void (^)(FISStream *))completionBlock SecondCompletionBlock: (void (^)(BOOL ))secondCompletionBlock
{
 
    __block BOOL unique = NO;
    NSString *cardstreamURL = [NSString stringWithFormat:@"%@/streams", CARDSTREAMS_BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc] init];
    
    [serializer setValue:CARDSTREAMS_APP_ID forHTTPHeaderField:@"X-Lifestreams-3scale-AppId"];
    [serializer setValue:CARDSTREAMS_KEY forHTTPHeaderField:@"X-Lifestreams-3scale-AppKey"];
    
    manager.requestSerializer = serializer;
    
    [manager GET:cardstreamURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *allStreams = responseObject;
        for (NSDictionary *streamDictionary in allStreams) {
            if ([streamDictionary[@"name"] isEqualToString:username]) {
                
                FISStream *stream = [FISStream createStreamFromDictionary:streamDictionary];
                unique = YES;
                completionBlock(stream);
                
            }
        }
        
        secondCompletionBlock(unique);

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@", error.localizedDescription);
    }];

}



+ (void) createAStreamForName: (NSString *)name WithCompletionBlock:(void (^)(FISStream *))completionBlock
{
    NSString *cardstreamURL = [NSString stringWithFormat:@"%@/streams", CARDSTREAMS_BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc] init];
    [serializer setValue:CARDSTREAMS_APP_ID forHTTPHeaderField:@"X-Lifestreams-3scale-AppId"];
    [serializer setValue:CARDSTREAMS_KEY forHTTPHeaderField:@"X-Lifestreams-3scale-AppKey"];
    
    manager.requestSerializer = serializer;
    
    NSString *description = [NSString stringWithFormat:@"Stream for: %@", name];
    
    NSDictionary *body = @{@"name": name,
                           @"description": description};
    
    [manager POST:cardstreamURL parameters:body success:^(NSURLSessionDataTask *task, id responseObject) {
        FISStream *streamCreated = [FISStream createStreamFromDictionary:responseObject];
        completionBlock(streamCreated);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@", error.localizedDescription);
    }];
}



+ (void) getStreamsForAUserWithStreamIDs: (NSString *)streamID AndCompletionBlock:(void (^)(FISStream *))completionBlock
{
    NSString *cardstreamURL = [NSString stringWithFormat:@"%@/streams/%@", CARDSTREAMS_BASE_URL, streamID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc] init];
    
    [serializer setValue:CARDSTREAMS_APP_ID forHTTPHeaderField:@"X-Lifestreams-3scale-AppId"];
    [serializer setValue:CARDSTREAMS_KEY forHTTPHeaderField:@"X-Lifestreams-3scale-AppKey"];
    
    manager.requestSerializer = serializer;
    
    [manager GET:cardstreamURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseStreamDictionary = responseObject;
        FISStream *responseStream = [FISStream createStreamFromDictionary:responseStreamDictionary];
        
        completionBlock(responseStream);
        
        NSLog(@"ResponseObject: %@", responseStream.streamName);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@", error.localizedDescription);
    }];
}



/*
 Example of content Dictionary:
 { "title": "BIGGGG3", "description": "sdfsdf", "attachments": [ { "filename": "", "mimeType": ".", "sourceUrl": "ww.sac.com" } ]}
 */

+ (void) createACardWithStreamID: (NSString *)streamID WithContentDictionary: (NSDictionary *)cardBody WithCompletionBlock:(void (^)(FISCard *))completionBlock
{
    NSString *cardstreamURL = [NSString stringWithFormat:@"%@/streams/%@/cards", CARDSTREAMS_BASE_URL, streamID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc] init];
    [serializer setValue:CARDSTREAMS_APP_ID forHTTPHeaderField:@"X-Lifestreams-3scale-AppId"];
    [serializer setValue:CARDSTREAMS_KEY forHTTPHeaderField:@"X-Lifestreams-3scale-AppKey"];
    
    manager.requestSerializer = serializer;
    
    [manager POST:cardstreamURL parameters:cardBody success:^(NSURLSessionDataTask *task, id responseObject) {
        
        FISCard *cardReturned = [FISCard createCardFromDictionary:responseObject];
        completionBlock(cardReturned);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@", error.localizedDescription);
    }];
}



+ (void) getAllCardsWithStreamID:(NSString *)streamID AndCheckWithCompletionBlock:(void (^)(NSArray *))completionBlock
{
    NSString *cardstreamURL = [NSString stringWithFormat:@"%@/streams/%@/cards", CARDSTREAMS_BASE_URL, streamID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc] init];
    [serializer setValue:CARDSTREAMS_APP_ID forHTTPHeaderField:@"X-Lifestreams-3scale-AppId"];
    [serializer setValue:CARDSTREAMS_KEY forHTTPHeaderField:@"X-Lifestreams-3scale-AppKey"];
    
    manager.requestSerializer = serializer;

    [manager GET:cardstreamURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *returnedDictionary = responseObject;
        NSArray *allStreams = returnedDictionary[@"cards"];
        completionBlock(allStreams);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Fail: %@", error.localizedDescription);
        
    }];

}



+ (void) updateACardsWithStreamID:(NSString *)streamID ACardID:(NSString *)cardID TheContentDictionary: (NSDictionary *)cardBody AndCheckWithCompletionBlock:(void (^)(FISCard *))completionBlock
{
    NSString *cardstreamURL = [NSString stringWithFormat:@"%@/streams/%@/cards/%@", CARDSTREAMS_BASE_URL, streamID, cardID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc] init];
    [serializer setValue:CARDSTREAMS_APP_ID forHTTPHeaderField:@"X-Lifestreams-3scale-AppId"];
    [serializer setValue:CARDSTREAMS_KEY forHTTPHeaderField:@"X-Lifestreams-3scale-AppKey"];
    
    manager.requestSerializer = serializer;
    
    [manager PATCH:cardstreamURL parameters:cardBody success:^(NSURLSessionDataTask *task, id responseObject) {
        
        FISCard *cardReturned = [FISCard createCardFromDictionary:responseObject];
        completionBlock(cardReturned);
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Fail: %@", error.localizedDescription);
        
    }];
    
}



+ (void) postAnAttachmentWithStreamID:(NSString *)streamID ACardID:(NSString *)cardID TheContentDictionary: (NSDictionary *)cardBody AndCheckWithCompletionBlock:(void (^)(FISCard *))completionBlock
{
    NSString *cardstreamURL = [NSString stringWithFormat:@"%@/streams/%@/cards/%@", CARDSTREAMS_BASE_URL, streamID, cardID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc] init];
    [serializer setValue:CARDSTREAMS_APP_ID forHTTPHeaderField:@"X-Lifestreams-3scale-AppId"];
    [serializer setValue:CARDSTREAMS_KEY forHTTPHeaderField:@"X-Lifestreams-3scale-AppKey"];
    
    manager.requestSerializer = serializer;
    
    [manager PATCH:cardstreamURL parameters:cardBody success:^(NSURLSessionDataTask *task, id responseObject) {
        
        FISCard *cardReturned = [FISCard createCardFromDictionary:responseObject];
        completionBlock(cardReturned);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Fail: %@", error.localizedDescription);
        
    }];
    
}




+ (void) deleteACardsWithStreamID:(NSString *)streamID ACardID:(NSString *)cardID AndCheckWithCompletionBlock:(void (^)(void))completionBlock
{
    NSString *cardstreamURL = [NSString stringWithFormat:@"%@/streams/%@/cards/%@", CARDSTREAMS_BASE_URL, streamID, cardID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc] init];
    [serializer setValue:CARDSTREAMS_APP_ID forHTTPHeaderField:@"X-Lifestreams-3scale-AppId"];
    [serializer setValue:CARDSTREAMS_KEY forHTTPHeaderField:@"X-Lifestreams-3scale-AppKey"];
    
    manager.requestSerializer = serializer;
    
    [manager DELETE:cardstreamURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"Deleted the card with CardID: %@", cardID);
        completionBlock();
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Fail: %@", error.localizedDescription);
        
    }];

}



@end
