//
//  FISCardstreamSignUpViewController.m
//  FISCardStreams
//
//  Created by Anish Kumar on 4/2/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.

//  Coded by Anish Kumar

#import <MONActivityIndicatorView.h>

#import "FISCardstreamSignUpViewController.h"
#import "FISStreamsDataManager.h"
#import "FISCardStreamsAPIClient.h"
#import "FISStream.h"

@interface FISCardstreamSignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (nonatomic) FISStreamsDataManager *dataManager;
@property (nonatomic) FISStream *streamToPass;

@property (nonatomic) MONActivityIndicatorView *indicatorView;

@end

@implementation FISCardstreamSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [FISStreamsDataManager sharedDataManager];
    
    self.usernameTextField.delegate = self;
    
    self. indicatorView = [[MONActivityIndicatorView alloc] init];
    [self.view addSubview:self.indicatorView];
    
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

- (IBAction)cancelButtonTapped:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)signUpButtonTapped:(id)sender {
    
    [self.indicatorView startAnimating];
    [FISCardStreamsAPIClient getAllStreamsAndCheckWithUsername:self.usernameTextField.text CompletionBlock:^(FISStream *stream) {
        
        [self.indicatorView stopAnimating];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signup failed"
                                                            message:@"Username is already taken"
                                                           delegate:self
                                                  cancelButtonTitle:@"Try Again"
                                                  otherButtonTitles:nil];
            [alert show];
    }SecondCompletionBlock:^(BOOL unique) {
        if (unique == NO) {
                [FISCardStreamsAPIClient createAStreamForName:self.usernameTextField.text WithCompletionBlock:^(FISStream *userStream) {
                    NSLog(@"Signed UP");
                    //self.dataManager.userStream = self.streamToPass;
                    //[self takeMeToHomePage];
                    [self.indicatorView stopAnimating];
                }];
        }
        }];
    
}

-(void)takeMeToHomePage
{
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = [myStoryboard instantiateInitialViewController];
    UIViewController *homePage = [myStoryboard instantiateViewControllerWithIdentifier:@"homeVC"];
    UIApplication *application = [UIApplication sharedApplication];
    [application.keyWindow setRootViewController:navController];
    
    [self presentViewController:homePage animated:YES completion:nil];
}

@end
