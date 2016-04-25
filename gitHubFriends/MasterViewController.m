//
//  MasterViewController.m
//  gitHubFriends
//
//  Created by Tom Williamson on 4/25/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Friend.h"
#import "GitHubData.h"

@interface MasterViewController() <GitHubDataDelegate> {
    
    GitHubData* githubData;
    NSMutableArray* friends;
    
}

@end

@implementation MasterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!friends) {
        friends = [[NSMutableArray alloc] init];
    }

    //
    //  create navigation bar
    //
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(GetNewFriend:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //
    //  test code
    //
    githubData= [[GitHubData alloc] init];
    githubData.delegate = self;
     [githubData startRequest:@"users/tomwill4804"];

    
}


//
//  split view controller
//
- (void)viewWillAppear:(BOOL)animated {
    
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    
}


#pragma mark - Segues

//
//  we are going to detail view
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.friend = friends[indexPath.row];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}



//
//  prompt user for new friend name
//
-(IBAction)GetNewFriend:(id)sender{
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Add a Friend"
                                                                message:@"Enter a valid github username"
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"username";
    }];
    
    //
    //  create githubData object to talk to github
    //
    UIAlertAction *okAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        githubData= [[GitHubData alloc] init];
        githubData.delegate = self;
        [githubData startRequest:ac.textFields[0].text];
        
    }];
    
    [ac addAction:okAlert];
    
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel");
    }];
    [ac addAction:cancelAlert];
    
    [self presentViewController:ac animated:YES completion:nil];
    
}

//
//  github request is done
//
-(void) gotGitHubData{

    //
    //  error returned
    //
    if (githubData.errorText) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"GitHub Error"
                                                                   message:githubData.errorText
                                                            preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    //
    //  create new friend
    //
    if (githubData.dictionary) {
        
        [friends addObject:[Friend friendWithDictionary:githubData.dictionary]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:friends.count-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    }
    
}


#pragma mark - Table View

//
//  one section
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//
//  one row for each friend
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return friends.count;
    
}

//
//  return cell for table
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Friend* friend = friends[indexPath.row];
    cell.textLabel.text = friend.userid;
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}


//
//  see what edit status is
//
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [friends removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

@end
