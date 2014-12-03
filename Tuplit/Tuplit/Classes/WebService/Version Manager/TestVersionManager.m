//
//  MTLookupsContent.m
//  MotionTraxx
//
//  Created by ev_mac10 on 15/07/14.
//
//

#import "TestVersionManager.h"
#import <RestKit.h>
#import <AFNetworking.h>

#define PARAM_DEVICETYPE    @"device_type"
#define PARAM_APPTYPE       @"app_type"
#define PARAM_VERSION       @"version"
#define PARAM_BUILD         @"build"
#define PARAM_APPVERSION    [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]
#define PARAM_APPBUILD      [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey]

typedef enum
{
    Live = 1,
    Beta,
    Local
} AppType;

@implementation TestVersionManager

+ (id)sharedManager {
    static TestVersionManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

@synthesize delegate = _delegate;

- (void)dealloc {
	
	_delegate = nil;
}

-(void)validateCurrentAppVersion
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/v1/version/check?%@=1&%@=%d&%@=%@&%@=%@",RESOURCE_URL,PARAM_DEVICETYPE,PARAM_APPTYPE,Live,PARAM_VERSION,PARAM_APPVERSION,PARAM_BUILD,PARAM_APPBUILD]];//
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    
    NSMutableURLRequest *request= [client requestWithMethod:@"GET" path:@"" parameters:nil];
    request.timeoutInterval=30;
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        if(data)
        {
            NSError * error=nil;
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"%@",responseJSON);
            NSDictionary *responseDictionarytoMap=[responseJSON objectForKey:@"meta"];
            int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] intValue];
            int status_code=[[responseDictionarytoMap objectForKey:@"status_code"] intValue];
            if(code == 200)
            {
                if(status_code == 1)
                {
                   // [_delegate testVersionActionGetSuccessFully:[responseDictionarytoMap objectForKey:@"message"]];
                }
                else
                {
                   // [_delegate testVersionActionGetFailedWithErrorMessage:[responseDictionarytoMap objectForKey:@"message"]];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Test" message:[responseDictionarytoMap objectForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
            }
            else
            {
               // [_delegate testVersionActionGetFailedWithErrorMessage:[responseDictionarytoMap objectForKey:@"message"]];
            }
        }
        else
        {
//            [_delegate testVersionActionGetFailed];
        }
	}
    failure : ^(AFHTTPRequestOperation *operation, NSError *error)
     {
//         [_delegate testVersionActionGetFailed];
     }];
    
	[operation start];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(0);
}

@end
