//
//  MainViewController.m
//  testFeatures
//
//  Created by Jeffrey Shih on 11/30/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "MainViewController.h"
#import "MyTableViewController.h"
#import "AVViewController.h"
#import "LoginViewController.h"
#import "FeastTableViewController.h"
#import <Parse/Parse.h>

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UIButton *setAvailButton;
@property (strong, nonatomic) IBOutlet UIButton *viewAvailButton;
@property (strong, nonatomic) IBOutlet UINavigationItem *titleItem;
@property (strong, nonatomic) IBOutlet UIButton *removeButton;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFUser *user = [PFUser currentUser];

    if (user){
        self.navigationItem.title = @"Main";
    }
    else{
        NSLog(@"USER NOT LOGGED IN!");
    }
    
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1]];
    self.setAvailButton.layer.cornerRadius = 2;
    self.setAvailButton.layer.borderWidth = 2;
    self.setAvailButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.removeButton.layer.cornerRadius = 2;
    self.removeButton.layer.borderWidth = 2;
    self.removeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.viewAvailButton.layer.cornerRadius = 2;
    self.viewAvailButton.layer.borderWidth = 2;
    self.viewAvailButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
}

/*
- (IBAction)setActions:(id)sender {
    
    AVViewController * myvc = [[AVViewController alloc] init];
    
    [self.navigationController pushViewController:myvc animated:YES];

}*/

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self presentViewController:lvc animated:YES completion:nil];
    
}

- (IBAction)getFeasts:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    FeastTableViewController *mtvc = [storyboard instantiateViewControllerWithIdentifier:@"FeastTableViewController"];
    
    [self.navigationController pushViewController:mtvc animated:YES];
    
}


-(IBAction)loadTable:(id)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    MyTableViewController *mtvc = [storyboard instantiateViewControllerWithIdentifier:@"MyTableViewController"];
    
    [self.navigationController pushViewController:mtvc animated:YES];
  //  [self presentViewController:mtvc animated:YES completion:nil];

}

- (IBAction)remove:(id)sender {
    
    PFUser * me = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"AvailablePeople"];
    [query whereKey:@"user" equalTo:me];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects){
                [object deleteInBackground];
            }
        }
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
