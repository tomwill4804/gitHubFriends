//
//  RepoViewController.m
//  gitHubFriends
//
//  Created by Tom Williamson on 4/25/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

#import "RepoViewController.h"
#import "GitHubData.h"

@interface RepoViewController() <GitHubDataDelegate> {
    
    NSArray *repos;
    GitHubData *githubData;
    
}

@end

@implementation RepoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    repos = [[NSArray alloc] init];
    
    //
    //  get data from github
    //
    githubData= [[GitHubData alloc] init];
    githubData.delegate = self;
    [githubData startRequest:self.friend.attributes[@"repos_url"]];


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
    //  save array of dictionaries address
    //
    if (githubData.dictionary) {
        repos = githubData.dictionary;
    }
    
    [self.tableView reloadData];
    
}


#pragma mark - Table view data source

//
//  one section
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


//
//  one row for each repo
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return repos.count;
    
}


//
//  return cell for table
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary* dict = repos[indexPath.row];
    
    cell.textLabel.text = dict[@"name"];
    
    return cell;
    
}




@end
