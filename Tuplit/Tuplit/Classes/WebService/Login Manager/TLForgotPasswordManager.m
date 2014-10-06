//
//  TLForgotPasswordManager.m
//  Tuplit
//
//  Created by ev_mac1 on 13/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLForgotPasswordManager.h"

@implementation TLForgotPasswordManager

- (void)dealloc {
	
	_delegate = nil;
}

- (void)forgotPasswordForEmail:(NSString*)email {
	
    NSString *strServerURL = FORGOT_PW_URL;
    strServerURL = [strServerURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSURL *URL = [NSURL URLWithString:strServerURL];
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    
    NSDictionary *queryParams = @{
                                  @"Email" : NSNonNilString(email),
                                  };
    
    NSMutableURLRequest *request;
    
    request = [client requestWithMethod:@"GET" path:@"" parameters:queryParams];
    
 	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"ForgotPasswordResponsetime = %f",ellapsedSeconds);
        
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
            NSLog(@"Success: %@", responseJSON);
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            NSDictionary *resDict = [responseJSON objectForKey:strPropertyName];
            [UIAlertView alertViewWithMessage:resDict[@"message"]];
            
            if([_delegate respondsToSelector:@selector(forgotPasswordManagerSuccess:)])
                [_delegate forgotPasswordManagerSuccess:self];
            else
                [_delegate forgotPasswordManagerFailed:self];
        }
        else
        {
            NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
            NSLog(@"error id %@" ,responseJSON);
            
            if([_delegate respondsToSelector:@selector(forgotPasswordManager:returnedWithErrorCode:errorMsg:)])
                [_delegate forgotPasswordManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        [[ProgressHud shared] hide];
		NSLog(@"Failure: %@", error);
        [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
        if([_delegate respondsToSelector:@selector(forgotPasswordManagerFailed:)])
            [_delegate forgotPasswordManagerFailed:self];
        
	}];
    
	[operation start];
}

@end
