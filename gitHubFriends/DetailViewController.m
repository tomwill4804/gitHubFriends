//
//  DetailViewController.m
//  gitHubFriends
//
//  Created by Tom Williamson on 4/25/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item


- (void)viewDidLoad {
    
}


#pragma mark - Table View

//
//  one section for each dictionary entry
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.friend.attributes.count;
}

//
//  one row for each section
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

//
//  title for the section is the dictionary key
//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *keys = [self.friend.attributes allKeys];
    NSString *key = [keys objectAtIndex:section];
    return key;
    
}


//
//  return cell for table
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSArray *values = [self.friend.attributes allValues];
    NSString *value = [values objectAtIndex:indexPath.section];

    if ([value isKindOfClass:[NSString class]]) {
    }
        
    else if([value isKindOfClass:[NSNumber class]]) {
        value = [NSString stringWithFormat:@"%@", (NSNumber*)value];
    }
    else if([value isKindOfClass:[NSNumber class]]) {
        value = [NSString stringWithFormat:@"&d", (bool)value];
    }
    else
        value = @" ";
    
    cell.textLabel.text = value;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    
}



@end
