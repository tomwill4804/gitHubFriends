//
//  Friend.h
//  gitHubFriends
//
//  Created by Tom Williamson on 4/25/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (copy, nonatomic) NSString *userid;
@property (weak, nonatomic) NSDictionary *attributes;
@property (copy, nonatomic) NSArray  *repros;

+ (Friend *)friendWithDictionary:(NSDictionary *)friendDict;


@end
