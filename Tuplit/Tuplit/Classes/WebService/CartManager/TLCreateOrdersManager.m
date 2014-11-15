//
//  TLCreateOrdersManager.m
//  Tuplit
//
//  Created by ev_mac14 on 18/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLCreateOrdersManager.h"
#import "JSON.h"

@implementation TLCreateOrdersManager
@synthesize delegate = _delegate;

- (void)dealloc {
	
	_delegate = nil;
}

-(void)addOrders:(NSDictionary*) queryParams{
        
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:ORDERS_URL]];
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
        NSLog(@"CreateOrderResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        NSString *orderID=[[responseJSON objectForKey:@"meta"] objectForKey:@"OrderId"];
        NSString *transID=[[responseJSON objectForKey:@"meta"] objectForKey:@"TransactionId"];
        
        if(code==200 || code==201)
        {
            if([_delegate respondsToSelector:@selector(createOrdersManagerSuccessfull:orderId:transactionID:)])
                [_delegate createOrdersManagerSuccessfull:self orderId:orderID transactionID:transID];
        }
        else
        {
            if([_delegate respondsToSelector:@selector(createOrdersManager:returnedWithErrorCode:errorMsg:)])
                [_delegate createOrdersManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if([_delegate respondsToSelector:@selector(createOrdersManagerFailed:)])
            [_delegate createOrdersManagerFailed:self];
        
	}];
    
	[operation start];
}
@end
