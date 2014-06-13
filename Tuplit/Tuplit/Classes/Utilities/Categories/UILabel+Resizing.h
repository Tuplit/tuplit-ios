//
//  UILabel+Resizing.h
//  21Questions
//
//
//

#import <UIKit/UIKit.h>

@interface UILabel (Resizing)

- (void)sizeToFitVertically;
- (void)sizeToFitHorizontally;
- (CGSize)sizeForText:(NSString *)text;
- (float)widthForText:(NSString *)text;
- (void)sizeToFitHorizontallyWithPadding :(float)padding;
- (void)sizeToFitHorizontallyWithPadding:(float)padding maxWidth:(float)maxWidth;
-(void)setMinimumSize;
- (void)sizeToFitRightHorizontally;
@end
