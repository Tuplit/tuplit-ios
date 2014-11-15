//
//  TLEditUpdateManager.m
//  Tuplit
//
//  Created by ev_mac11 on 02/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLEditUpdateManager.h"
#import "NSObject+SBJSON.h"
#import "NSString+Base64.h"

@implementation TLEditUpdateManager

- (void)dealloc {
	
	_delegate = nil;
}

- (void)updateUser{
	   
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:REGISTER_URL]];
   
    NSData *profilePicture;
    if(self.user.userImage != nil) {
        self.user.userImage = [self.user.userImage imageByScalingAndCroppingForSize:CGSizeMake(120, 120)];
        profilePicture = UIImageJPEGRepresentation(self.user.userImage, 0.80);
    }
    else
    {
        profilePicture = nil;
    }
    
    
    NSDictionary *queryParams = @{
                                  @"FirstName"      : NSNonNilString(self.user.FirstName),
                                  @"LastName"       : NSNonNilString(self.user.LastName),
                                  @"Email"          : NSNonNilString(self.user.Email),
                                  @"Photo"          : (profilePicture!=nil)?[@"" base64EncodedStringFromData:profilePicture]:@"",
                                  @"Gender"         : NSNonNilString(self.user.Gender),
                                  @"DOB"            : NSNonNilString(self.user.DOB),
                                  };
    
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
        
        NSLog(@"EditUpdateResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        		
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
            if([_delegate respondsToSelector:@selector(editUpManager:updateSuccessfullWithUser:)])
                [_delegate editUpManager:self updateSuccessfullWithUser:self.user];
        }
        else
        {
            if([_delegate respondsToSelector:@selector(editUpManager:returnedWithErrorCode:errorMsg:)])
                [_delegate editUpManager:self returnedWithErrorCode:[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		        
        if([_delegate respondsToSelector:@selector(editUpManagerFailed:)])
            [_delegate editUpManagerFailed:self];
        
	}];
    
	[operation start];
}

@end
