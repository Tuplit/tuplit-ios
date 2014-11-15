//
//  TLCurrentLocationManager.m
//  Tuplit
//
//  Created by ev_mac11 on 12/09/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLCurrentLocationManager.h"
#import "NSObject+SBJSON.h"

@implementation TLCurrentLocationManager

- (void)dealloc {
	
	_delegate = nil;
}

- (void)updateCurrentLocation :(NSDictionary*)queryParams {
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:CURRENT_LOCATION_URL]];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    NSMutableURLRequest *request = [client requestWithMethod:@"PUT" path:@"" parameters:queryParams];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    NSString * strValue = [queryParams JSONRepresentation];
    NSData *postData = [strValue dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
        
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"CurLocationManagerResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code==200 || code==201)
        {
            [_delegate setCurrentLocationManagerSuccess:self withSuccessMessage:[[responseJSON objectForKey:@"notifications"]firstObject]];
        }
        else
        {
                [_delegate setCurrentLocationManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_delegate setCurrentLocationManagerFailed:self];
        
	}];
    
	[operation start];
}

@end
