//
//  CustomSwitch.m
//  CustomSwitch
//
//  Created on 26/05/14.
//
//

#import "CustomSwitch.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomSwitch ()  {
    UIView *background;
    UIView *knob;
    UIImageView *onImageView;
    UIImageView *offImageView;
    UILabel *yesLabel;
    UILabel *noLabel;
    double startTime;
    BOOL isAnimating;
}

- (void)showOn:(BOOL)animated;
- (void)showOff:(BOOL)animated;
- (void)setup;

@end

@implementation CustomSwitch

@synthesize inactiveColor, activeColor, onColor, borderColor, knobColor, shadowColor;
@synthesize onImage, offImage;
@synthesize isRounded;
@synthesize on;

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 50, 30)];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    // use the default values if CGRectZero frame is set
    CGRect initialFrame;
    if (CGRectIsEmpty(frame)) {
        initialFrame = CGRectMake(0, 0, 50, 30);
    }
    else {
        initialFrame = frame;
    }
    self = [super initWithFrame:initialFrame];
    if (self) {
        [self setup];
    }
    return self;
}

- (BOOL)isOn {
    
    return on;
}

- (void)setup {
    
    // default values
    self.on = NO;
    self.isRounded = YES;
    self.inactiveColor = [UIColor clearColor];
    self.activeColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f];
    self.onColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttonBg.png"]];
    self.offColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"textFieldBg.png"]];
    self.borderColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.91f alpha:1.00f];
    self.knobColor = [UIColor whiteColor];
    self.shadowColor = [UIColor grayColor];
    
    // background
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    background.backgroundColor = self.offColor;
    background.layer.borderColor = self.offColor.CGColor;
    background.layer.cornerRadius = self.frame.size.height * 0.5;
    background.layer.borderWidth = 1.0;
    background.userInteractionEnabled = NO;
    [self addSubview:background];
    
    // images
    onImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
    onImageView.alpha = 0;
    onImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:onImageView];
    
    offImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
    offImageView.alpha = 1.0;
    offImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:offImageView];
    
    //YesLabel
    
    yesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
    yesLabel.textColor=[UIColor whiteColor];
	yesLabel.textAlignment = NSTextAlignmentCenter;
    [background addSubview:yesLabel];
    
	//NoLabel
    
    noLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
    noLabel.textColor=[UIColor whiteColor];
    noLabel.textAlignment = NSTextAlignmentCenter;
    [background addSubview:noLabel];
    
    // knob
    knob = [[UIView alloc] initWithFrame:CGRectMake(1, 1, 49, self.frame.size.height - 2)];
    knob.backgroundColor = self.knobColor;
    knob.layer.cornerRadius = (self.frame.size.height * 0.5) - 1;
    knob.layer.shadowColor = self.shadowColor.CGColor;
    knob.layer.shadowRadius = 2.0;
    knob.layer.shadowOpacity = 0.5;
    knob.layer.shadowOffset = CGSizeMake(0, 3);
    knob.layer.masksToBounds = NO;
    knob.userInteractionEnabled = NO;
    [self addSubview:knob];
    
    isAnimating = NO;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    
    // start timer to detect tap later in endTrackingWithTouch:withEvent:
    startTime = [[NSDate date] timeIntervalSince1970];
    
    // make the knob larger and animate to the correct color
    CGFloat activeKnobWidth = self.bounds.size.height - 2 + 5;
    isAnimating = YES;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (self.on) {
            knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), knob.frame.origin.y, activeKnobWidth, knob.frame.size.height);
            background.backgroundColor = self.onColor;
        }
        else {
            knob.frame = CGRectMake(knob.frame.origin.x, knob.frame.origin.y, activeKnobWidth, knob.frame.size.height);
            background.backgroundColor = self.activeColor;
        }
    } completion:^(BOOL finished) {
        isAnimating = NO;
    }];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    // Get touch location
    CGPoint lastPoint = [touch locationInView:self];
    
    // update the switch to the correct visuals depending on if
    // they moved their touch to the right or left side of the switch
    if (lastPoint.x > self.bounds.size.width * 0.5)
        [self showOn:YES];
    else
        [self showOff:YES];
    
    return YES;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    
    // capture time to see if this was a tap action
    double endTime = [[NSDate date] timeIntervalSince1970];
    double difference = endTime - startTime;
    
    // determine if the user tapped the switch or has held it for longer
    if (difference <= 0.2) {
        CGFloat normalKnobWidth = self.bounds.size.height - 2;
        knob.frame = CGRectMake(knob.frame.origin.x, knob.frame.origin.y, normalKnobWidth, knob.frame.size.height);
        [self setOn:!self.on animated:YES];
    }
    else {
        // Get touch location
        CGPoint lastPoint = [touch locationInView:self];
        
        // update the switch to the correct value depending on if
        // their touch finished on the right or left side of the switch
        if (lastPoint.x > self.bounds.size.width * 0.5)
            [self setOn:YES animated:YES];
        else
            [self setOn:NO animated:YES];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    
    // just animate back to the original value
    if (self.on)
        [self showOn:YES];
    else
        [self showOff:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!isAnimating) {
        CGRect frame = self.frame;
        
        // background
        background.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        background.layer.cornerRadius = self.isRounded ? frame.size.height * 0.5 : 2;
        
        // images
        onImageView.frame = CGRectMake(0, 0, frame.size.width - frame.size.height, frame.size.height);
        offImageView.frame = CGRectMake(frame.size.height, 0, frame.size.width - frame.size.height, frame.size.height);
        
        //Label
        yesLabel.frame = CGRectMake(0, 0, frame.size.width - frame.size.height, frame.size.height);
		noLabel.frame = CGRectMake(frame.size.height, 0, frame.size.width - frame.size.height, frame.size.height);
        
        // knob
        knob.frame = CGRectMake(1, 1, 49, frame.size.height - 2);
        knob.layer.cornerRadius = self.isRounded ? (frame.size.height * 0.5) - 1 : 2;
    }
}
- (void)setInactiveColor:(UIColor *)color {
    inactiveColor = color;
    if (!self.on && !self.isTracking)
        background.backgroundColor = color;
}

