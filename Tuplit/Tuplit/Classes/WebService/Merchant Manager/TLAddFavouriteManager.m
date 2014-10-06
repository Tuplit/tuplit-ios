//
//  TLAddFavouriteManager.m
//  Tuplit
//
//  Created by ev_mac11 on 03/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLAddFavouriteManager.h"

@implementation TLAddFavouriteManager

- (void)dealloc {
	
	_delegate = nil;
}

-(void)callService:(NSDictionary*)queryParams
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ADD_FAVOURITE_URL]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"" parameters:queryParams];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"Request : %@", [request.URL absoluteString]);
    NSLog(@"Method  : %@", request.HTTPMethod);
    NSLog(@"QueryParams : %@",queryParams);
    
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"AddFavouriteResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"Response : %@",responseJSON);
        
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code==200 || code==201)
        {
            if ([_delegate respondsToSelector:@selector(addFavouriteManagerSuccessfull:)])
                [_delegate addFavouriteManagerSuccessfull:self];
        }
        else
        {
            if ([_delegate respondsToSelector:@selector(addFavouriteManager:returnedWithErrorCode:errorMsg:)])
                [_delegate addFavouriteManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if ([_delegate respondsToSelector:@selector(addFavouriteManagerFailed:)])
            [_delegate addFavouriteManagerFailed:self];
	}];
    
	[operation start];
}
@end
