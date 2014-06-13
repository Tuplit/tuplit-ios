//
//  UIView+Alignment.m
//  21Questions
//
//
//

#import "UIView+Alignment.h"

@implementation UIView (Alignment)

- (void)centerHorizontally {
	
	CGRect _frame = self.frame;
	_frame.origin.x = (self.superview.frame.size.width - _frame.size.width) / 2;
	self.frame = _frame;
}

- (void)centerVertically {
    
    CGRect _frame = self.frame;
	_frame.origin.y = (self.superview.frame.size.height - _frame.size.height) / 2;
	self.frame = _frame;
}

- (void)centerBothDirections {
	
	CGRect _frame = self.frame;
	_frame.origin.x = (self.superview.frame.size.width - _frame.size.width) / 2;
	_frame.origin.y = (self.superview.frame.size.height - _frame.size.height) / 2;
	self.frame = _frame;
}

@end
