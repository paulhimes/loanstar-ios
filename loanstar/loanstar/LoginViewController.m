//
//  LoginViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "LoginViewController.h"
#import "UserAccount.h"
#import "ServerAdapter.h"
#import "MockServerAdapter.h"

@interface LoginViewController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
//    if (currentUserId) {
//        [self performSegueWithIdentifier:@"QuickLogin" sender:nil];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
}

#pragma mark - Login methods

- (IBAction)loginAction:(id)sender
{
    UserAccount *userAccount = [[UserAccount alloc] init];
    userAccount.email = self.emailField.text;
    userAccount.hashedPassword = [self hashString:[NSString stringWithFormat:@"%@:%@", self.emailField.text, self.passwordField.text]];

    UserAccount *confirmedUserAccount = [ServerAdapter loginWithUserAccount:userAccount];
    
    if ([confirmedUserAccount.userId length] <= 0) {
        // Handle the error.
        NSLog(@"Login Failed");
    } else {
        // Success
        [UserAccount setCurrentUserAccount:confirmedUserAccount];
        [self performSegueWithIdentifier:@"Login" sender:nil];
    }

}

- (IBAction)createAction:(id)sender
{
    // Ask for a display name
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What is your name?"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Login"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *displayName = [alertView textFieldAtIndex:0].text;
    
    if ([displayName length] > 0) {
        UserAccount *userAccount = [[UserAccount alloc] init];
        userAccount.email = self.emailField.text;
        userAccount.hashedPassword = [self hashString:[NSString stringWithFormat:@"%@:%@", self.emailField.text, self.passwordField.text]];
        userAccount.displayName = displayName;
        
        UserAccount *confirmedUserAccount = [ServerAdapter createUserAccount:userAccount];
        
        if ([confirmedUserAccount.userId length] <= 0) {
            // Handle the error.
            NSLog(@"Create User Account Failed");
        } else {
            // Success
            [UserAccount setCurrentUserAccount:confirmedUserAccount];
            [self performSegueWithIdentifier:@"Login" sender:nil];
        }
    }
}

- (NSString*)hashString:(NSString*)plaintext
{
    // Don't tell the security guys about this one...
    return [@([plaintext hash]) stringValue];
}


@end
