//
//  FISCardViewController.m
//  FISCardStreams
//
//  Created by Joseph Smalls-Mantey on 4/9/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "FISCardViewController.h"

#import "FISCardsTableViewController.h"
#import "FISCardCollectionViewCell.h"
#import "FISCardTableViewCell.h"

#import "FISStream.h"
#import "FISCard.h"

#import <RGCardViewLayout.h>
#import <UIColor+Hex.h>
#import <UIColor+uiGradients.h>

#import "FISStreamsDataManager.h"
#import "FISCollectionDataManager.h"



@interface FISCardViewController () 

@property (strong, nonatomic) IBOutlet UIView *backgroundGrandientView;
@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet FISCardCollectionViewCell *cardCell;

@property (strong, nonatomic) FISCollectionDataManager *collectionsDataManager;
@property (strong, nonatomic) FISStreamsDataManager *streamsDataManager;

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation FISCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpCollectionView];
    [self setUpBackgroundColors];
    [self roundCornersOnCollectionViewCell];
    
    self.cardCell.layer.cornerRadius = 5;
    self.cardCell.layer.masksToBounds = YES;


    self.collectionsDataManager = [FISCollectionDataManager sharedDataManager];
    self.streamsDataManager = [FISStreamsDataManager sharedDataManager];
    
    [self getAllCardsForUser];
    [self getAllStreams];

}


#pragma mark - 
-(void)roundCornersOnCollectionViewCell{
        self.cardCell.layer.cornerRadius = 5;
        self.cardCell.layer.masksToBounds = YES;
}

-(void)setUpBackgroundColors{
    
    [self.backgroundGrandientView setBackgroundColor:[UIColor clearColor]];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.backgroundGrandientView.bounds;
    gradient.startPoint = CGPointZero;
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = [NSArray arrayWithObjects: (id)[[UIColor uig_facebookMessengerStartColor] CGColor], (id)[[UIColor uig_facebookMessengerEndColor]CGColor], nil];
    
    [self.backgroundGrandientView.layer insertSublayer:gradient atIndex:0];
    
}


-(void)setUpCollectionView{
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *cardFlow = [[RGCardViewLayout alloc]init];
    self.collectionView.collectionViewLayout = cardFlow;
}

#pragma mark - CollectionView Delegate



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

#pragma mark - TableView Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stream.cards count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FISCardTableViewCell *cardCell = (FISCardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cardCell" forIndexPath:indexPath];
    
    FISCard *currentCard = self.stream.cards[indexPath.row];
    cardCell.card = currentCard;
    
    return cardCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 176;
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


- (void)getAllCardsForUser {
    [self.streamsDataManager getAllCardsForUserStreamWithCompletion:^(BOOL success) {
        NSLog(@"cards fetched");
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"Reload tableview");
            self.stream = self.streamsDataManager.userStream;
            self.navigationItem.title = self.stream.streamName;
            [self.tableView reloadData];
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
