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
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@implementation TuplitConstants

NSNumberFormatter *numberFormatter;
NSDateFormatter *dateformat;
NSNumberFormatter *distanceformatter ;
NSDateFormatter *cmtDateFormat;

NSString *LString(NSString* key) {
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:@"en"];
    NSBundle *bundle = [NSBundle bundleWithPath:[bundlePath stringByDeletingLastPathComponent]];
    return NSLocalizedStringFromTableInBundle(key, nil, bundle, nil);
}

+(void) loadSliderHomePageWithAnimation:(BOOL)animated
{
    TLLeftMenuViewController *leftMenuVC = [[TLLeftMenuViewController alloc] initWithNibName:@"TLLeftMenuViewController" bundle:nil];
	TLMerchantsViewController *merchantVC = [[TLMerchantsViewController alloc] init];
    
    UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:merchantVC];
    
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
    
    if(!distanceformatter)
        distanceformatter = [[NSNumberFormatter alloc] init];
    distanceformatter.roundingIncrement = [NSNumber numberWithDouble:0.1];
    distanceformatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    if(locationDistance < 0.0)
    {
        distance = [NSString stringWithFormat:@"%@ m",[distanceformatter stringFromNumber:[NSNumber numberWithDouble:locationDistance]]];
    }
    else
    {
        distance = [NSString stringWithFormat:@"%@ km",[distanceformatter stringFromNumber:[NSNumber numberWithDouble:locationDistance]]];
    }
    
    return distance;
}

+ (NSString*)calculateTimeDifference:(NSString *)timeStamp
{
    //dateFrom Webservice
    NSTimeZone* timeZoneFromAbbreviation = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSString* timeZoneIdentifier = timeZoneFromAbbreviation.name;
    
    if(!cmtDateFormat)
        cmtDateFormat = [[NSDateFormatter alloc] init];
    [cmtDateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:timeZoneIdentifier]];
    [cmtDateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromWebServiceString = [cmtDateFormat dateFromString:timeStamp];
    
    // get the current date in LocalTimeZone
    NSDate *date = [NSDate date];
    
    // The time interval
    NSTimeInterval theTimeInterval = [date timeIntervalSinceDate:dateFromWebServiceString];
    
    // Get the system calendar
//    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    
    
    NSCalendarUnit units = NSSecondCalendarUnit | NSMinuteCalendarUnit| NSHourCalendarUnit | NSDayCalendarUnit | NSWeekOfYearCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:[NSDate date]
                                                                     toDate:date2
                                                                    options:0];
    if (components.year > 0) {
        return [NSString stringWithFormat:@"%ld yr", (long)components.year];
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld mon", (long)components.month];
    } else if (components.weekOfYear > 0) {
        return [NSString stringWithFormat:@"%ld wk", (long)components.weekOfYear];
    } else if (components.day > 0) {
        if (components.day > 1) {
            return [NSString stringWithFormat:@"%ld day", (long)components.day];
        } else {
            return @"Yesterday";
        }
    } else {
        if(components.hour < 1) {
            if(components.minute <= 0)
                return [NSString stringWithFormat:@"just now"];
            else if (components.minute < 1)
                return [NSString stringWithFormat:@"%ld sec", (long)components.second];
            else if (components.minute > 1)
                return [NSString stringWithFormat:@"%ld min", (long)components.minute];
            else
                return [NSString stringWithFormat:@"%ld min", (long)components.minute];
        } else {
            return [NSString stringWithFormat:@"%ld hr", (long)components.hour];
        }
    }
    
