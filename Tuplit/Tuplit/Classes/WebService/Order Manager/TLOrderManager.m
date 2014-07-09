//
//  TLOrderManager.m
//  Tuplit
//
//  Created by ev_mac11 on 01/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLOrderManager.h"
#import "NSObject+SBJSON.h"

@implementation TLOrderManager

- (void)dealloc {
	
	_delegate = nil;
}

-(void)processOrders:(NSDictionary*) queryParams{
    
    NSLog(@"QueryParams : %@",queryParams);
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:ORDERS_URL]];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    NSMutableURLRequest *request = [client requestWithMethod:@"PUT" path:@"" parameters:queryParams];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    NSString * strValue = [queryParams JSONRepresentation];
    NSData *postData = [strValue dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
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
            if (_delegate)
               [_delegate processOrdersManagerSuccessfull:self withorderStatus:[queryParams objectForKey:@"OrderStatus"] orderId:[queryParams objectForKey:@"OrderId"] ];
        }
        else
        {
            if (_delegate)
               [_delegate processOrdersManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		[_delegate processOrdersManagerFailed:self];
        
	}];
    
	[operation start];
}

@end
