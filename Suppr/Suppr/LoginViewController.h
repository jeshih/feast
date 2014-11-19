//
//  LoginViewController.h
//  Suppr
//
//  Created by Jeffrey Shih on 11/13/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogin:(LoginViewController *)controller;

@end

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;


@end
