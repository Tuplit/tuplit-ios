//
//  TLSettingsManager.m
//  Tuplit
//
//  Created by ev_mac11 on 01/08/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLSettingsManager.h"
#import "NSObject+SBJSON.h"
#import "NSString+Base64.h"

@implementation TLSettingsManager

- (void)dealloc {
	
	_delegate = nil;
}

-(void)callService:(NSDictionary*)queryParams
{
    self.serviceType = [queryParams valueForKey:@"Type"];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:SETTINGS_URL]];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"PUT" path:@"" parameters:queryParams];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    
    NSString * strValue = [queryParams JSONRepresentation];
    NSData *postData = [strValue dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
     
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"SettingsResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code==200 || code==201)
        {
            if([_delegate respondsToSelector:@selector(settingsManager:updateSuccessfullWithUserSettings:)])
            [_delegate settingsManager:self updateSuccessfullWithUserSettings:[[responseJSON objectForKey:@"notifications"]firstObject]];
        }
        else
        {
            if([_delegate respondsToSelector:@selector(settingsManagererror:returnedWithErrorCode:errorMsg:)])
                [_delegate settingsManagererror:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if([_delegate respondsToSelector:@selector(settingsManagerFailed:)])
            [_delegate settingsManagerFailed:self];
        
    }];
    [operation start];
}

@end
