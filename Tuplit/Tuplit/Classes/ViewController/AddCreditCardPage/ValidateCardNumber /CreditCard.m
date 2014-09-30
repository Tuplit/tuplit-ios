//
//  CreditCard.m
//  CreditCardValidation
//
//  Created by Miguel Cohnen on 5/31/13.
//  Copyright (c) 2013 Miguel Cohnen. All rights reserved.
//

#import "CreditCard.h"

@implementation CreditCard

+ (NSMutableArray *)toCharArray:(NSString *)str {
    
	NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:str.length];
	for (int i=0; i < str.length; i++) {
		NSString *ichar  = [NSString stringWithFormat:@"%c", [str characterAtIndex:i]];
		[characters addObject:ichar];
	}
    
	return characters;
}

+ (BOOL)luhnCheck:(NSString *)stringToTest {
    if (stringToTest.length < 1) {
        return NO;
    }
	NSMutableArray *stringAsChars = [self toCharArray:stringToTest];
    
	BOOL isOdd = YES;
	int oddSum = 0;
	int evenSum = 0;
    
	for (int i = (int)[stringToTest length] - 1; i >= 0; i--) {
		int digit = [(NSString *)[stringAsChars objectAtIndex:i] intValue];
		if (isOdd) {
            oddSum += digit;
        } else {
            evenSum += digit/5 + (2*digit) % 10;
        }

		isOdd = !isOdd;
	}
    
	return ((oddSum + evenSum) % 10 == 0);
}

- (BOOL)luhnCheck {
    return [CreditCard luhnCheck:self.number];
}


- (NSArray *)validateExpirationDate {
    NSMutableArray *errors = [[NSMutableArray alloc] init];
    
    NSArray* dayComponent = [self.expirationMonthYear componentsSeparatedByString: @"/"];
   
    int expirationMonth;
    int expirationYear;
    if(dayComponent.count>1)
    {
        expirationMonth = [NSString stringWithFormat:@"%@",[dayComponent objectAtIndex:0]].intValue;
        expirationYear = [NSString stringWithFormat:@"%@",[dayComponent objectAtIndex:1]].intValue;
    }
    else
    {
        [errors addObject:@"Expiration date is not valid"];
    }
    
    if (expirationYear < 1 || expirationYear > 99) {
        [errors addObject:@"Expiration Year is not valid."];
    }
    if (expirationMonth < 1 || expirationMonth > 12) {
        [errors addObject:@"Expiration Month is not valid."];
    }
    if (errors.count == 0) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
        int year2Digit = [components year]%100;
        BOOL expired = YES;
        if (year2Digit < expirationYear) {
            expired = NO;
        } else if (year2Digit == expirationYear){
            int month = (int)[components month];
            if (expirationMonth >= month) {
                expired = NO;
            }
        }
        if (expired) {
            [errors addObject:@"Credit card is expired"];
        }
    }
    return errors;
}

//- (NSArray *)validateZipCode {
//    // zip codes are tricky, so just check if it is not empty
//    if (self.zipCode.length < 1) {
//        return @[@"Zip code can't be empty"];
//    }
//    return @[];
//}

- (NSArray *)validateCCV {
    if (self.ccv.intValue == 0 || self.ccv.length < 3 || self.ccv.length > 3) {
        return @[@"CCV should be 3 numbers"];
    }
    return @[];
}

- (NSArray *)validate {
    NSMutableArray *errors = [[NSMutableArray alloc] init];
    if (![self luhnCheck]) {
        [errors addObject:@"Card number is invalid"];
    }
    [errors addObjectsFromArray:[self validateExpirationDate]];
    [errors addObjectsFromArray:[self validateCCV]];
//    [errors addObjectsFromArray:[self validateZipCode]];
    return errors ? errors : nil;
}

-(NSString*) validateDate : (NSString*)value Length:(NSInteger)len
{
    if (len <3)
    {
        if ([value integerValue] >1)
        {
            if([value integerValue] > 12)
            {
                return [NSString stringWithFormat:@"01"] ;
            }
            else
                return [NSString stringWithFormat:@"0%@",value];
        }
        else
        {
            return [NSString stringWithFormat:@"%@",value];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%@",value] ;
    }
    
}
@end