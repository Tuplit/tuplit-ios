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
#import "TLUserProfileViewController.h"
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

+(void)openMyProfile
{
    [APP_DELEGATE.slideMenuController hideMenuViewController];
    if(!APP_DELEGATE.myProfileVC)
    {
        APP_DELEGATE.myProfileVC = [[TLUserProfileViewController alloc] init];
    }
    else
    {
        [APP_DELEGATE.myProfileVC reloadUserprofile];
    }
    UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:APP_DELEGATE.myProfileVC];
    [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
}

+(void)openMerchantVC
{
    [APP_DELEGATE.slideMenuController hideMenuViewController];
    if(!APP_DELEGATE.merchantVC)
    {
        APP_DELEGATE.merchantVC = [[TLMerchantsViewController alloc] init];
    }
    else
    {
        [APP_DELEGATE.merchantVC reloadMerchant];
    }
    UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:APP_DELEGATE.merchantVC];
    [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
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
        return [NSString stringWithFormat:@"%ld mnt", (long)components.month];
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
}

+(NSArray*)getOpeningHrs:(NSArray*)openHrsArray
{
    NSArray *weekdays = [NSArray arrayWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun",@"Mon-Sun" ,nil];
    NSMutableDictionary *openHrsDict = [NSMutableDictionary new];
    NSMutableDictionary *opendaysDict = [NSMutableDictionary new];

    for (NSString *dayTimeStr in openHrsArray)
    {
        NSMutableAttributedString *dayAttrString;
        NSRange equalRange = [dayTimeStr rangeOfString:@":" options:NSLiteralSearch];
        
        NSString *days = [dayTimeStr substringWithRange:NSMakeRange(0, equalRange.location)];
        NSString *time = [[dayTimeStr substringFromIndex:equalRange.location + equalRange.length]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSMutableString *timeString = [[NSMutableString alloc]init];
        NSArray* timeComponent = [time componentsSeparatedByString: @"-"];
       int i = 0;
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
        
        if (equalRange.location != NSNotFound)
        {
             i=0;
            
            NSMutableString *dayString = [[NSMutableString alloc]init];
            NSArray* dayComponent;
            if ([days rangeOfString:@"to"].location == NSNotFound) {
                dayComponent = [days componentsSeparatedByString: @","];
                
                //day conversion
                for(NSString *string in dayComponent)
                {
                    dayAttrString = [[NSMutableAttributedString alloc]initWithString:[string stringByRemovingExtraSpaces] attributes:
                                     @{
                                       NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12],
                                       NSForegroundColorAttributeName:UIColorFromRGB(0x999999) ,
                                       }];
                    [opendaysDict setObject:dayAttrString forKey:[string stringByRemovingExtraSpaces]];
                    [openHrsDict setObject:timeAttrString forKey:[string stringByRemovingExtraSpaces]];
                    i++;
                }
            }
            else {
                dayComponent = [days componentsSeparatedByString: @"to"];
                i = 0;
                for(NSString *string in dayComponent)
                {
                    if(i==1)
                        [dayString appendString:@"-"];
                    if(i==0 || i==[dayComponent count]-1)
                        [dayString appendString:[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]substringToIndex:3]];
                    
                    dayAttrString = [[NSMutableAttributedString alloc]initWithString:dayString attributes:
                                     @{
                                       NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12],
                                       NSForegroundColorAttributeName:UIColorFromRGB(0x999999) ,
                                       }];
                    
                    i++;
                }
                [opendaysDict setObject:dayAttrString forKey:@"Mon-Sun"];
                [openHrsDict setObject:timeAttrString forKey:@"Mon-Sun"];
            }
        }
    }
    NSMutableAttributedString *opendaysString = [NSMutableAttributedString new];
    NSMutableAttributedString *openHrsString = [NSMutableAttributedString new];
    int i=0;
    for(NSAttributedString *string in weekdays)
    {
        NSAttributedString *daystr = [opendaysDict objectForKey:string];
        NSAttributedString *hrsstr = [openHrsDict objectForKey:string];
        
        if(daystr.length >0 && hrsstr.length>0)
        {
            if(i!=0)
            {
                NSAttributedString *atrStr = [[NSAttributedString alloc]initWithString:@"\n" attributes:nil];
                [opendaysString appendAttributedString:atrStr];
                [openHrsString appendAttributedString:atrStr];
            }
            [opendaysString  appendAttributedString:daystr];
            [openHrsString  appendAttributedString:hrsstr];
             i++;
        }
        else
        {
            
        }
       
    }
    return [NSArray arrayWithObjects:opendaysString,openHrsString, nil];
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

+(NSString*)dobFormattedDate:(NSString*)datefromServer
{
    NSString *dateString = datefromServer;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *resultString = [formatter stringFromDate:dateFromString];
    return resultString;
}

+(NSString*)facebookFormattedDate:(NSString*)datefromServer
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [dateFormat dateFromString:datefromServer];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *resultString = [formatter stringFromDate:date];
    
    return resultString;
}

