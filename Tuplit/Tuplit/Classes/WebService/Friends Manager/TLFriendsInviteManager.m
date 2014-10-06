//
//  TLInviteListingManager.m
//  Tuplit
//
//  Created by ev_mac14 on 17/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLFriendsInviteManager.h"

@implementation TLFriendsInviteManager

- (void)dealloc {
	
	_delegate = nil;
}
-(void)callService:(NSDictionary*)queryParams;
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:INVITE_FRIENDS_URL]];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"" parameters:queryParams];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"Request : %@", [request.URL absoluteString]);
    NSLog(@"Method  : %@", request.HTTPMethod);
        
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"FriendsInviteResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		
        NSLog(@"Response: %@", responseJSON);
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
            [_delegate inviteManagerSuccess:self withinviteStatus:[[responseJSON objectForKey:@"notifications"]firstObject]];
        }
        else
        {
            NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
            [_delegate inviteManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        [_delegate inviteManagerFailed:self];
        
	}];
    [operation start];
    
}

@end
