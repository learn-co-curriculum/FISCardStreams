//
//  AddingCredentialsViewController.m
//  FISCardStreams
//
//  Created by Anish Kumar on 4/8/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "AddingCredentialsViewController.h"
#import "FISGithubAPIClient.h"
#import "FISStackExchangeAPI.h"
#import <AFNetworking.h>
#import <AFOAuth2Manager.h>

#import "StackSexchangeLoginWebViewController.h"

@interface AddingCredentialsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *checkerImage;

- (IBAction)githubLoginButtonTapped:(id)sender;

@end


@implementation AddingCredentialsViewController

#pragma mark - View Lifecycle

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


#pragma mark - UIButton Actions

- (IBAction)githubLoginButtonTapped:(id)sender {
    
    [FISGithubAPIClient redirectAfterAuthentication];
}

- (IBAction)stackExchangeLoginButtonTapped:(id)sender {
    
    //[FISStackExchangeAPI redirectAfterAuthentication];
    
    StackSexchangeLoginWebViewController *stackVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stackVC"];
    
    [self presentViewController:stackVC animated:YES completion:nil];
    
}
@end
