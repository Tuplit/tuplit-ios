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

- (void)registerUser:(NSString*)methodType {
	
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:REGISTER_URL]];

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
                                  @"Location"       : NSNonNilString(self.user.Location),
                                  @"Gender"         : NSNonNilString(self.user.Gender),
                                  @"DOB"            : NSNonNilString([self.user.DOB stringByTrimmingLeadingWhitespace])
                                  };
    
    NSMutableURLRequest *request;
    
    if(self.user.userImage != nil) {
        
        self.user.userImage = [self.user.userImage imageByScalingAndCroppingForSize:CGSizeMake(200, 200)];
        NSData *profilePicture = UIImageJPEGRepresentation(self.user.userImage, 0.80);
        
        request = [client multipartFormRequestWithMethod:methodType path:@"" parameters:queryParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:profilePicture name:@"Photo" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        }];
        
    } else {
        
        request = [client requestWithMethod:methodType path:@"" parameters:queryParams];
    }
    
    if([methodType isEqualToString:@"PUT"])
        [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
   
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
  	[operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"SignUpResponsetime = %f",ellapsedSeconds);
        
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
                                                                  @"Photo":@"Photo",
                                                                  @"Gender":@"Gender",
                                                                  @"DOB":@"DOB",
                                                                  }];
            
            NSDictionary *mappingsDictionary = @{ @"": responseMapping };
            RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary];
            NSError *mappingError = nil;
            BOOL isMapped = [mapper execute:&mappingError];
            if (isMapped && !mappingError) {
                self.user = mapper.mappingResult.firstObject;
        
                if([_delegate respondsToSelector:@selector(signUpManager:registerSuccessfullWithUser:isAlreadyRegistered:)])
                    [_delegate signUpManager:self registerSuccessfullWithUser:self.user isAlreadyRegistered:NO];
            }
        }
        else
        {
            if([_delegate respondsToSelector:@selector(signUpManager:returnedWithErrorCode:errorMsg:)])
                [_delegate signUpManager:self returnedWithErrorCode:[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        [[ProgressHud shared] hide];
        
        [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
        if([_delegate respondsToSelector:@selector(signUpManagerFailed:)])
            [_delegate signUpManagerFailed:self];
        
	}];
    
	[operation start];
}

@end
