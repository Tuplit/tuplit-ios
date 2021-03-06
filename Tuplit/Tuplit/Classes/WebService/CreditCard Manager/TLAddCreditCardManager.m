//
//  TLAddCreditCardManager.m
//  Tuplit
//
//  Created by ev_mac11 on 07/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLAddCreditCardManager.h"

@implementation TLAddCreditCardManager


- (void)dealloc {
	
	_delegate = nil;
}

-(void)callService:(NSDictionary*)queryParams
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:ADD_CREDITCARD_URL]];
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
        NSLog(@"AddCreditCardResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
        int code=(int)[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code==200 || code==201)
        {
            [_delegate addCreditCardManagerSuccessfull:self withStatus:[[responseJSON objectForKey:@"notifications"]firstObject]];
        }
        else
        {
            [_delegate addCreditCardManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_delegate addCreditCardManagerFailed:self];
        
    }];
    [operation start];
}


@end
