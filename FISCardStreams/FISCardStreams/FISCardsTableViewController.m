//
//  FISCardsTableViewController.m
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Mark (temp)

#import <AFOAuth2Manager.h>


#import "FISCardsTableViewController.h"
#import "AddingCredentialsViewController.h"

#import "FISStreamsDataManager.h"

// Custom Cells
#import "FISCardTableViewCell.h"

// Models
#import "FISStreamsDataManager.h"
#import "FISStream.h"
#import "FISCard.h"

@interface FISCardsTableViewController ()

@property (strong, nonatomic) FISStreamsDataManager *streamsDataManager;

- (IBAction)refreshTapped:(id)sender;

@end

@implementation FISCardsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.streamsDataManager = [FISStreamsDataManager sharedDataManager];
    
    [self.streamsDataManager getAllCardsForUserStreamWithCompletion:^(BOOL success) {
        NSLog(@"cards fetched");
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"Reload tableview");
            self.stream = self.streamsDataManager.userStream;
            self.navigationItem.title = self.stream.streamName;
            [self.tableView reloadData];
        }];
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)refreshTapped:(id)sender {
    [self.streamsDataManager updateRSSFeedWithCompletionBlock:^(NSArray *newBlogCards) {
        [self.streamsDataManager.userStream.cards addObjectsFromArray:newBlogCards];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
    
    [self.streamsDataManager updateGithubFeedWithCompletionBlock:^(NSArray *newGithubCards) {
        [self.streamsDataManager.userStream.cards addObjectsFromArray:newGithubCards];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
}

@end