+(void) userLogout {

    [TLUserDefaults setCurrentUser:nil];
    [TLUserDefaults setIsGuestUser:NO];
    [TLUserDefaults setIsCommentPromptOpen:NO];
    [TLUserDefaults setCommentDetails:nil];
    APP_DELEGATE.friendsRecentOrders = nil;
    
    [[TLAppLocationController sharedManager]stopUpdatingLocation];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    if([signIn hasAuthInKeychain])
    [signIn signOut];
    [APP_DELEGATE.navigationController dismissViewControllerAnimated:YES completion:nil];
    APP_DELEGATE.cartModel = [[CartModel alloc] init];
}
+(NSNumberFormatter*) getCurrencyFormat
{
//    if(!numberFormatter)
//    {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setMaximumFractionDigits:2];
        [numberFormatter setRoundingMode: NSNumberFormatterRoundUp];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_UK"]];
//    }
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

+ (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    // Add a little extra space on the sides
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

+(BOOL) isMerchantClosed:(NSArray*) openHrsArray {
    NSMutableDictionary *openHoursDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *openHoursDict1 = [[NSMutableDictionary alloc] init];
    //
    NSDictionary *weekdayRef = @{
                                 @"sun"   : @"1",
                                 @"mon"   : @"2",
                                 @"tue"   : @"3",
                                 @"wed"   : @"4",
                                 @"thu"   : @"5",
                                 @"fri"   : @"6",
                                 @"sat"   : @"7",
                                 };
    
    //    NSDictionary *weekdayRef  = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"sun",@"2",@"mon",@"3",@"tue",@"4",@"wed",@"5",@"thu",@"6",@"fri",@"7",@"sat", nil];
    for (NSString *openHours in openHrsArray) {
        
        NSArray *daysOpenhoursArray = [openHours componentsSeparatedByString:@":"];
        
        if (daysOpenhoursArray.count > 1) {
            
            NSString *splitUsing = @",";
            
            if ([[daysOpenhoursArray objectAtIndex:0] respondsToSelector:@selector(containsString:)]) {
                
                if ([[daysOpenhoursArray objectAtIndex:0] containsString:@"to"]) {
                    splitUsing = @"to";
                }
            }
            else
            {
                if ([[daysOpenhoursArray objectAtIndex:0] rangeOfString:@"to"].location == NSNotFound)
                {
                    
                }
                else
                {
                    splitUsing = @"to";
                }
            }
            
            NSArray *opdays = [[daysOpenhoursArray objectAtIndex:0] componentsSeparatedByString:splitUsing];
            NSMutableArray *openDays = [[NSMutableArray alloc] init];
            for(NSString *key in opdays)
            {
                NSString *wkKey = [NSString stringWithFormat:@"%@",[[key lowercaseString]stringByReplacingOccurrencesOfString:@" " withString:@""]];
                [openDays addObject:[weekdayRef valueForKey:wkKey]];
            }
            if ([splitUsing isEqualToString:@"to"]) {
                
                [openDays addObject:[weekdayRef valueForKey:@"tue"]];
                [openDays addObject:[weekdayRef valueForKey:@"wed"]];
                [openDays addObject:[weekdayRef valueForKey:@"thu"]];
                [openDays addObject:[weekdayRef valueForKey:@"fri"]];
                [openDays addObject:[weekdayRef valueForKey:@"sat"]];
                
            }
            
            for (NSString *day in openDays) {
                
                NSArray *minHour = [[daysOpenhoursArray objectAtIndex:2] componentsSeparatedByString:@"-"];
                
                NSString *openTime = [[NSString stringWithFormat:@"%@.%@",[daysOpenhoursArray objectAtIndex:1],[minHour objectAtIndex:0]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *closeTime = [[NSString stringWithFormat:@"%@.%@",[minHour objectAtIndex:1],[daysOpenhoursArray objectAtIndex:3]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if(openTime.doubleValue>=closeTime.doubleValue)
                {
                    [openHoursDict setObject:[NSArray arrayWithObjects:openTime,@"23.59",nil] forKey:day];
                    NSString *nextday;
                    if(day.integerValue==7)
                    {
                        nextday = @"1";
                    }
                    else
                    {
                        nextday = [NSString stringWithFormat:@"%d",(int)day.integerValue+1];
                    }
                    [openHoursDict1 setObject:[NSArray arrayWithObjects:@"00.00",closeTime,nil] forKey:nextday];
                }
                else
                {
                    [openHoursDict setObject:[NSArray arrayWithObjects:openTime,closeTime,nil] forKey:day];
                }
            }
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
    [formatter setDateFormat:@"HH.mm"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"EEE"];
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSString *day = [NSString stringWithFormat:@"%ld",(long)[comp weekday]];
    
    NSArray *openCloseHours = [openHoursDict objectForKey:day];
    
    if (openCloseHours) {
        
        float openHours = [[openCloseHours objectAtIndex:0] floatValue];
        float closeHours = [[openCloseHours objectAtIndex:1] floatValue];
        
        float currentHour = [time floatValue];
        
        if ((openHours <= currentHour) && (currentHour <= closeHours)) {
            return NO;
        }
    }
    
    NSArray *openCloseHours1 = [openHoursDict1 objectForKey:day];
    if(openCloseHours1)
    {
        float openHours = [[openCloseHours objectAtIndex:0] floatValue];
        float closeHours = [[openCloseHours objectAtIndex:1] floatValue];
        
        float currentHour = [time floatValue];
        
        if ((openHours <= currentHour) && (currentHour <= closeHours)) {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

@end
