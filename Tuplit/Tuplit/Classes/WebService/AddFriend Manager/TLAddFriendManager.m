//
//  TLAddFriendManager.m
//  Tuplit
//
//  Created by ev_mac11 on 06/12/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLAddFriendManager.h"

@implementation TLAddFriendManager

- (void)dealloc {
    
    _delegate = nil;
}

-(void)callService:(NSString*)userID
{
    NSString *url = [NSString stringWithFormat:ADD_FRIEND_URL,userID];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:url]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"" parameters:nil];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"AddFavouriteResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        int code=(int)[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code==200 || code==201)
        {
                [_delegate addFriendManagerSuccessfull:self];
        }
        else
        {
                [_delegate addFriendManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_delegate addFriendManagerFailed:self];
    }];
    
    [operation start];
}

@end
