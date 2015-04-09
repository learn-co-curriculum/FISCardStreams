//
//  FISStackExchangeAPI.m
//  FISCardStreams
//
//  Created by Anish Kumar on 4/8/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "FISStackExchangeAPI.h"
#import <AFNetworking/AFNetworking.h>
#import <AFOAuth2Manager.h>

#import "FISConstants.h"


@implementation FISStackExchangeAPI

+ (void)getNetworkActivityForCurrentUserWithToken:(NSString *)token
                                  completionBlock:(void (^)(NSArray *))completionBlock {
    NSString *stackExchangeURL = [NSString stringWithFormat:@"%@/me/network-activity", STACKEXCHANGE_BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc]init];
    
    [serializer setValue:token forKey:@"access_token"];
    
    manager.requestSerializer = serializer;
    
    [manager GET:stackExchangeURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"ResponseObject: %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure: %@", error.localizedDescription);
    }];
    
    
}


@end
