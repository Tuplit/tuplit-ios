//
//  TLCommentDeleteManager.m
//  Tuplit
//
//  Created by ev_mac11 on 27/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLCommentDeleteManager.h"

@implementation TLCommentDeleteManager

- (void)dealloc {
	
	_delegate = nil;
}

- (void)deleteComment:(NSString*)commentID
{
    NSString *strServerURL = [NSString stringWithFormat:COMMENT_DELETE_URL,commentID];
    strServerURL = [strServerURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSURL *URL = [NSURL URLWithString:strServerURL];
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    NSMutableURLRequest *request = [client requestWithMethod:@"DELETE" path:@"" parameters:nil];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"CommentDeleteResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        if(code==200 || code==201)
        {
            if([_delegate respondsToSelector:@selector(commentDeleteManagerSuccess:)])
            [_delegate commentDeleteManagerSuccess:self];
        }
        else
        {
            if([_delegate respondsToSelector:@selector(commentDeleteManager:returnedWithErrorCode:errorMsg:)])
            [_delegate commentDeleteManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([_delegate respondsToSelector:@selector(commentDeleteManagerFailed:)])
        [_delegate commentDeleteManagerFailed:self];
        
	}];
     [operation start];
    
}
@end
