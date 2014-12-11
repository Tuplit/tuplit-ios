//
//  MGCUpadateBatchCount.m
//  TiltSDK
//
//  Created by ev_mac13 on 22/05/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "RefreshBatchCount.h"
#import "NSObject+SBJSON.h"

@implementation RefreshBatchCount
@synthesize delegate;


-(void)updateBadgeCount
{
    NSURL *URL = [NSURL URLWithString:REFRESH_BADGE_COUNT_URL];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    
    
    NSDictionary *queryParams = [NSDictionary dictionaryWithObjectsAndKeys:[TLUserDefaults getDeviceToken],@"DeviceToken",nil];
    
    NSLog(@"Request URL : %@",[URL absoluteString]);
    NSLog(@"Parameters : %@",queryParams);
    
    NSMutableURLRequest *request = [client requestWithMethod:@"PUT" path:@"" parameters:queryParams];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    NSString * strValue = [queryParams JSONRepresentation];
    NSData *postData = [strValue dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
  	[operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"eResponse: %@", responseJSON);
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
		//[_delegate userDetailsManagerFailed:self];
        
	}];
    
	[operation start];
}


@end
