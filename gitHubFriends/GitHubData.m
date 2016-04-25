//
//  GitHubData.m
//  gitHubFriends
//
//  Created by Tom Williamson on 4/25/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

#import "GitHubData.h"

@interface GitHubData ()<NSURLSessionDelegate>


@end

@implementation GitHubData


//
//  build a url request and start the request
//
-(void)startRequest:(NSString*)req delegate:(id<GitHubDataDelegate>) delegate; {
    
    self.reqText = req;
    self.delegate = delegate;
    
    if (![req hasPrefix:@"https://"])
        self.reqText = [NSString stringWithFormat:@"https://api.github.com/%@", req];
    NSURL* url = [NSURL URLWithString:self.reqText];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithURL:url];
    [dataTask resume];
    
}

#pragma mark NSURLSessionDelegate

//
//  we are finished.  Make the callback to indicate that we are done
//
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    
    if(!error && self.rawData){
        self.dictionary = [NSJSONSerialization JSONObjectWithData:self.rawData options:NSJSONReadingMutableLeaves error:nil];
        [self.delegate gotGitHubData];
    }
    
}

//
//  collect raw data
//
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    
    if(!self.rawData){
        self.rawData = [[NSMutableData alloc] initWithData:data];
    } else {
        [self.rawData appendData:data];
    }
    
}


//
//
//
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}



@end
