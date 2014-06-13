//
//  TuplitConstants.m
//  Tuplit
//
//  Created by ev_mac6 on 23/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TuplitConstants.h"
#import "TLLeftMenuViewController.h"
#import "TLMerchantsViewController.h"

@implementation TuplitConstants

NSString *LString(NSString* key) {
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:@"en"];
    NSBundle *bundle = [NSBundle bundleWithPath:[bundlePath stringByDeletingLastPathComponent]];
    return NSLocalizedStringFromTableInBundle(key, nil, bundle, nil);
}

+(void)loadSliderHomePageWithAnimation:(BOOL)animated
{
    TLLeftMenuViewController *leftMenuVC = [[TLLeftMenuViewController alloc] initWithNibName:@"TLLeftMenuViewController" bundle:nil];
	TLMerchantsViewController *merchantVC = [[TLMerchantsViewController alloc] init];
    
    UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:merchantVC];
    [slideNavigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
    [slideNavigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
	APP_DELEGATE.slideMenuController = [[RESideMenu alloc]initWithContentViewController:slideNavigationController leftMenuViewController:leftMenuVC rightMenuViewController:nil];
    APP_DELEGATE.slideMenuController.backgroundImage = [UIImage imageNamed:@"Stars"];
    APP_DELEGATE.slideMenuController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    //    APP_DELEGATE.slideMenuController.delegate = self;
    APP_DELEGATE.slideMenuController.contentViewShadowColor = [UIColor blackColor];
    APP_DELEGATE.slideMenuController.contentViewShadowOffset = CGSizeMake(0, 0);
    APP_DELEGATE.slideMenuController.contentViewShadowOpacity = 0.6;
    APP_DELEGATE.slideMenuController.contentViewShadowRadius = 12;
    APP_DELEGATE.slideMenuController.contentViewShadowEnabled = YES;
	
    [APP_DELEGATE.navigationController presentViewController:APP_DELEGATE.slideMenuController animated:animated completion:^{
        [APP_DELEGATE.navigationController popToViewController:[APP_DELEGATE.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }];
}

+(NSString*) getDistance:(double) locationDistance {
    
    NSString *distance = @"";

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingIncrement = [NSNumber numberWithDouble:0.1];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    if(locationDistance < 0.0)
    {
        distance = [NSString stringWithFormat:@"%@ m",[formatter stringFromNumber:[NSNumber numberWithDouble:locationDistance]]];
    }
    else
    {
        distance = [NSString stringWithFormat:@"%@ km",[formatter stringFromNumber:[NSNumber numberWithDouble:locationDistance]]];
    }
    
    return distance;
}


@end
