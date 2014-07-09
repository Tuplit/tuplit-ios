
#import <Foundation/Foundation.h>


@interface NSString (Base64)

- (NSData *)base64DecodedData:(NSString*) string;
- (NSString *)base64EncodedStringFromData:(NSData*)data;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;

@end
