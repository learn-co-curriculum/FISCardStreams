//
//  FISCardViewController.h
//  FISCardStreams
//
//  Created by Joseph Smalls-Mantey on 4/9/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISTableViewCell.h"

@class FISCard;
@class FISStream;

@interface FISCardViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) FISStream *stream;
@property (strong, nonatomic) IBOutlet FISTableViewCell *customCell;

@end
