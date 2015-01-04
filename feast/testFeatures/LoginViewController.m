//
//  LoginViewController.m
//  testFeatures
//
//  Created by Jeffrey Shih on 11/30/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "LoginViewController.h"
#import "MainNavController.h"
#import <Parse/Parse.h>

@interface LoginViewController () 
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UITextField *userField;
@property (strong, nonatomic) IBOutlet UITextField *passField;
@property (strong, nonatomic) IBOutlet UIButton *resetPassButt;
@property (strong, nonatomic) IBOutlet UIButton *regButton;


@property(nonatomic, readonly) NSArray *textFields;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userField.delegate = self;
    self.passField.delegate = self;

    // Do any additional setup after loading the view.
    
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1]];
    
    
    self.loginButton.layer.cornerRadius = 2;
    self.loginButton.layer.borderWidth = 2;
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.regButton.layer.cornerRadius = 2;
    self.regButton.layer.borderWidth = 2;
    self.regButton.layer.borderColor = [UIColor whiteColor].CGColor;
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tap];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginPress:(id)sender {
    
    NSString*username = self.userField.text;
    NSString*pass = self.passField.text;
    
    
    [PFUser logInWithUsernameInBackground:username password:pass
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
                                        } else {
                                            // The login failed. Check error to see why.
                                            
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



- (IBAction)goRegister:(id)sender {
    
    [self performSegueWithIdentifier:@"regSegue" sender:nil];

    
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    if (textField == self.userField){
        [self.passField becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }
    return NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}


@end
