//
//  CustomSwitch.h
//  CustomSwitch
//
//  Created on 26/05/14.
//
//

#import <UIKit/UIKit.h>

@interface CustomSwitch : UIControl

@property (nonatomic, assign) BOOL on;
@property (nonatomic, strong) UIColor *inactiveColor;
@property (nonatomic, strong) UIColor *activeColor;
@property (nonatomic, strong) UIColor *onColor;
@property (nonatomic, strong) UIColor *offColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *knobColor;
@property (nonatomic, strong) UIColor *shadowColor;

@property (nonatomic, assign) BOOL isRounded;

@property (nonatomic, strong) UIImage *onImage;
@property (nonatomic, strong) UIImage *offImage;
@property (nonatomic, strong) NSString *onText;
@property (nonatomic, strong) NSString *offText;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
- (BOOL)isOn;
@end

