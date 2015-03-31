//
//  FISAttachment.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
// assigned to Mark

#import <Foundation/Foundation.h>

@interface FISAttachment : NSObject

/**
 The unique identifier of the Attachment.
 */
@property (strong, nonatomic) NSString *attachmentID;

/**
 This property is not part of the JSON sub-dictionary and should not be sent to the API. It is an implicit property for internally maintaining an attachment's relationship to it's parent card.
 */
@property (strong, nonatomic) NSString *cardID;

/**
 The unique id of the user who created this attachment.
 */
@property (strong, nonatomic) NSString *createdBy;

/**
 The URL from which the Attachment was originally fetched and embedded into the card.
 */
@property (strong, nonatomic) NSString *originalURL;

// parameters of the attachment's "metadata" dictionary
/**
 Name of the attached file.
 */
@property (strong, nonatomic) NSString *fileName;

/**
 (optional) MIME type of the attached file.
 */
@property (strong, nonatomic) NSString *mimeType;

/**
 (optional) Size (in bytes) of the attached file.
 */
@property (strong, nonatomic) NSString *fileSize;

// parameters of the attachment's "control" dictionary
/**
 ['new' or 'processed']: Status of the process that embeds an Attachment to the Card.
 */
@property (strong, nonatomic) NSString *status;

/**
 (optional) Summary of errors occurred during the embedding process.
 */
@property (strong, nonatomic) NSArray  *errors;

- (instancetype)init;

/**
 Designated initializer.
 */
- (instancetype)initWithAttachmentID:(NSString *)attachmentID
                              cardID:(NSString *)cardID
                           createdBy:(NSString *)createdBy
                         originalURL:(NSString *)originalURL
                            fileName:(NSString *)fileName
                            mimeType:(NSString *)mimeType
                            fileSize:(NSString *)fileSize
                              status:(NSString *)status
                              errors:(NSArray *)errors;

/**
 Generates an Attachment from a serialized JSON dictionary response from the CardStreams API for the designated Card.
 */
+ (FISAttachment *)createAttachmentFromDictionary:(NSDictionary *)attachmentDictionary
                                       withCardID:(NSString *)cardID;

@end
