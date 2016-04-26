//
//  MasterViewController.m
//  gitHubFriends
//
//  Created by Tom Williamson on 4/25/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "RepoViewController.h"
#import "Friend.h"
#import "GitHubData.h"

@interface MasterViewController() <GitHubDataDelegate> {
    
    GitHubData* githubData;
    NSMutableArray* friends;
    NSString* oldName;
    
}

@end

@implementation MasterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"GitHub Friends";
    oldName = @"";
    
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
    [githubData startRequest:@"users/tomwill4804" delegate:self];

    
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
//  we are going to detail view (dictionary for friend)
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%@", [segue identifier]);
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
       
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.friend = friends[indexPath.row];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    
    //
    //  show repo list view controller
    //
    if ([[segue identifier] isEqualToString:@"showRepo"]) {
 
        RepoViewController *controller = (RepoViewController *)[segue destinationViewController];
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
        textField.text = oldName;
    }];
    
    //
    //  create githubData object to talk to github
    //
    UIAlertAction *okAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name = ac.textFields[0].text;
        oldName = name;
        
        //
        //  check for duplicate name
        //
        BOOL dup = NO;
        for(Friend* friend in friends) {
            if ([friend.name isEqualToString:name])
                dup = YES;
        }
        if (dup)
            [self error:@"Duplicate name"];
        else {
            name = [NSString stringWithFormat:@"users/%@", name];
            githubData= [[GitHubData alloc] init];
            [githubData startRequest:name delegate:self];
        }
        
    }];
    
    [ac addAction:okAlert];
    
    //
    //  cancel actions for alert
    //
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel");
    }];
    [ac addAction:cancelAlert];
    
    //
    //  show alert
    //
    [self presentViewController:ac animated:YES completion:nil];
    
}

//
//  display an error
//
-(void)error:(NSString*) text {
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error"
                                                                message:text
                                                         preferredStyle:UIAlertControllerStyleAlert];
    //
    //  cancel actions for alert
    //
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel");
    }];
    [ac addAction:cancelAlert];
    
    //
    //  show alert
    //
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
        [self error:githubData.errorText];
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
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.textLabel.text = friend.name;
    
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
