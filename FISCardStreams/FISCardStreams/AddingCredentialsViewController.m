//
//  AddingCredentialsViewController.m
//  FISCardStreams
//
//  Created by Anish Kumar on 4/8/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "AddingCredentialsViewController.h"
#import "FISGithubAPIClient.h"
#import <AFNetworking.h>
#import <AFOAuth2Manager.h>

@interface AddingCredentialsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *checkerImage;

- (IBAction)githubLoginButtonTapped:(id)sender;

@end

@implementation AddingCredentialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    AFOAuthCredential *cred = [AFOAuthCredential retrieveCredentialWithIdentifier:@"githubToken"];
    if (cred) {
        self.checkerImage.hidden = NO;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)githubLoginButtonTapped:(id)sender {
    
    [FISGithubAPIClient redirectAfterAuth];

}
@end
