//
//  FISCardCollectionViewCell.h
//  FISCardStreams
//
//  Created by Joseph Smalls-Mantey on 4/9/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISStream.h"

@interface FISCardCollectionViewCell : UICollectionViewCell <UITableViewDataSource, UITableViewDelegate>



@property (weak, nonatomic) IBOutlet UIView *bottomContainer;
@property (weak, nonatomic) IBOutlet UITableView *cardTableView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *gitHubField;
@property (weak, nonatomic) IBOutlet UILabel *blogField;

@property (weak, nonatomic) IBOutlet UILabel *stackOverflowField;


@property (strong, nonatomic) FISStream *stream;

@end

