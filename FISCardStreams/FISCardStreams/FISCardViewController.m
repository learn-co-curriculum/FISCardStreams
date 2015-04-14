//
//  FISCardViewController.m
//  FISCardStreams
//
//  Created by Joseph Smalls-Mantey on 4/9/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "FISCardViewController.h"
#import "FISCardCollectionViewCell.h"
#import <RGCardViewLayout.h>
#import "FISStream.h"
#import "FISCard.h"


#import "FISCollectionDataManager.h"

@interface FISCardViewController () 

@property (nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) FISCollectionDataManager *collectionsDataManager;

@end

@implementation FISCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpCollectionView];
    
    self.collectionsDataManager = [FISCollectionDataManager sharedDataManager];
//    [self getAllStreams];
    

}


-(void)setUpCollectionView{
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *cardFlow = [[RGCardViewLayout alloc]init];
    self.collectionView.collectionViewLayout = cardFlow;
}

#pragma mark - CollectionView Delegate

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(300, 600);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    
//    return UIEdgeInsetsMake( 8, 8, 8, 8);
//}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 3;
//    NSLog(@"COUNT %lu", [self.collectionsDataManager.allStreams count]);
//    return [self.collectionsDataManager.allStreams count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FISCardCollectionViewCell *cell = [collectionView    dequeueReusableCellWithReuseIdentifier:@"cardCell" forIndexPath:indexPath];
    
    FISStream *currentStream = self.collectionsDataManager.allStreams[0];
    
//    FISCard *gitHubCard = currentStream.cards[indexPath.section];
//    NSLog(@"%ld", indexPath.row);
//    
//    cell.titleField.text = gitHubCard.title;
//    cell.contentField.text = gitHubCard.cardDescription;
    
    
    return cell;
}


#pragma mark - View Helper Methods

-(void)getAllStreams{
    [self.collectionsDataManager getAllStreamsWithCompletionBlock:^(BOOL success) {
        NSLog(@"collections fetched");
        
        for (FISStream *currentStream in self.collectionsDataManager.allStreams) {
            [self.collectionsDataManager getShowcaseCardsForStream:currentStream completionBlock:^(NSArray *showcaseCards) {
                [currentStream.cards addObjectsFromArray:showcaseCards];
            }];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"reload tableivew");
        }];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
