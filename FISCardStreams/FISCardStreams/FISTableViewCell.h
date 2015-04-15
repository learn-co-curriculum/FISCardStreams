//
//  FISTableViewCell.h
//  FISCardStreams
//
//  Created by Joseph Smalls-Mantey on 4/15/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FISTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *dateLabel;

+ (NSString *)reuseIdentifier;
@end
