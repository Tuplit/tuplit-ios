//
//  TLFriendsListingManager.m
//  Tuplit
//
//  Created by ev_mac11 on 17/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLFriendsListingManager.h"

@implementation TLFriendsListingManager


- (void)dealloc {
	
	_delegate = nil;
}
-(void)callService:(NSDictionary*)queryParams;
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:FRIENDS_LIST_URL]];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"" parameters:queryParams];
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
        
        if(code == 200 || code == 201)
        {
            _listedCount = [[[responseJSON objectForKey:@"meta"] objectForKey:@"listedCount"] integerValue];
            _totalCount = [[[responseJSON objectForKey:@"meta"] objectForKey:@"totalCount"] integerValue];
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            NSDictionary *responseDictionarytoMap=[responseJSON objectForKey:strPropertyName];
            
            RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[FriendsListModel class]];
            [responseMapping addAttributeMappingsFromDictionary:@ {
                
                @"id"            :   @"Id",
                @"FirstName"     :   @"FirstName",
                @"LastName"      :   @"LastName",
                @"Photo"         :   @"Photo",
                @"Email"         :   @"Email",
                @"FBId"          :   @"FBId",
                @"CompanyName"   :   @"CompanyName",
                
            }];
            NSDictionary *mappingsDictionary = @{ @"": responseMapping };
            RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary];
            NSError *mappingError = nil;
            BOOL isMapped = [mapper execute:&mappingError];
            
            if (isMapped && !mappingError) {
                [_delegate friendsListingManagerSuccess:self withFriendsListingManager: mapper.mappingResult.array.copy];
            }
        }
        else
        {
            NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
            [_delegate friendsListingManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        [_delegate friendsListingManagerFailed:self];
        
	}];
    [operation start];
    
}

@end
