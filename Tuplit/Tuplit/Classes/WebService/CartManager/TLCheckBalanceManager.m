//
//  TLCheckBalanceManager.m
//  Tuplit
//
//  Created by ev_mac14 on 18/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLCheckBalanceManager.h"

@implementation TLCheckBalanceManager
@synthesize delegate = _delegate;

- (void)dealloc {
	
	_delegate = nil;
}

-(void)getCurrentBalanceWithPaymentAmount:(NSString*)paymentAmount{
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:CHECK_BALANCE_URL]];
    
    NSDictionary *queryParams=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",paymentAmount.intValue],@"PaymentAmount",[TLUserDefaults getCurrentUser].UserId,@"UserId",nil];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"" parameters:queryParams];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
  	[operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"Response : %@",responseJSON);
        
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code==200 || code==201)
        {
            
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            NSDictionary *responseDictionarytoMap=[responseJSON objectForKey:strPropertyName];
            
            RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[PaymentModel class]];
            [responseMapping addAttributeMappingsFromDictionary:@{
                                                                  @"UserId"             : @"UserId",
                                                                  @"PaymentAmount"      : @"PaymentAmount",
                                                                  @"CurrentBalance"     : @"CurrentBalance",
                                                                  @"AllowPayment"       : @"AllowPayment",
                                                                  @"Message"            : @"Message",
                                                                  }];
            
            
            NSDictionary *mappingsDictionary = @{ @"": responseMapping };
            RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary];
            NSError *mappingError = nil;
            BOOL isMapped = [mapper execute:&mappingError];
            
            if (isMapped && !mappingError)
            {
                if([_delegate respondsToSelector:@selector(checkBalanceManagerSuccessfull:paymentModel:)])
                    [_delegate checkBalanceManagerSuccessfull:self paymentModel:mapper.mappingResult.firstObject];
            }
            
        }
        else
        {
            if([_delegate respondsToSelector:@selector(checkBalanceManager:returnedWithErrorCode:errorMsg:)])
                [_delegate checkBalanceManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([_delegate respondsToSelector:@selector(checkBalanceManagerFailed:)])
            [_delegate checkBalanceManagerFailed:self];
        
	}];
    
	[operation start];
    
}
@end
