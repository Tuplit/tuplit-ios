//
//  UILabel+Resizing.m
//  21Questions
//
//
//

#import "UILabel+Resizing.h"
#import "UI.h"

@implementation UILabel (Resizing)

- (void)sizeToFitVertically {
	
	CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 9999) lineBreakMode:self.lineBreakMode];
	CGRect _frame = self.frame;
	_frame.size.height = size.height;
	self.frame = _frame;
}

- (void)sizeToFitHorizontally {
	
	CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake([UI appFrameWidth], self.frame.size.height) lineBreakMode:self.lineBreakMode];
	CGRect _frame = self.frame;
	_frame.size.width = size.width;
	self.frame = _frame;
}

- (CGSize)sizeForText:(NSString *)text {
    
    return [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake([UI appFrameWidth], self.frame.size.height) lineBreakMode:self.lineBreakMode];
}


- (float)widthForText:(NSString *)text {
    
    return [self sizeForText:text].width;
}

- (void)sizeToFitHorizontallyWithPadding :(float)padding {
	
	CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake([UI appFrameWidth], self.frame.size.height) lineBreakMode:self.lineBreakMode];
	CGRect _frame = self.frame;
	_frame.size.width = size.width+padding;
	self.frame = _frame;
}

- (void)sizeToFitHorizontallyWithPadding:(float)padding maxWidth:(float)maxWidth {
	
	CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake([UI appFrameWidth], self.frame.size.height) lineBreakMode:self.lineBreakMode];
	CGRect _frame = self.frame;
    float width = size.width+padding;
    if (width > maxWidth) {
        width = maxWidth;
    }
	_frame.size.width = width;
	self.frame = _frame;
}

-(void)setMinimumSize
{
   	CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 1000) lineBreakMode:self.lineBreakMode];
	CGRect _frame = self.frame;
	_frame.size.height =MAX(_frame.size.height, size.height);
	self.frame = _frame;
}

- (void)sizeToFitRightHorizontally {
	
	CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake([UI appFrameWidth], self.frame.size.height) lineBreakMode:self.lineBreakMode];
	CGRect _frame = self.frame;
    _frame.origin.x=_frame.origin.x+(_frame.size.width-size.width);
	_frame.size.width = size.width;
	self.frame = _frame;
}
@end
