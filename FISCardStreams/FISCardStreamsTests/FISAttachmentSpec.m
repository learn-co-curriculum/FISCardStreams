//
//  FISAttachmentSpec.m
//  FISCardStreams
//
//  Created by Mark Murray on 4/16/15.
//  Copyright 2015 Mark Edward Murray. All rights reserved.
//

#import "FISAttachment.h"

#import <Foundation/Foundation.h>
#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import "Expecta.h"
        
SpecBegin(FISAttachment)
        
describe(@"FISAttachment", ^{
    
    __block NSString       *attachmentID;
    __block NSString       *cardID;
    __block NSString       *createdBy;
    __block NSString       *originalUrl;
    __block NSString       *fileName;
    __block NSString       *mimeType;
    __block NSString       *fileSize;
    __block NSString       *status;
    __block NSArray        *errors;
    
    __block NSDictionary   *attachmentDictionary;
    
    __block NSDictionary   *attachmentDictionary2;
    __block NSArray        *attachmentDictionaries;
    
    __block FISAttachment  *defaultAttachment;
    __block FISAttachment  *designatedAttachment;
    __block FISAttachment  *dictionaryAttachment;
    __block NSMutableArray *attachmentsFromArray;
    
    beforeEach(^{
        
        attachmentID         = @"attachmentID";
        cardID               = @"cardID";
        createdBy            = @"createdBy";
        originalUrl          = @"originalUrl";
        fileName             = @"fileName";
        mimeType             = @"mimeType";
        fileSize             = @"fileSize";
        status               = @"status";
        errors               = @[@"error", @"error2"];
        
        attachmentDictionary = @{ @"id"          : attachmentID,
                                  @"createdBy"   : createdBy,
                                  @"originalUrl" : originalUrl,
                                  @"metadata" : @{ @"fileName" : fileName,
                                                   @"mimeType" : mimeType,
                                                   @"fileSize" : fileSize },
                                  @"control"  : @{ @"status" : status,
                                                   @"errors" : errors }
                                  };
        
        attachmentDictionary2  = [attachmentDictionary copy];
        attachmentDictionaries = @[attachmentDictionary, attachmentDictionary2];
        
        defaultAttachment = [[FISAttachment alloc]init];
        
        designatedAttachment =
        [[FISAttachment alloc]initWithAttachmentID:attachmentID
                                            cardID:cardID
                                         createdBy:createdBy
                                       originalURL:originalUrl
                                          fileName:fileName
                                          mimeType:mimeType
                                          fileSize:fileSize
                                            status:status
                                            errors:errors];
        
        dictionaryAttachment =
        [FISAttachment createAttachmentFromDictionary:attachmentDictionary
                                           withCardID:cardID];
        
        attachmentsFromArray =
        [FISAttachment attachmentsFromArray:attachmentDictionaries
                                 withCardID:cardID];
    });
        
    describe(@"default initializer", ^{
        it(@"creates object with default properties", ^{
            expect(defaultAttachment.attachmentID).to.equal(@"");
            expect(defaultAttachment.cardID      ).to.equal(@"");
            expect(defaultAttachment.createdBy   ).to.equal(@"");
            expect(defaultAttachment.originalURL ).to.equal(@"");
            expect(defaultAttachment.fileName    ).to.equal(@"");
            expect(defaultAttachment.mimeType    ).to.equal(@"");
            expect(defaultAttachment.fileSize    ).to.equal(@"");
            expect(defaultAttachment.status      ).to.equal(@"");
            expect(defaultAttachment.errors      ).to.equal(@[]);
        });
    });
    
    describe(@"designated initializer", ^{
        it(@"sets properties correctly", ^{
            expect(designatedAttachment.attachmentID).to.equal(attachmentID);
            expect(designatedAttachment.cardID      ).to.equal(cardID);
            expect(designatedAttachment.createdBy   ).to.equal(createdBy);
            expect(designatedAttachment.originalURL ).to.equal(originalUrl);
            expect(designatedAttachment.fileName    ).to.equal(fileName);
            expect(designatedAttachment.mimeType    ).to.equal(mimeType);
            expect(designatedAttachment.fileSize    ).to.equal(fileSize);
            expect(designatedAttachment.status      ).to.equal(status);
            expect(designatedAttachment.errors      ).to.equal(errors);
        });
    });
    describe(@"class initializer", ^{
        it(@"creates instance from dictionary", ^{
            expect(dictionaryAttachment.attachmentID).to.equal(attachmentID);
            expect(dictionaryAttachment.cardID      ).to.equal(cardID);
            expect(dictionaryAttachment.createdBy   ).to.equal(createdBy);
            expect(dictionaryAttachment.originalURL ).to.equal(originalUrl);
            expect(dictionaryAttachment.fileName    ).to.equal(fileName);
            expect(dictionaryAttachment.mimeType    ).to.equal(mimeType);
            expect(dictionaryAttachment.fileSize    ).to.equal(fileSize);
            expect(dictionaryAttachment.status      ).to.equal(status);
            expect(dictionaryAttachment.errors      ).to.equal(errors);
        });
    });
    describe(@"class array initializer", ^{
        it(@"creates multiple attachments from an array", ^{
            expect([attachmentsFromArray count]).to.equal(2);
            
            for (FISAttachment *currentAttachment in attachmentsFromArray) {
                expect(currentAttachment.attachmentID).to.equal(attachmentID);
                expect(currentAttachment.cardID      ).to.equal(cardID);
                expect(currentAttachment.createdBy   ).to.equal(createdBy);
                expect(currentAttachment.originalURL ).to.equal(originalUrl);
                expect(currentAttachment.fileName    ).to.equal(fileName);
                expect(currentAttachment.mimeType    ).to.equal(mimeType);
                expect(currentAttachment.fileSize    ).to.equal(fileSize);
                expect(currentAttachment.status      ).to.equal(status);
                expect(currentAttachment.errors      ).to.equal(errors);
            }
        });
    });
});

SpecEnd
