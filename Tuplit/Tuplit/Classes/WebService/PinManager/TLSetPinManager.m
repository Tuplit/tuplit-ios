//
//  TLSetPinManager.m
//  Tuplit
//
//  Created by ev_mac11 on 02/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLSetPinManager.h"
#import "NSObject+SBJSON.h"

@implementation TLSetPinManager
- (void)dealloc {
	
	_delegate = nil;
}

- (void)updatePinCode :(NSString*)pincode
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:SET_PIN_URL]];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    NSDictionary *queryParams = @{
                                  @"PinCode"   : NSNonNilString(pincode),
                                  };
    
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
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"SetPinResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
        int code=(int)[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code==200 || code==201)
        {
            if([_delegate respondsToSelector:@selector(setPinManagerSuccess:updateSuccessfullWithUser:)])
                [_delegate setPinManagerSuccess:self updateSuccessfullWithUser:[[responseJSON objectForKey:@"notifications"]firstObject]];
        }
        else
        {
            if([_delegate respondsToSelector:@selector(setPinManager:returnedWithErrorCode:errorMsg:)])
                [_delegate setPinManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if([_delegate respondsToSelector:@selector(setPinManagerFailed:)])
            [_delegate setPinManagerFailed:self];
        
    }];
    [operation start];
}

@end
