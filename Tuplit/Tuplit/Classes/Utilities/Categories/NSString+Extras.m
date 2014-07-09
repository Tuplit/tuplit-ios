#import "NSString+Extras.h"

@implementation NSString(Extras)

- (BOOL)isEmail {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@([A-Za-z0-9-]+[.])+[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:self];
}

- (NSString *)dottedNotation {
	
	NSMutableString *str = [self mutableCopy];
	
	for (int i=0; i<[self length]; i++) {
		
		NSString *ch = [self substringWithRange:NSMakeRange(i, 1)];
		if (![ch isSpace]) [str replaceCharactersInRange:NSMakeRange(i, 1) withString:@"_"];
	}
	
	return [str stringByReplacingOccurrencesOfString:@" " withString:@" "];
}

- (BOOL)isSpace {
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches[c] '[ ]'"];
	return [predicate evaluateWithObject:self];
}

- (BOOL)isNewLine {
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches[c] '[\\n]'"];
	return [predicate evaluateWithObject:self];
}

- (BOOL)isEqualTo:(NSString *)string {
	
	return [[self lowercaseString] isEqualToString:[string lowercaseString]];
}

- (BOOL)isAlphaNumeric {
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches[c] '[A-Z0-9a-z ]+'"];
	return [predicate evaluateWithObject:self];
}

- (NSString *)stringByRemovingExtraSpaces {
    
	NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableArray *comps = [[str componentsSeparatedByString:@" "] mutableCopy];
    [comps removeObject:@""];
    return [comps componentsJoinedByString:@" "];
}

- (NSString*)stringByTrimmingLeadingWhitespace {
    NSInteger i = 0;
    
    while ((i < [self length])
           && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }
    return [self substringFromIndex:i];
}

- (NSString*)capitaliseFirstLetter {
    
    if (self && [self length]>0) {
         return [self stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                  withString:[[self substringToIndex:1] capitalizedString]];
    }
    return self;
}

NSString *NSNonNilString(NSString *str) {
	
    if ([str isKindOfClass:[NSNull class]]) {
        return @"";
    } else if ([str isKindOfClass:[NSString class]] == NO) {
        return @"";
    } else if (str.length == 0) {
        return @"";
    }
    return str;
}

- (NSString *)stringWithTitleCase {
    
    NSMutableString *convertedStr = [NSMutableString stringWithString:[self capitalizedString]];
    
    NSRange range = NSMakeRange(0, convertedStr.length);
    
    // a list of words to always make lowercase could be placed here
    [convertedStr replaceOccurrencesOfString:@" De "
                                  withString:@" de "
                                     options:NSLiteralSearch
                                       range:range];
    
    // a list of words to always make uppercase could be placed here
    [convertedStr replaceOccurrencesOfString:@" Tv "
                                  withString:@" TV "
                                     options:NSLiteralSearch
                                       range:range];
    
    return convertedStr;
}

@end
