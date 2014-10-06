//
//  TLCreditCardListingManager.m
//  Tuplit
//
//  Created by ev_mac11 on 07/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLCreditCardListingManager.h"
#import "CreditCardModel.h"

@implementation TLCreditCardListingManager
@synthesize delegate;

- (void)dealloc {
	
	delegate = nil;
}
-(void) callService:(int)start
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ADD_CREDITCARD_URL]];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"" parameters:nil];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *startTime=[NSDate date];
    NSLog(@"startTime = %@",startTime);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:startTime];
        NSLog(@"CreditCardListingResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		
        NSLog(@"Response: %@", responseJSON);
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
//            listedCount = [[[responseJSON objectForKey:@"meta"] objectForKey:@"listedCount"] integerValue];
//            totalCount = [[[responseJSON objectForKey:@"meta"] objectForKey:@"totalCount"] integerValue];
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            NSDictionary *responseDictionarytoMap=[responseJSON objectForKey:strPropertyName];
            
            RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[CreditCardModel class]];
            [responseMapping addAttributeMappingsFromDictionary:@ {
                @"Id"               :   @"Id",
                @"CardNumbar"       :   @"CardNumber",
                @"CardType"         :   @"CardType",
                @"ExpirationDate"   :   @"ExpirationDate",
                @"Currency"         :   @"Currency",
                
            }];
            NSDictionary *mappingsDictionary = @{ @"": responseMapping };
            RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary];
            NSError *mappingError = nil;
            BOOL isMapped = [mapper execute:&mappingError];
            
            if (isMapped && !mappingError) {
                [delegate creditCardListManagerSuccessfull:self withCreditCardList:mapper.mappingResult.array.copy];
            }
        }
        else
        {
            NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
            if([delegate respondsToSelector:@selector(creditCardListManager:returnedWithErrorCode:errorMsg:)])
                [delegate creditCardListManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
            
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        if([delegate respondsToSelector:@selector(creditCardListanagerFailed:)])
            [delegate creditCardListanagerFailed:self];
	}];
    [operation start];
    
}

@end
