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

@interface FISCardstreamLogInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (nonatomic) FISStreamsDataManager *dataManager;
@property (nonatomic) FISStream *streamToPass;

@end

@implementation FISCardstreamLogInViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [FISStreamsDataManager sharedDataManager];

    self.usernameTextField.delegate = self;
    self.backgroundImage.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}

#pragma mark - textfield
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.usernameTextField resignFirstResponder];
    return YES;
}


#pragma mark - UIButton Actions


- (IBAction)logInButtonTapped:(id)sender {
    
    [self checkForUsernameAndLogUserIn];
    
}


- (IBAction)signUpButtonTapped:(id)sender {
    
    FISCardstreamSignUpViewController *signUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"signUpVC"];
        
    signUpVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    signUpVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    

    
    [self presentViewController:signUpVC animated:YES completion:nil];
}


#pragma mark - View helper

-(void)takeMeToHomePage
{
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initialVC = [myStoryboard instantiateInitialViewController];
    
    [self presentViewController:initialVC animated:YES completion:nil];
    
    UIApplication *application = [UIApplication sharedApplication];
    [application.keyWindow setRootViewController:initialVC];
}


-(void)dismissKeyboard {
    [self.usernameTextField resignFirstResponder];
}



#pragma mark - UIButton Helper Methods

- (void)checkForUsernameAndLogUserIn {
    
    [FISCardStreamsAPIClient getAllStreamsAndCheckWithUsername:self.usernameTextField.text CompletionBlock:^(FISStream *stream) {
        
        self.streamToPass = stream;
        NSLog(@"Logged In");
        self.dataManager.userStream = self.streamToPass;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:self.usernameTextField.text forKey:@"fisdev_username"];

        
        [self takeMeToHomePage];
        
    } SecondCompletionBlock:^(BOOL unique) {
        
        if (!unique)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log in failed"
                                                            message:@"Username doesn't match"
                                                           delegate:self
                                                  cancelButtonTitle:@"Try Again"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }];
}


@end
