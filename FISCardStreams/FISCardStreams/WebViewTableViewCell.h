//
//  WebViewTableViewCell.h
//  FISCardStreams
//
//  Created by Anish Kumar on 4/14/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FISCard;
@interface WebViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIWebView *blogWebView;
@property (weak, nonatomic) FISCard *card;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;


@end
