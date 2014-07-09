//
//  TLUserDetailsManager.m
//  Tuplit
//
//  Created by ev_mac6 on 21/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLUserDetailsManager.h"
#import "TLUserDefaults.h"
#import "UserCommentsModel.h"
#import "RecentActivityModel.h"


@implementation TLUserDetailsManager

- (void)dealloc {
	
	_delegate = nil;
}

- (void)getUserDetailsWithUserID:(NSString*) userID {
	
	NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:USER_DETAILS_URL,userID]];
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"" parameters:nil];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Response %@" ,operation.responseString);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            NSDictionary *responseDictionarytoMap = [responseJSON objectForKey:strPropertyName];
            
            RKObjectMapping* userDetailsMapping = [RKObjectMapping mappingForClass:[UserModel class]];
            [userDetailsMapping addAttributeMappingsFromDictionary:@ {
                @"BuySomething": @"BuySomething",
                @"Email": @"Email",
                @"FBId": @"FBId",
                @"FirstName": @"FirstName",
                @"LastName": @"LastName",
                @"Photo": @"Photo",
                @"Platform": @"Platform",
                @"PushNotification": @"PushNotification",
                @"RecieveCredit": @"RecieveCredit",
                @"SendCredit": @"SendCredit",
                @"UserId": @"UserId",
                @"AvailableBalance":@"AvailableBalance",
                
            }];
            
            RKObjectMapping* commentsMapping = [RKObjectMapping mappingForClass:[UserCommentsModel class]];
            [commentsMapping addAttributeMappingsFromDictionary:@ {
                @"CommentId"        :   @"CommentId",
                @"CommentsText"     :   @"CommentsText",
                @"CommentDate"      :   @"CommentDate",
                @"UserPhoto"        :   @"UserPhoto",
                @"UserId"           :   @"UserId",
                @"UserName"         :   @"UserName",
                @"merchantId"       :   @"merchantId",
                @"MerchantName"     :   @"MerchantName",
                @"MerchantIcon"     :   @"MerchantIcon",
                
            }];
            
            RKObjectMapping* recentActivityMapping = [RKObjectMapping mappingForClass:[RecentActivityModel class]];
            [recentActivityMapping addAttributeMappingsFromDictionary:@ {
                @"OrderId"        :   @"OrderId",
                @"MerchantID"     :   @"MerchantID",
                @"CompanyName"    :   @"CompanyName",
                @"Location"       :   @"Location",
                @"TotalItems"     :   @"TotalItems",
                @"TotalPrice"     :   @"TotalPrice",
                @"OrderDate"      :   @"OrderDate",
                @"MerchantIcon"   :   @"MerchantIcon",
                
            }];
            
            RKObjectMapping *responseMapping2 = [RKObjectMapping mappingForClass:[UserDetailModel class]];
            [responseMapping2 addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"comments" toKeyPath:@"comments" withMapping:commentsMapping]];
            [responseMapping2 addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Orders" toKeyPath:@"Orders" withMapping:recentActivityMapping]];
            
            NSDictionary *mappingsDictionary1 = @{ @"": userDetailsMapping};
            RKMapperOperation *mapper1 = [[RKMapperOperation alloc] initWithRepresentation:[responseDictionarytoMap objectForKey:@"Details"] mappingsDictionary:mappingsDictionary1];
            
            NSDictionary *mappingsDictionary2 = @{ @"": responseMapping2};
            RKMapperOperation *mapper2 = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary2];
            
            NSError *mappingError = nil;
            
            BOOL isMapped1 = [mapper1 execute:&mappingError];
            BOOL isMapped2 = [mapper2 execute:&mappingError];
            
            if (isMapped1 && isMapped2 && !mappingError) {
                
                userModel = mapper1.mappingResult.firstObject;
                userdetailModel = mapper2.mappingResult.firstObject;
                
                if([_delegate respondsToSelector:@selector(userDetailManagerSuccess:withUser:withUserDetail:)])
                    [_delegate userDetailManagerSuccess:self withUser:userModel withUserDetail:userdetailModel];
            }
        }
        else
        {
            NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
            
            if([_delegate respondsToSelector:@selector(userDetailsManager:returnedWithErrorCode:errorMsg:)])
                [_delegate userDetailsManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        [[ProgressHud shared] hide];
        if([_delegate respondsToSelector:@selector(userDetailsManagerFailed:)])
            [_delegate userDetailsManagerFailed:self];
	}];
    
	[operation start];
}

@end
