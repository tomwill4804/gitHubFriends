//
//  Friend.m
//  gitHubFriends
//
//  Created by Tom Williamson on 4/25/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

#import "Friend.h"

@implementation Friend

//
//  create a Friend object using passed dictionary
//
+ (Friend *)friendWithDictionary:(NSDictionary *)friendDict
{
    Friend* friend = nil;
    if (friendDict) {
        friend = [[Friend alloc] init];
        
        friend.userid = friendDict[@"login"];
        friend.attributes = friendDict;
    }
    
    return friend;
    
}


@end
