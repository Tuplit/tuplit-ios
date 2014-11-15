//
//  TLAppLocationController.m
//  Tuplit
//
//  Created by ev_mac11 on 12/09/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLAppLocationController.h"

#define UPDATE_TIME 60.0

@implementation TLAppLocationController

+ (id)sharedManager {
    static TLAppLocationController *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)startUpdatingLocation
{
    if(![timer isValid])
    {
        [timer invalidate];
        [self callService];
        timer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIME target:self selector:@selector(callService) userInfo:nil repeats:YES];
    }
}

-(void)stopUpdatingLocation
{
    [timer invalidate];
}

-(void)callService
{
    NETWORK_TEST_PROCEDURE

    NSDictionary *queryParams = @{
                                  @"Latitude"      : [NSString stringWithFormat:@"%lf",[CurrentLocation latitude]],
                                  @"Longitude"     : [NSString stringWithFormat:@"%lf",[CurrentLocation longitude]],
                                  };
    TLCurrentLocationManager *locationManager = [[TLCurrentLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager updateCurrentLocation:queryParams];
}

#pragma mark - TLCurrentLocationManagerDelegate
- (void)setCurrentLocationManagerSuccess:(TLCurrentLocationManager *)locationManager withSuccessMessage:(NSString *)message
{
    NSLog(@"success = %@",message);
}
- (void)setCurrentLocationManager:(TLCurrentLocationManager *)locationManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *) errorMsg
{
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)setCurrentLocationManagerFailed:(TLCurrentLocationManager *)locationManager
{
//    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

@end
