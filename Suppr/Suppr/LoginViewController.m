//
//  LoginViewController.m
//  Suppr
//
//  Created by Jeffrey Shih on 11/13/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "LoginViewController.h"
#import "NewUserViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *userField;
@property (strong, nonatomic) IBOutlet UITextField *passField;
@property (strong, nonatomic) IBOutlet UIButton *logButton;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UIButton *regButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:1]];
    
    
    self.logButton.layer.cornerRadius = 2;
    self.logButton.layer.borderWidth = 2;
    self.logButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.regButton.layer.cornerRadius = 2;
    self.regButton.layer.borderWidth = 2;
    self.regButton.layer.borderColor = [UIColor whiteColor].CGColor;
    // Do any additional setup after loading the view.
}

- (IBAction)login:(id)sender {
    
    [self.view endEditing:YES];
    
    
    [PFUser logInWithUsernameInBackground:[self.userField text] password:[self.passField text]
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                        } else {
                                            
                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Input"
                                                                                                           message:@"Username/Password incorrect!"
                                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                            
                                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                             handler:^(UIAlertAction *action) {
                                                                                                 NSLog(@"Action selected: %@", action.title);
                                                                                             }];
                                            [alert addAction:okAction];
                                            
                                            [self presentViewController:alert animated:YES completion:nil];
                                                                                }
                                    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUp:(id)sender {
    [self presentNewUserViewController];
}

-(void) presentNewUserViewController{
    NewUserViewController *viewController =
    [[NewUserViewController alloc] initWithNibName:nil
                                               bundle:nil];
    viewController.delegate = self;
    [self.navigationController presentViewController:viewController
                                            animated:YES
                                          completion:nil];
}

- (void)presentLoginViewController {
    // Go to the welcome screen and have them log in or create an account.
    LoginViewController *viewController =
    [[LoginViewController alloc] initWithNibName:nil
                                             bundle:nil];
    viewController.delegate = self;
    [self.navigationController setViewControllers:@[ viewController ]
                                         animated:NO];
}

- (void)newUserViewControllerDidSignup:(NewUserViewController *)controller {
    // Sign up successful
    [self.delegate loginViewControllerDidLogin:self];

}

- (IBAction)reset:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset Password"
                                                                   message:@"Enter the email address for your account."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Email", @"Login");
     }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [PFUser requestPasswordResetForEmailInBackground:alert.textFields.firstObject];

                               }];
    
    UIAlertAction *cancel = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                   }];

    
    [alert addAction:okAction];
    [alert addAction:cancel];

    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)processFieldEntries {
    // Get the username text, store it in the app delegate for now
    NSString *username = self.userField.text;
    NSString *password = self.passField.text;
    NSString *noUsernameText = @"username";
    NSString *noPasswordText = @"password";
    NSString *errorText = @"No ";
    NSString *errorTextJoin = @" or ";
    NSString *errorTextEnding = @" entered";
    BOOL textError = NO;
    
    // Messaging nil will return 0, so these checks implicitly check for nil text.
    if (username.length == 0 || password.length == 0) {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
        if (password.length == 0) {
            [self.passField becomeFirstResponder];
        }
        if (username.length == 0) {
            [self.userField becomeFirstResponder];
        }
    }
    
    if ([username length] == 0) {
        textError = YES;
        errorText = [errorText stringByAppendingString:noUsernameText];
    }
    
    if ([password length] == 0) {
        textError = YES;
        if ([username length] == 0) {
            errorText = [errorText stringByAppendingString:errorTextJoin];
        }
        errorText = [errorText stringByAppendingString:noPasswordText];
    }
    
    if (textError) {
        errorText = [errorText stringByAppendingString:errorTextEnding];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    self.activityViewVisible = YES;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        // Tear down the activity view in all cases.
        self.activityViewVisible = NO;
        
        if (user) {
            [self.delegate loginViewControllerDidLogin:self];
        } else {
            // Didn't get a user.
            NSLog(@"%s didn't get a user!", __PRETTY_FUNCTION__);
            
            NSString *alertTitle = nil;
            
            if (error) {
                // Something else went wrong
                alertTitle = [error userInfo][@"error"];
            } else {
                // the username or password is probably wrong.
                alertTitle = @"Couldn’t log in:\nThe username or password were wrong.";
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            
            // Bring the keyboard back up, because they'll probably need to change something.
            [self.userField becomeFirstResponder];
        }
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
