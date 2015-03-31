//
//  FISAttachment.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISAttachment : NSObject

@property (strong, nonatomic) NSString *attachmentID;
/**
 This property is not part of the JSON sub-dictionary and cannot be used for the API call. It is an implicit property for internally maintaining an attachment's relationship to it's parent card.
 */
@property (strong, nonatomic) NSString *cardID;

@property (strong, nonatomic) NSString *createdBy;
@property (strong, nonatomic) NSString *originalURL;

// meta data
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *mimeType;
@property (strong, nonatomic) NSString *fileSize;

// control
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSArray  *errors;

- (instancetype)init;

- (instancetype)initWithAttachmentID:(NSString *)attachmentID
                              cardID:(NSString *)cardID
                           createdBy:(NSString *)createdBy
                         originalURL:(NSString *)originalURL
                            fileName:(NSString *)fileName
                            mimeType:(NSString *)mimeType
                            fileSize:(NSString *)fileSize
                              status:(NSString *)status
                              errors:(NSArray *)errors;

+ (FISAttachment *)createAttachmentFromDictionary:(NSDictionary *)attachmentDictionary
                                       withCardID:(NSString *)cardID;

@end
