//
//  FISCardstreamLogInViewController.m
//  FISCardStreams
//
//  Created by Anish Kumar on 4/2/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.

//  Coded by Anish Kumar


#import "FISCardstreamLogInViewController.h"
#import "FISCardStreamsAPIClient.h"
#import "FISStreamsDataManager.h"
#import "FISStream.h"
#import "FISCardstreamSignUpViewController.h"

@interface FISCardstreamLogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (nonatomic) FISStreamsDataManager *dataManager;
@property (nonatomic) FISStream *streamToPass;

@end

@implementation FISCardstreamLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [FISStreamsDataManager sharedDataManager];

    self.usernameTextField.delegate = self;

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
- (IBAction)logInButtonTapped:(id)sender {
    
   [FISCardStreamsAPIClient getAllStreamsAndCheckWithUsername:self.usernameTextField.text CompletionBlock:^(FISStream *stream) {
           self.streamToPass = stream;
           NSLog(@"Logged In");
           //self.dataManager.userStream = self.streamToPass;
           //[self takeMeToHomePage];
   } SecondCompletionBlock:^(BOOL unique) {
       if (!unique) {
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log in failed"
                                                       message:@"Username doesn't match"
                                                      delegate:self
                                             cancelButtonTitle:@"Try Again"
                                             otherButtonTitles:nil];
       [alert show];
       }
       
   }];
    
}


- (IBAction)signUpButtonTapped:(id)sender {
    
    
    FISCardstreamSignUpViewController *signUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"signUpVC"];
    
    signUpVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:signUpVC animated:YES completion:nil];
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
