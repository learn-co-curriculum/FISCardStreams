//
//  FISCardTableViewCell.h
//  FISCardStreams
//
//  Created by Mark Murray on 4/3/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FISCard;

@interface FISCardTableViewCell : UITableViewCell

@property (weak, nonatomic) FISCard *card;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
