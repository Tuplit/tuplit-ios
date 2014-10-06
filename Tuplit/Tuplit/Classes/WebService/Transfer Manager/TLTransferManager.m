//
//  TLTransferManager.m
//  Tuplit
//
//  Created by ev_mac11 on 15/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLTransferManager.h"

@implementation TLTransferManager

- (void)dealloc {
	
	_delegate = nil;
}

-(void)callService:(NSDictionary*)queryParams
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:TRANSFER_URL]];
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
        NSLog(@"TransferResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"Response : %@",responseJSON);
        
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code==200 || code==201)
        {
            [_delegate transferManagerSuccessfull:self withStatus:[[responseJSON objectForKey:@"notifications"]firstObject]];
        }
        else
        {
            [_delegate transferManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_delegate transferManagerFailed:self];
        
    }];
    [operation start];
}


@end