//    // Get conversion to years, months, days, hours, minutes,seconds
//    unsigned int secFlags   = NSSecondCalendarUnit;
//    unsigned int minFlags   = NSMinuteCalendarUnit;
//    unsigned int hourFlags  = NSHourCalendarUnit;
//    unsigned int dayFlags   = NSDayCalendarUnit;
//    unsigned int monthFlags = NSMonthCalendarUnit;
//    unsigned int yearFlags  = NSYearCalendarUnit;
//   
//     NSDateComponents *secdownInfo = [sysCalendar components:secFlags fromDate:date1  toDate:date2  options:0];
//     NSDateComponents *mindownInfo = [sysCalendar components:minFlags fromDate:date1  toDate:date2  options:0];
//     NSDateComponents *hourdownInfo = [sysCalendar components:hourFlags fromDate:date1  toDate:date2  options:0];
//     NSDateComponents *daydownInfo = [sysCalendar components:dayFlags fromDate:date1  toDate:date2  options:0];
//     NSDateComponents *monthdownInfo = [sysCalendar components:monthFlags fromDate:date1  toDate:date2  options:0];
//     NSDateComponents *yeardownInfo = [sysCalendar components:yearFlags fromDate:date1  toDate:date2  options:0];
//    
//    NSString *dateStr;
//    // Calculating time to display
//    if([secdownInfo second]<60)
//    {
//        if([secdownInfo second]>0)
//            dateStr = [NSString stringWithFormat:@"%ds",[secdownInfo second]];
//        else
//            dateStr = [NSString stringWithFormat:@"Just now"];
//    }
//    else if([mindownInfo minute]<60)
//        dateStr = [NSString stringWithFormat:@"%dm",[mindownInfo minute]];
//    else if([hourdownInfo hour]<24)
//        dateStr = [NSString stringWithFormat:@"%dh",[hourdownInfo hour]];
//    else if([daydownInfo day]<30)
//        dateStr = [NSString stringWithFormat:@"%dd",[daydownInfo day]];
//    else if([monthdownInfo month]<12)
//        dateStr = [NSString stringWithFormat:@"%dm",[monthdownInfo month]];
//    else if([yeardownInfo year])
//        dateStr = [NSString stringWithFormat:@"%dy",[yeardownInfo year]];
//    
//    return dateStr;
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
        [priceString appendString:[NSString stringWithFormat:@"£%@",string]];
        if(i==1)
            [priceString appendString:@")"];
        
        i++;
    }
    NSAttributedString *dollarAttrString = [[NSAttributedString alloc]initWithString:@"££ " attributes:
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
    [TLUserDefaults setIsCommentPromptOpen:NO];
    [TLUserDefaults setCommentDetails:nil];
    [[TLAppLocationController sharedManager]stopUpdatingLocation];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    if([signIn hasAuthInKeychain])
    [signIn signOut];
    [APP_DELEGATE.navigationController dismissViewControllerAnimated:YES completion:nil];
    APP_DELEGATE.cartModel = [[CartModel alloc] init];
}
+(NSNumberFormatter*) getCurrencyFormat
{
    if(!numberFormatter)
    {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_UK"]];
    }
    return numberFormatter;
}

+(NSString*)getOrderDate:(NSString*)date
{
    if(!dateformat)
        dateformat= [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *transdate= [dateformat dateFromString:date];
    [dateformat setDateFormat:@"MM/dd/yyyy"];
    return [dateformat stringFromDate:transdate];
}
+(NSString*)getOrderDateTime:(NSString*)date
{
    if(!dateformat)
        dateformat= [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *transdate= [dateformat dateFromString:date];
    [dateformat setDateFormat:@"MM/dd/yyyy, h:mm a"];
    return [dateformat stringFromDate:transdate];
}

+ (NSMutableString*)filteredPhoneStringFromString:(NSString*)string withFilter:(NSString*)filter
{
    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([filter length])];
    BOOL done = NO;
    
    while(onFilter < [filter length] && !done)
    {
        char filterChar = [filter characterAtIndex:onFilter];
        char originalChar = onOriginal >= string.length ? '\0' : [string characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':

                if(originalChar=='\0')
                {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar)||originalChar =='X')
                {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                }
                else
                {
                    onOriginal++;
                }
                break;
            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
                break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    return [NSMutableString stringWithUTF8String:outputString];
}

@end
