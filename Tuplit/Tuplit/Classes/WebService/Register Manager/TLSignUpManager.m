//
//  TLSignUpManager.m
//  Tuplit
//
//  Created by ev_mac6 on 28/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLSignUpManager.h"

@implementation TLSignUpManager

- (void)dealloc {
	
	_delegate = nil;
}

- (void)registerUser {
	
    NSString *strServerURL = REGISTER_URL;
    strServerURL = [strServerURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSURL *URL = [NSURL URLWithString:strServerURL];
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    
    
    NSData *profilePicture;
    
//    if(self.user.userImageData != NULL)
//        profilePicture = self.user.userImageData;
//    else
    
    if (self.user.userImage != nil) {
        
        self.user.userImage = [self.user.userImage imageByScalingAndCroppingForSize:CGSizeMake(120, 120)];
        profilePicture=UIImageJPEGRepresentation(self.user.userImage, 0.65);
    }
    
    NSDictionary *queryParams = @{
                                  @"UserName"       : NSNonNilString(self.user.UserName),
                                  @"FirstName"      : NSNonNilString(self.user.FirstName),
                                  @"LastName"       : NSNonNilString(self.user.LastName),
                                  @"Email"          : NSNonNilString(self.user.Email),
                                  @"Password"       : NSNonNilString(self.user.Password),
                                  @"Zipcode"        : NSNonNilString(self.user.ZipCode),
                                  @"Country"        : NSNonNilString(self.user.Country),
                                  @"PinCode"        : NSNonNilString(self.user.PinCode),
                                  @"FBId"           : NSNonNilString(self.user.FBId),
                                  @"GooglePlusId"   : NSNonNilString(self.user.GooglePlusId),
                                  @"Platform"       : @"ios",
//                                  @"CellNumber"     : NSNonNilString(self.user.CellNumber),
                                  @"Location"       : NSNonNilString(self.user.Location)
                                  };
    
    NSLog(@"Input = %@", queryParams);
    NSMutableURLRequest *request;
    
    if(profilePicture.length > 0) {
        
        request = [client multipartFormRequestWithMethod:@"POST" path:@"" parameters:queryParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:profilePicture name:@"Photo" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        }];
        
    } else {
        
        request = [client requestWithMethod:@"POST" path:@"" parameters:queryParams];
    }
    
	[request setURL:URL];
	[request setTimeoutInterval:60.0];
	[request setHTTPMethod:@"POST"];
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
  	[operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation.responseString);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            NSDictionary *responseDictionarytoMap=[responseJSON objectForKey:strPropertyName];
            
            NSLog(@"Success: %@", responseJSON);
            
            RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[UserModel class]];
            [responseMapping addAttributeMappingsFromDictionary:@{
                                                                  @"UserId": @"UserId",
                                                                  @"UserName":@"UserName",
                                                                  @"FirstName":@"FirstName",
                                                                  @"LastName":@"LastName",
                                                                  @"Email":@"Email",
                                                                  @"FBId":@"FBId",
                                                                  @"ZipCode":@"ZipCode",
                                                                  @"Country":@"Country",
                                                                  @"Platform":@"Platform",
                                                                  @"PushNotification":@"PushNotification",
                                                                  @"Platform":@"Platform",
                                                                  @"SendCredit":@"SendCredit",
                                                                  @"RecieveCredit":@"RecieveCredit",
                                                                  @"BuySomething":@"BuySomething",
                                                                  @"Photo":@"userImageUrl",
                                                                  }];
            
            NSDictionary *mappingsDictionary = @{ @"": responseMapping };
            RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary];
            NSError *mappingError = nil;
            BOOL isMapped = [mapper execute:&mappingError];
            if (isMapped && !mappingError) {
                self.user = mapper.mappingResult.firstObject;
                [Global instance].user = self.user;
                
                NSLog(@"Register Success: %@", self.user);
                if([_delegate respondsToSelector:@selector(signUpManager:registerSuccessfullWithUser:isAlreadyRegistered:)])
                    [_delegate signUpManager:self registerSuccessfullWithUser:self.user isAlreadyRegistered:NO];
            }
        }
        else
        {
            NSLog(@"error id %@" ,responseJSON);
            if([_delegate respondsToSelector:@selector(signUpManager:returnedWithErrorCode:errorMsg:)])
                [_delegate signUpManager:self returnedWithErrorCode:[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        [[ProgressHud shared] hide];
		NSLog(@"Failure: %@", error);
        
        [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
        if([_delegate respondsToSelector:@selector(signUpManagerFailed:)])
            [_delegate signUpManagerFailed:self];
        
	}];
    
	[operation start];
}

@end
