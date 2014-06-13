//
//  TLMerchantListingManager.m
//  Tuplit
//
//  Created by ev_mac5 on 28/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLCategoryListingManager.h"
#import "CategoryModel.h"

AFHTTPRequestOperation *operation;

@implementation TLCategoryListingManager

@synthesize delegate,categoryArray,listedCount,totalCount;

- (void)dealloc {
	
	delegate = nil;
}

-(void) callService {
        
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:CATEGORY_LISTING_URL]];

    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"" parameters:nil];
    
    NSLog(@"Request : %@", [request.URL absoluteString]);
    NSLog(@"Method  : %@", request.HTTPMethod);
    
	operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		
        NSLog(@"Response :%@", responseJSON);
        
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            listedCount = [[[responseJSON objectForKey:@"meta"] objectForKey:@"listedCount"] integerValue];
            totalCount = [[[responseJSON objectForKey:@"meta"] objectForKey:@"totalCount"] integerValue];
            
            NSDictionary *responseDictionarytoMap=[responseJSON objectForKey:strPropertyName];
            
            
            
            RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[CategoryModel class]];
            [responseMapping addAttributeMappingsFromDictionary:@{
                                                                  @"CategoryId": @"CategoryId",
                                                                  @"CategoryIcon": @"CategoryIcon",
                                                                  @"CategoryName": @"CategoryName",
                                                                  @"MerchantCount": @"MerchantCount",
                                                                  }];
            
            NSDictionary *mappingsDictionary = @{ @"": responseMapping };
            RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary];
            NSError *mappingError = nil;
            BOOL isMapped = [mapper execute:&mappingError];
            if (isMapped && !mappingError) {
                
                self.categoryArray = mapper.mappingResult.array.copy;
            
                if(delegate)
                    [delegate categoryListingManager:self withCategoryList:self.categoryArray];
            }
        }
        else
        {
            NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
            if(delegate) {
                [delegate categoryListingManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
            }
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        if(delegate)
            [delegate categoryListingManager:self];
        
	}];
    
	[operation start];
}

-(void) cancelRequest {
    
    [operation cancel];
}

@end
