//
//  SelectionViewController.m
//  testFeatures
//
//  Created by Jeffrey Shih on 12/2/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "SelectionViewController.h"


@interface SelectionViewController ()
@property (strong, nonatomic) IBOutlet UILabel *personLabel;
@property (strong, nonatomic) IBOutlet UILabel *theirPrefLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (nonatomic, strong) UIImage *image;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString * usersname;
@property (strong, nonatomic) IBOutlet UIButton *feastButton;

@end

@implementation SelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showPhoto];

    [[self view] setBackgroundColor:[UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1]];
    
    self.feastButton.layer.cornerRadius = 2;
    self.feastButton.layer.borderWidth = 2;
    self.feastButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSLog(@"%@", [self.tableEntity objectForKey:@"Name"]);
    
    self.personLabel.text = [self.tableEntity objectForKey:@"Name"];
    self.theirPrefLabel.text = [self.tableEntity objectForKey:@"pref"];
    self.placeLabel.text = [self.tableEntity objectForKey:@"place"];
    NSLog(@"Obj id: %@", [self.tableEntity objectId]);
    // Do any additional setup after loading the view.
    
    
    //Query for user's name
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSLog(@"%@", [object objectForKey:@"name"]);
        self.usersname = [object objectForKey:@"name"];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showPhoto{ //updates Photo for entry
    
    PFQuery *query = [PFQuery queryWithClassName:@"profilepics"];
//    PFUser *user = [self.tableEntity objectForKey:@"user"];
//    NSLog(@"%@", [self.tableEntity objectForKey:@"user"]);
    [query whereKey:@"user" equalTo:[self.tableEntity objectForKey:@"user"]];
    
    NSLog(@"getting query for user");
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error){
           // NSLog(@"Obj id: %@", [object objectId]);
            PFFile *userPic = object[@"pic"];
            [userPic getDataInBackgroundWithBlock:^(NSData *imageData, NSError *errors) {
                if (!errors) {
                    self.image = [UIImage imageWithData:imageData];
                    self.imageView.image = self.image;
                }
                else{
                    NSLog(@"%@", errors);

                }
            }];
        }
        else{
            NSLog(@"%@", error);
        }
        
    }];
    
    
}



- (IBAction)takeAvail:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"AvailablePeople"];
    
    [query getObjectInBackgroundWithId:[self.tableEntity objectId] block:^(PFObject *entry, NSError *error) {
        
        entry[@"available"] = [NSNumber numberWithBool:NO];
        [entry saveInBackground];
        
    }];
    
    PFObject *feast = [PFObject objectWithClassName:@"Feast"];
    feast[@"user1"] = [PFUser   currentUser];
    feast[@"user2"] = [self.tableEntity objectForKey:@"user"];
    feast[@"name1"] = self.usersname;
    feast[@"name2"] = [self.tableEntity objectForKey:@"Name"];
    feast[@"type"] = [self.tableEntity objectForKey:@"pref"];
    feast[@"location"] = [self.tableEntity objectForKey:@"place"];
    feast[@"time"] = [self.tableEntity objectForKey:@"range"];
    [feast saveInBackground];
    
    
    [[self navigationController] popToRootViewControllerAnimated:YES];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
