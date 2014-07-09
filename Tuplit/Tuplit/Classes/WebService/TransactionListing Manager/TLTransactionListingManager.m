//
//  TLTransactionListingManager.m
//  Tuplit
//
//  Created by ev_mac11 on 23/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLTransactionListingManager.h"


@implementation TLTransactionListingManager
@synthesize delegate,listedCount,totalCount;

- (void)dealloc {
	
	delegate = nil;
}
-(void) callService:(NSString*)userId withStartCount:(int)start
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:TRANSACTION_LISTING_URL]];
    
    NSDictionary *queryParams = @{
//                                  @"UserId": NSNonNilString(userId),
//                                  @"Type": NSNonNilString(@"1"),
                                  @"Start":NSNonNilString([NSString stringWithFormat:@"%d",start]),
                                  };
    
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
		
        NSLog(@"Response: %@", operation.responseString);
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
            listedCount = [[[responseJSON objectForKey:@"meta"] objectForKey:@"listedCount"] integerValue];
            totalCount = [[[responseJSON objectForKey:@"meta"] objectForKey:@"totalCount"] integerValue];
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            NSDictionary *responseDictionarytoMap=[responseJSON objectForKey:strPropertyName];
            
            RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[RecentActivityModel class]];
            [responseMapping addAttributeMappingsFromDictionary:@ {
                @"OrderId"        :   @"OrderId",
                @"MerchantID"     :   @"MerchantID",
                @"CompanyName"    :   @"CompanyName",
                @"Location"       :   @"Location",
                @"Icon"           :   @"Icon",
                @"TotalItems"     :   @"TotalItems",
                @"TotalPrice"     :   @"TotalPrice",
                @"OrderDate"      :   @"OrderDate",
                @"MerchantIcon"   :   @"MerchantIcon",
                
            }];
            NSDictionary *mappingsDictionary = @{ @"": responseMapping };
            RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary];
            NSError *mappingError = nil;
            BOOL isMapped = [mapper execute:&mappingError];
            if (isMapped && !mappingError) {
                
                self.trancactionlist = mapper.mappingResult.array.copy;
                
                if(delegate)
                    [delegate transactionListingManagerSuccess:self withTrancactionListingManager:self.trancactionlist];
            }
            else
            {
                NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
                if(delegate)
                {
                    [delegate transactionListingManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
                }
            }


        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        if(delegate)
            [delegate transactionListingManagerFailed:self];
        
	}];
    [operation start];
     
}

@end
