//
//  TLLoginManager.m
//  Tuplit
//
//  Created by ev_mac6 on 28/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLLoginManager.h"
#define PARAM_DEVICE_TOKEN                      @"DeviceToken"
#define PARAM_DTOKEN                            @"Token"
#define PARAM_PLATFORM                          @"Platform"

@implementation TLLoginManager

- (void)dealloc {
	
	_delegate = nil;
}

- (void)loginUserUsingSocialNW:(BOOL)isSocialNW {
	
    NSString *strServerURL = LOGIN_URL;
    strServerURL = [strServerURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSURL *URL = [NSURL URLWithString:strServerURL];
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];

    NSData *profilePicture;
    
    if(self.user.userImageData != NULL)
        profilePicture = self.user.userImageData;
    else if (self.user.userImage != nil)
        profilePicture=UIImageJPEGRepresentation(self.user.userImage, 0.65);
    
    if(isSocialNW)
    {
        self.user.Password = @"";
    }
    
    NSDictionary *queryParams = @{
                                  @"Email"            : NSNonNilString(self.user.Email),
                                  @"Password"         : NSNonNilString(self.user.Password),
                                  @"ClientId"         : CLIENTID,
                                  @"ClientSecret"     : CLIENT_SECRET_ID,
                                  @"GooglePlusId"     : NSNonNilString(self.user.GooglePlusId),
                                  @"FBId"             : NSNonNilString(self.user.FBId),
                                  @"DeviceToken"      : NSNonNilString([TLUserDefaults getDeviceToken]),
                                  @"Token"            : NSNonNilString([TLUserDefaults getDeviceToken]),
                                  @"UserData"         : [UIDevice currentDevice].systemVersion,
                                  @"Platform"         : @"ios",
                                  };
    NSMutableURLRequest *request;
    
    if(profilePicture.length > 0) {
        
        request = [client multipartFormRequestWithMethod:@"POST" path:@"" parameters:queryParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:profilePicture name:@"Photo" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        }];
        
    } else {
        
        request = [client requestWithMethod:@"POST" path:@"" parameters:queryParams];
    }
   
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
     NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);

        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"LoginMaangerResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        int code=(int)[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            NSDictionary *responseDictionarytoMap=[responseJSON objectForKey:strPropertyName];
            
            RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[UserModel class]];
            [responseMapping addAttributeMappingsFromDictionary:@{
                                                                  @"UserId"     : @"UserId",
                                                                  @"AccessToken": @"AccessToken",                                                                  }];
            
            NSDictionary *mappingsDictionary = @{ @"": responseMapping };
            RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary];
            NSError *mappingError = nil;
            BOOL isMapped = [mapper execute:&mappingError];
            if (isMapped && !mappingError) {
                self.user = mapper.mappingResult.firstObject;
                
                if([_delegate respondsToSelector:@selector(loginManager:loginSuccessfullWithUser:)])
                    [_delegate loginManager:self loginSuccessfullWithUser:self.user];
            }
        }
        else if(code)
        {
            NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
            
            if([_delegate respondsToSelector:@selector(loginManager:returnedWithErrorCode:errorMsg:)])
                [_delegate loginManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        [[ProgressHud shared] hide];
        [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
        if([_delegate respondsToSelector:@selector(loginManagerLoginFailed:)])
            [_delegate loginManagerLoginFailed:self];
        
	}];
    
	[operation start];
}

@end
