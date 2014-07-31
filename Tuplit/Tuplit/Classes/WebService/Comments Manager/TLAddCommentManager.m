//
//  TLAddCommentManager.m
//  Tuplit
//
//  Created by ev_mac11 on 01/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLAddCommentManager.h"

@implementation TLAddCommentManager
- (void)dealloc {
	
	_delegate = nil;
}

- (void)addComment:(NSDictionary*)queryParam
{
    NSString *strServerURL = [NSString stringWithFormat:COMMENT_LISTING_URL];
    strServerURL = [strServerURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSURL *URL = [NSURL URLWithString:strServerURL];
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"" parameters:queryParam];
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
            if([_delegate respondsToSelector:@selector(commentAddManagerSuccess:)])
                [_delegate commentAddManagerSuccess:self];
        }
        else
        {
            if([_delegate respondsToSelector:@selector(commentAddManager:returnedWithErrorCode:errorMsg:)])
                [_delegate commentAddManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([_delegate respondsToSelector:@selector(commentAddManagerFailed:)])
            [_delegate commentAddManagerFailed:self];
        
	}];
    [operation start];
    
}

@end
