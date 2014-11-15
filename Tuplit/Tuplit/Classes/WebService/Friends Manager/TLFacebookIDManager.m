//
//  TLFacebookIDManager.m
//  Tuplit
//
//  Created by ev_mac14 on 17/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLFacebookIDManager.h"
#import "NSObject+SBJSON.h"
#import "NSString+Base64.h"

@implementation TLFacebookIDManager

- (void)dealloc {
	
	_delegate = nil;
}
-(void)callService:(NSDictionary*)queryParams;
{
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:CHECK_FRIENDS_URL]];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"" parameters:nil];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    NSString * strValue = [queryParams JSONRepresentation];
    NSData *postData = [strValue dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSLog(@"Request : %@", [request.URL absoluteString]);
    NSLog(@"Method  : %@", request.HTTPMethod);
        
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"FacebookIdManagerResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            NSDictionary *responseDictionarytoMap;
            if(self.isGoolge)
            {
                responseDictionarytoMap=[[responseJSON objectForKey:strPropertyName]objectForKey:@"GoogleFriends"];
            }
            else
            {
                responseDictionarytoMap=[[responseJSON objectForKey:strPropertyName]objectForKey:@"ContactFriends"];
            }
            
            RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[CheckUserModel class]];
            [responseMapping addAttributeMappingsFromDictionary:@ {
                
                @"id"                 :   @"Id",
                @"AlreadyInvited"     :   @"AlreadyInvited",
                
            }];
            NSDictionary *mappingsDictionary = @{ @"": responseMapping };
            RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary];
            NSError *mappingError = nil;
            BOOL isMapped = [mapper execute:&mappingError];
            
            if (isMapped && !mappingError) {
                [_delegate fbIDManagerSuccess:self withFriendsListingManager: mapper.mappingResult.array.copy];
            }
        }
        else
        {
            NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
            [_delegate fbIDManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        [_delegate fbIDManagerFailed:self];
        
	}];
    [operation start];
    
}


@end
