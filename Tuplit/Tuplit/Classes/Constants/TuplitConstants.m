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

+ (NSString*)calculateTimeDifference:(NSString *)timeStamp
{
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    NSString* localAbbreviation = [localTimeZone abbreviation];
    NSTimeZone* timeZoneFromAbbreviation = [NSTimeZone timeZoneWithAbbreviation:localAbbreviation];
    NSString* timeZoneIdentifier = timeZoneFromAbbreviation.name;
    
    // get the current date in LocalTimeZone
    NSDate *date = [NSDate date];

    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:timeZoneIdentifier]];
    [dateFormat2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromWebServiceString = [[NSDate alloc] init];
    dateFromWebServiceString = [dateFormat2 dateFromString:timeStamp];
    
    //Calculate difference in WebService Time and System Time
    NSTimeInterval timeDifference = [date timeIntervalSinceDate:dateFromWebServiceString];
    
    if(timeDifference < 0)  // Server time is 2 minutes ahead of device time.   So as soon as post is done it gives -2 minutes ago instead of 0 minutes ago
    {
        timeDifference = 0;
    }
    
    int iminutes = timeDifference / 60;
    if(iminutes<60)
    {
        return [NSString stringWithFormat:@"%dm",iminutes];
    }
    int ihours = iminutes / 60;
    if(ihours<24)
    {
        return [NSString stringWithFormat:@"%dh",ihours];
    }
    int idays = iminutes / 1440;
    
    iminutes = iminutes - ihours * 60 ;
    ihours = ihours - idays *24 ;// this ives correct no of days than the looping in while several times
    return  [NSString stringWithFormat:@"%dd",idays];
    
//    int idays = components.day;
//    if(idays<365)
//    {
//        return  [NSString stringWithFormat:@"%dm",idays];
//    }
//    int iyears = components.year;
//    return [NSString stringWithFormat:@"%dy",iyears];
}

+(NSMutableAttributedString*)getOpeningHrs:(NSString*)datestring isTimeFormat:(BOOL)isTime
{
    //    Mon, Tue : 04:05 - 19:03
    //string seperated by first time occurence of :
    NSRange equalRange = [datestring rangeOfString:@":" options:NSLiteralSearch];
    if (equalRange.location != NSNotFound)
    {
        NSString *days = [datestring substringWithRange:NSMakeRange(0, equalRange.location)];
        NSString *time = [[datestring substringFromIndex:equalRange.location + equalRange.length]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSArray* dayComponent;
        if ([days rangeOfString:@"to"].location == NSNotFound) {
            dayComponent = [days componentsSeparatedByString: @","];
        } else {
            dayComponent = [days componentsSeparatedByString: @"to"];
        }
        NSArray* timeComponent = [time componentsSeparatedByString: @"-"];
        
        int i=0;
        if(!isTime)
        {
            NSMutableString *dayString = [[NSMutableString alloc]init];
            //day conversion
            for(NSString *string in dayComponent)
            {
                if(i==1)
                    [dayString appendString:@"-"];
                if(i==0 || i==[dayComponent count]-1)
                    [dayString appendString:[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]substringToIndex:3]];
                
                i++;
            }
            NSMutableAttributedString *dayAttrString = [[NSMutableAttributedString alloc]initWithString:dayString attributes:
                                                        @{
                                                          NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12],
                                                          NSForegroundColorAttributeName:UIColorFromRGB(0x999999) ,
                                                          }];
            return dayAttrString;
        }
        else
        {
            NSMutableString *timeString = [[NSMutableString alloc]init];
            //day conversion
            for(NSString *string in timeComponent)
            {
                if(i==1)
                    [timeString appendString:@"-"];
                [timeString appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                
                i++;
            }
            NSMutableAttributedString *timeAttrString = [[NSMutableAttributedString alloc]initWithString:timeString attributes:
                                                         @{
                                                           NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12],
                                                           NSForegroundColorAttributeName:UIColorFromRGB(0x333333) ,
                                                           }];
            return timeAttrString;
        }
        
    } else {
        NSLog(@"Wrong Date Format From Service");
    }
    return nil;
}

+ (NSMutableAttributedString*)getPriceRange:(NSString *)_priceString
{
    NSArray* priceComponent = [_priceString componentsSeparatedByString: @","];
    NSMutableString *priceString = [[NSMutableString alloc]init];
    int i=0;
    for(NSString *string in priceComponent)
    {
        if(i==0)
            [priceString appendString:@"("];
        if(i==1)
            [priceString appendString:@"-"];
        [priceString appendString:[NSString stringWithFormat:@"$%@",string]];
        if(i==1)
            [priceString appendString:@")"];
        
        i++;
    }
    NSAttributedString *dollarAttrString = [[NSAttributedString alloc]initWithString:@"$$ " attributes:
                                            @{
                                              NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12],
                                              NSForegroundColorAttributeName:UIColorFromRGB(0x333333) ,
                                              }];
    NSAttributedString *priceAttrString = [[NSAttributedString alloc]initWithString:priceString attributes:
                                           @{
                                             NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12],
                                             NSForegroundColorAttributeName:UIColorFromRGB(0x999999) ,
                                             }];
    NSMutableAttributedString *finalAttString = [dollarAttrString mutableCopy];
    [finalAttString appendAttributedString:priceAttrString];
    return finalAttString;
}

+(NSString*)formatPhoneNumber:(NSString*)mobileNumber
{
//    if(mobileNumber.length==10)
//    {
//        NSMutableString *strings = [NSMutableString stringWithString:mobileNumber];
//        [strings insertString:@"(" atIndex:0];
//        [strings insertString:@")" atIndex:4];
//        [strings insertString:@" " atIndex:5];
//        [strings insertString:@"-" atIndex:9];
//        return [NSString stringWithFormat:@"%@",strings];
//    }
    return mobileNumber;
}

+(void) userLogout {
    
    [TLUserDefaults setCurrentUser:nil];
    [TLUserDefaults setIsGuestUser:NO];
    [APP_DELEGATE.navigationController dismissViewControllerAnimated:YES completion:nil];
    APP_DELEGATE.cartModel = [[CartModel alloc] init];
}
+(NSNumberFormatter*) getCurrencyFormat
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    return numberFormatter;
}

+(NSString*)getOrderDate:(NSString*)date
{
    NSDateFormatter *dateformat= [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *transdate= [dateformat dateFromString:date];
    [dateformat setDateFormat:@"MM/dd/yyyy"];
    return [dateformat stringFromDate:transdate];
}
+(NSString*)getOrderDateTime:(NSString*)date
{
    NSDateFormatter *dateformat= [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *transdate= [dateformat dateFromString:date];
    [dateformat setDateFormat:@"d/M/yyyy, h:mm a"];
    return [dateformat stringFromDate:transdate];
}


@end
