//
//  FISStreamViewController.h
//  FISCardStreams
//
//  Created by Joseph Smalls-Mantey on 4/12/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FISStream;

@interface FISStreamViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate >

@property (strong, nonatomic) FISStream *stream;

@end
