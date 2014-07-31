//
//  TLCreditCardDeleteManager.m
//  Tuplit
//
//  Created by ev_mac11 on 09/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLCreditCardDeleteManager.h"

@implementation TLCreditCardDeleteManager


- (void)dealloc {
	
	_delegate = nil;
}

- (void)deleteCreditCard:(NSString*)cardID;
{
    NSString *strServerURL = [NSString stringWithFormat:DELETE_CREDITCARD_URL,cardID];
    strServerURL = [strServerURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSURL *URL = [NSURL URLWithString:strServerURL];
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    NSMutableURLRequest *request = [client requestWithMethod:@"DELETE" path:@"" parameters:nil];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"Request : %@", [request.URL absoluteString]);
    NSLog(@"Method  : %@", request.HTTPMethod);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		
        NSLog(@"Response: %@", responseJSON);
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code==200 || code==201)
        {
            [_delegate creditCardDeleteManagerSuccess:self];
        
        }
        else
        {
            [_delegate creditCardDeleteManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_delegate creditCardDeleteManagerFailed:self];
        
	}];
    [operation start];
    
}


@end