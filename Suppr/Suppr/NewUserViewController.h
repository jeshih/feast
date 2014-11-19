//
//  ViewController.h
//  Suppr
//
//  Created by Jeffrey Shih on 11/13/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class NewUserViewController;


@protocol NewUserViewControllerDelegate <NSObject>

- (void)newUserViewControllerDidSignup:(NewUserViewController *)controller;

@end

@interface NewUserViewController : UIViewController


@property (nonatomic, weak) id<NewUserViewControllerDelegate> delegate;


@end

