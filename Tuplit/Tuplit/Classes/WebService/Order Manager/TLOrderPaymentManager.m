//
//  TLOrderPaymentManager.m
//  Tuplit
//
//  Created by ev_mac11 on 08/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLOrderPaymentManager.h"

@implementation TLOrderPaymentManager

- (void)dealloc {
	
	_delegate = nil;
}

-(void)callService:(NSDictionary*)queryParams
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:ORDER_PAYMENT_URL]];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"" parameters:queryParams];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"OrderPaymentResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
        int code=(int)[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code==200 || code==201)
        {
            [_delegate orderPaymentManagerSuccessfull:self withStatus:[[responseJSON objectForKey:@"notifications"]firstObject]];
        }
        else
        {
            [_delegate orderPaymentManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_delegate orderPaymentManagerFailed:self];
        
    }];
    [operation start];
}


@end
