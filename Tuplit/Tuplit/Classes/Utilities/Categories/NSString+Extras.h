
#import <Foundation/Foundation.h>

@interface NSString (Extras)

- (BOOL)isEmail;
- (NSString *)dottedNotation;
- (BOOL)isSpace;
- (BOOL)isNewLine;
- (BOOL)isEqualTo:(NSString *)string;
- (BOOL)isAlphaNumeric;
- (NSString *)stringByRemovingExtraSpaces;
- (NSString*)stringByTrimmingLeadingWhitespace;
- (NSString*)capitaliseFirstLetter;
NSString *NSNonNilString(NSString *str);

NS_INLINE BOOL BoolFromString(NSString *str) {
	return [str isEqualToString:@"YES"]? YES : NO;
}

NS_INLINE NSString* StringFromBool(BOOL value) {
	return value? @"YES" : @"NO";
}

NS_INLINE NSString* StringFromInt(int value) {
	return [NSString stringWithFormat:@"%d", value];
}

@end
