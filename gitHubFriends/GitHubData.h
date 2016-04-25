//
//  GitHubData.h
//  gitHubFriends
//
//  Created by Tom Williamson on 4/25/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GitHubDataDelegate <NSObject>

@required
-(void)gotGitHubData;

@end

@interface GitHubData : NSObject

@property (weak, nonatomic) id<GitHubDataDelegate> delegate;

@property (copy, nonatomic) NSString* reqText;
@property (strong, nonatomic) NSMutableData* rawData;
@property (strong, nonatomic) NSDictionary *dictionary;
@property (strong, nonatomic) NSString *errorText;

-(void)startRequest:(NSString*) req;

@end
