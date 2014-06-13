//
//  TLUserDetailsManager.m
//  Tuplit
//
//  Created by ev_mac6 on 21/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLUserDetailsManager.h"
#import "TLUserDefaults.h"


@implementation TLUserDetailsManager

- (void)dealloc {
	
	_delegate = nil;
}

- (void)getUserDetails {
	
    NSString *strServerURL = USER_DETAILS_URL;
    strServerURL = [strServerURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSURL *URL = [NSURL URLWithString:strServerURL];
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    
    NSMutableURLRequest *request;
    
    NSLog(@"%@", [Global instance].user.AccessToken);
    
    request = [client requestWithMethod:@"GET" path:@"" parameters:nil];
    [request addValue:[Global instance].user.AccessToken forHTTPHeaderField:@"Authorization"];
	[request setURL:URL];
	[request setTimeoutInterval:60.0];
	[request setHTTPMethod:@"GET"];
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            NSDictionary *details = [responseJSON objectForKey:strPropertyName];
            
            UserModel *user = [UserModel new];
            user.FirstName = NSNonNilString(details[@"FirstName"]);
            user.LastName = NSNonNilString(details[@"LastName"]);
            user.userImageUrl = details[@"Photo"];
            user.AvailableBalance = details[@"AvailableBalance"];
            if([_delegate respondsToSelector:@selector(userDetailsManagerSuccess:withUser:)])
                [_delegate userDetailsManagerSuccess:self withUser:user];
        }
        else
        {
            NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
            NSLog(@"error id %@" ,responseJSON);
            
            if([_delegate respondsToSelector:@selector(userDetailsManager:returnedWithErrorCode:errorMsg:)])
                [_delegate userDetailsManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        [[ProgressHud shared] hide];
		NSLog(@"Failure: %@", error);
        [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
        if([_delegate respondsToSelector:@selector(userDetailsManagerFailed:)])
            [_delegate userDetailsManagerFailed:self];
	}];
    
	[operation start];
}

@end