- (void)setOnColor:(UIColor *)color {
    onColor = color;
    if (self.on && !self.isTracking)
        background.backgroundColor = color;
}

-(void)setOffColor:(UIColor *)Color
{
    _offColor = Color;
    if (self.on && !self.isTracking)
        background.backgroundColor =_offColor;
}

- (void)setBorderColor:(UIColor *)color {
    borderColor = color;
    if (!self.on)
        background.layer.borderColor = color.CGColor;
}

- (void)setKnobColor:(UIColor *)color {
    knobColor = color;
    knob.backgroundColor = color;
}

- (void)setShadowColor:(UIColor *)color {
    shadowColor = color;
    knob.layer.shadowColor = color.CGColor;
}

- (void)setOnImage:(UIImage *)image {
    onImage = image;
    onImageView.image = image;
}

- (void)setOffImage:(UIImage *)image {
    offImage = image;
    offImageView.image = image;
}

- (void)setOnText:(NSString *)onText
{
	_onText = onText;
	yesLabel.text = onText;
}

/*
 *	Sets the text that shows when the switch is off.
 *  The text is centered in the area not covered by the knob.
 */

- (void)setOffText:(NSString *)offText
{
	_offText = offText;
	noLabel.text = offText;
}

/*
 *	Sets the text that shows when the switch is off.
 *  The text is centered in the area not covered by the knob.
 */

- (void)setIsRounded:(BOOL)rounded {
    isRounded = rounded;
    
    if (rounded) {
        background.layer.cornerRadius = self.frame.size.height * 0.5;
        knob.layer.cornerRadius = (self.frame.size.height * 0.5) - 1;
    }
    else {
        background.layer.cornerRadius = 2;
        knob.layer.cornerRadius = 2;
    }
}

- (void)setOn:(BOOL)isOn {
    [self setOn:isOn animated:NO];
}

- (void)setOn:(BOOL)isOn animated:(BOOL)animated {
    BOOL previousValue = self.on;
    on = isOn;
    
    if (previousValue != isOn)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (isOn) {
        [self showOn:animated];
    }
    else {
        [self showOff:animated];
    }
}

- (void)showOn:(BOOL)animated {
    CGFloat normalKnobWidth = 49;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated) {
        isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking)
                knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), knob.frame.origin.y, activeKnobWidth, knob.frame.size.height);
            else
                knob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth-1), knob.frame.origin.y, normalKnobWidth, knob.frame.size.height);
            background.backgroundColor = self.onColor;
            background.layer.borderColor = self.onColor.CGColor;
            onImageView.alpha = 1.0;
            offImageView.alpha = 0;
        } completion:^(BOOL finished) {
            isAnimating = NO;
        }];
    }
    else {
        if (self.tracking)
            knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), knob.frame.origin.y, activeKnobWidth, knob.frame.size.height);
        else
            knob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), knob.frame.origin.y, normalKnobWidth, knob.frame.size.height);
        background.backgroundColor = self.onColor;
        background.layer.borderColor = self.onColor.CGColor;
        onImageView.alpha = 1.0;
        offImageView.alpha = 0;
    }
}
- (void)showOff:(BOOL)animated {
    CGFloat normalKnobWidth = 49;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated) {
        isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking) {
                knob.frame = CGRectMake(1, knob.frame.origin.y, activeKnobWidth, knob.frame.size.height);
                background.backgroundColor = self.activeColor;
            }
            else {
                knob.frame = CGRectMake(1, knob.frame.origin.y, normalKnobWidth, knob.frame.size.height);
                background.backgroundColor = self.offColor;
                background.layer.borderColor = self.offColor.CGColor;
            }
            
            onImageView.alpha = 0;
            offImageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            isAnimating = NO;
        }];
    }
    else {
        if (self.tracking) {
            knob.frame = CGRectMake(1, knob.frame.origin.y, activeKnobWidth, knob.frame.size.height);
            background.backgroundColor = self.activeColor;
        }
        else {
            knob.frame = CGRectMake(1, knob.frame.origin.y, normalKnobWidth, knob.frame.size.height);
            background.backgroundColor = self.offColor;
        }
        background.layer.borderColor = self.offColor.CGColor;
        onImageView.alpha = 0;
        offImageView.alpha = 1.0;
    }
}

@end
