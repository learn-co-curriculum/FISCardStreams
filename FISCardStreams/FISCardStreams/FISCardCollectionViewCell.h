//
//  FISCardCollectionViewCell.h
//  FISCardStreams
//
//  Created by Joseph Smalls-Mantey on 4/9/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FISCardCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *headerField;
@property (weak, nonatomic) IBOutlet UITextField *contentField;


@end

