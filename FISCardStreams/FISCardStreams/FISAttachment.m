//
//  FISAttachment.m
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
// assigned to Mark

#import "FISAttachment.h"

@implementation FISAttachment

- (instancetype)init {
    self = [self initWithAttachmentID:@""
                               cardID:@""
                            createdBy:@""
                          originalURL:@""
                             fileName:@""
                             mimeType:@""
                             fileSize:@""
                               status:@""
                               errors:@[]];
    return self;
}

- (instancetype)initWithAttachmentID:(NSString *)attachmentID
                             cardID:(NSString *)cardID
                          createdBy:(NSString *)createdBy
                        originalURL:(NSString *)originalURL
                           fileName:(NSString *)fileName
                           mimeType:(NSString *)mimeType
                           fileSize:(NSString *)fileSize
                             status:(NSString *)status
                             errors:(NSArray *)errors {
    self = [super init];
    if (self) {
        _attachmentID = attachmentID;
        _cardID       = cardID;
        _createdBy    = createdBy;
        _originalURL  = originalURL;
        _fileName     = fileName;
        _mimeType     = mimeType;
        _fileSize     = fileSize;
        _status       = status;
        _errors       = errors;
    }
    return self;
}

+ (FISAttachment *)createAttachmentFromDictionary:(NSDictionary *)attachmentDictionary
                                       withCardID:(NSString *)cardID {
    return [[FISAttachment alloc]initWithAttachmentID:attachmentDictionary[@"id"]
                                               cardID:cardID
                                            createdBy:attachmentDictionary[@"createdBy"]
                                          originalURL:attachmentDictionary[@"originalUrl"]
                                             fileName:attachmentDictionary[@"metadata"][@"fileName"]
                                             mimeType:attachmentDictionary[@"metadata"][@"mimeType"]
                                             fileSize:attachmentDictionary[@"metadata"][@"fileSize"]
                                               status:attachmentDictionary[@"control"][@"status"]
                                               errors:attachmentDictionary[@"control"][@"errors"]   ];
}

+ (NSMutableArray *)attachmentsFromArray:(NSArray *)attachmentDictionaries
                              withCardID:(NSString *)cardID {
    NSMutableArray *attachments = [[NSMutableArray alloc]init];
    for (NSDictionary *attachmentDictionary in attachmentDictionaries) {
        FISAttachment *attachment = [FISAttachment createAttachmentFromDictionary:attachmentDictionary
                                                                       withCardID:cardID];
        [attachments addObject:attachment];
    }
    return attachments;
}

@end
