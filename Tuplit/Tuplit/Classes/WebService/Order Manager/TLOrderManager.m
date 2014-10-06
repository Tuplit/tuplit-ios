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
    
   
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:ORDERS_URL]];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    NSMutableURLRequest *request = [client requestWithMethod:@"PUT" path:@"" parameters:queryParams];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    NSString * strValue = [queryParams JSONRepresentation];
    NSData *postData = [strValue dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
     NSLog(@"QueryParams : %@",queryParams);
    
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"ordermanagerResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"Response : %@",responseJSON);
        
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code==200 || code==201)
        {
            if ([_delegate respondsToSelector:@selector(processOrdersManagerSuccessfull:withorderStatus:orderId:)])
                [_delegate processOrdersManagerSuccessfull:self withorderStatus:[queryParams objectForKey:@"OrderStatus"] orderId:[queryParams objectForKey:@"OrderId"] ];
        }
        else
        {
            if ([_delegate respondsToSelector:@selector(processOrdersManager:returnedWithErrorCode:errorMsg:)])
                [_delegate processOrdersManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if([_delegate respondsToSelector:@selector(processOrdersManagerFailed:)])
            [_delegate processOrdersManagerFailed:self];
        
	}];
    
	[operation start];
}

@end
