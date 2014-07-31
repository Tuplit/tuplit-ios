//
//  TLVerifyPinManager.m
//  Tuplit
//
//  Created by ev_mac11 on 05/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLVerifyPinManager.h"

@implementation TLVerifyPinManager

- (void)dealloc {
	
	_delegate = nil;
}

- (void)verifyPinCode:(NSString*)pincode
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:VERIFY_PIN_URL]];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    NSDictionary *queryParams = @{
                                  @"PinCode"   : NSNonNilString(pincode),
                                  };
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"" parameters:queryParams];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"Response : %@",responseJSON);
        
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code==200 || code==201)
        {
            if([_delegate respondsToSelector:@selector(verifyPinManagerSuccessWithValue:Withnotification:)])
                [_delegate verifyPinManagerSuccessWithValue:[[responseJSON objectForKey:@"PinVerify"] valueForKey:@"PinVerify"] Withnotification:[[responseJSON objectForKey:@"notifications"]firstObject]];
        }
        else
        {
            if([_delegate respondsToSelector:@selector(verifyPinManager:returnedWithErrorCode:errorMsg:)])
                [_delegate verifyPinManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if([_delegate respondsToSelector:@selector(verifyPinManagerFailed:)])
            [_delegate verifyPinManagerFailed:self];
        
    }];
    [operation start];
}

@end
