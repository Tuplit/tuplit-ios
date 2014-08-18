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

@synthesize inactiveColor, activeColor, onColor, borderColor, knobColor;
@synthesize onImage, offImage;
@synthesize isRounded;
@synthesize on;

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 50, 25)];
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
        initialFrame = CGRectMake(0, 0, 50, 25);
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
    self.activeColor = [UIColor clearColor];
    self.onColor = [APP_DELEGATE defaultColor];
    self.offColor= [UIColor lightGrayColor];
   // self.borderColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.91f alpha:1.00f];
    self.knobColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grayBg.png"]];
    
    // background
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    background.backgroundColor = self.offColor;
    background.layer.borderColor = self.offColor.CGColor;
    background.layer.cornerRadius = self.frame.size.height * 0.5;
    background.layer.borderWidth = 1.0;
    background.userInteractionEnabled = NO;
    [self addSubview:background];
    
    // images
    offImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,50, 35) ];
    offImageView.alpha = 1.0;
    offImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:offImageView];
    
    onImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(offImageView.frame) + 2, 0, 46, 35)];
    onImageView.alpha = 0;
    onImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:onImageView];
    
    noLabel = [[UILabel alloc] initWithFrame:CGRectMake(-2, 0, self.frame.size.width - self.frame.size.height - 15, self.frame.size.height)];
    noLabel.textColor=[UIColor blackColor];
    noLabel.backgroundColor=[UIColor clearColor];
	noLabel.textAlignment = NSTextAlignmentCenter;
    [background addSubview:noLabel];    
    
    yesLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height + 17, 0, self.frame.size.width - self.frame.size.height - 18, self.frame.size.height)];
    yesLabel.textColor=[UIColor whiteColor];
    yesLabel.backgroundColor=[UIColor clearColor];
    yesLabel.textAlignment = NSTextAlignmentCenter;
    [background addSubview:yesLabel];

    // knob
    knob = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 49, self.frame.size.height + 3)];
    knob.backgroundColor = self.knobColor;
    knob.layer.masksToBounds = YES;
    knob.userInteractionEnabled = NO;
    [self addSubview:knob];
    
    isAnimating = NO;
    
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    
    // start timer to detect tap later in endTrackingWithTouch:withEvent:
    startTime = [[NSDate date] timeIntervalSince1970];
    isAnimating = YES;  
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
        CGFloat normalKnobWidth = self.bounds.size.height;
        knob.frame = CGRectMake(knob.frame.origin.x, knob.frame.origin.y, normalKnobWidth,35);
        [self setOn:!self.on animated:YES];
    }
    else {
        // Get touch location
        CGPoint lastPoint = [touch locationInView:self];
        
        // update the switch to the correct value depending on if
        // their touch finished on the right or left side of the switch
        if (lastPoint.x > self.bounds.size.width * 0.5)
            [self setOn:NO animated:YES];
        else
            [self setOn:YES animated:YES];
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
        offImageView.frame = CGRectMake(0, 0,50,35);
        onImageView.frame = CGRectMake(CGRectGetMaxX(offImageView.frame) + 2, 0, 46, 35);
        
        //Label
        noLabel.frame = CGRectMake(-2, 0, frame.size.width - frame.size.height-15, frame.size.height);
		yesLabel.frame = CGRectMake(frame.size.height+ 17, 0, frame.size.width - frame.size.height -18 ,35);

        // knob
        
         knob.frame = CGRectMake(self.bounds.size.width - 49, knob.frame.origin.y, 49, 35);
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

- (void)setOnImage:(UIImage *)image {
    onImage = image;
    onImageView.image = image;
}

- (void)setOffImage:(UIImage *)image {
    offImage = image;
    offImageView.image = image;
}

- (void)setOffText:(NSString *)offText
{
	_offText = offText;
	noLabel.text = offText;
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



/*
 *	Sets the text that shows when the switch is off.
 *  The text is centered in the area not covered by the knob.
 */

- (void)setIsRounded:(BOOL)rounded {
    isRounded = rounded;
    
    if (rounded) {
        background.layer.cornerRadius = self.frame.size.height * 0.5;
    }
    else {
        background.layer.cornerRadius = 2;
    }
}

- (void)setOn:(BOOL)isOn 
{
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

- (void)showOn:(BOOL)animated
{
    CGFloat normalKnobWidth = 49;
    CGFloat activeKnobWidth = normalKnobWidth + 1;
    
    if (animated) {
        isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking) 
            {
                knob.frame = CGRectMake(self.bounds.size.width - activeKnobWidth+1, knob.frame.origin.y, activeKnobWidth-1, 35);
                background.backgroundColor = self.offColor;
                background.layer.borderColor = self.offColor.CGColor;
                onImageView.hidden=YES;
                offImageView.hidden=NO;
            }
            else {
                knob.frame = CGRectMake(0, 0, normalKnobWidth,35);
                background.backgroundColor = self.onColor;
                background.layer.borderColor = self.onColor.CGColor;
                onImageView.alpha=1.0;
                offImageView.alpha =0;
                onImageView.hidden=NO;
            }
        } completion:^(BOOL finished) {
            isAnimating = NO;
        }];
    }
    else {
        if (self.tracking) 
            knob.frame = CGRectMake(self.bounds.size.width - activeKnobWidth+1, knob.frame.origin.y, activeKnobWidth, 35);
        else
            knob.frame = CGRectMake(0, 0, normalKnobWidth,35);
    
        onImageView.hidden=NO;
        background.backgroundColor = self.onColor;
        background.layer.borderColor = self.onColor.CGColor;
    } 
    
      /*
    
    if (animated) {
        isAnimating = YES;
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking){
                
                NSLog(@"%f %f",self.bounds.size.width, normalKnobWidth);
                
                knob.frame = CGRectMake(self.bounds.size.width - normalKnobWidth, knob.frame.origin.y, normalKnobWidth, 35);
                
                background.backgroundColor = self.offColor;
                background.layer.borderColor = self.offColor.CGColor;
            }
            else
            {
                knob.frame = CGRectMake(0, 0, normalKnobWidth,35);
            
            background.backgroundColor = self.onColor;
            background.layer.borderColor = self.onColor.CGColor;
            }
            onImageView.alpha = 1.0;
            offImageView.alpha = 0;
        } completion:^(BOOL finished) {
            isAnimating = NO;
        }];
    } */
}
- (void)showOff:(BOOL)animated 
{
    CGFloat normalKnobWidth = 49;
    CGFloat activeKnobWidth = normalKnobWidth + 1;
    
    if (animated) {
        isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking){
                knob.frame = CGRectMake(0, knob.frame.origin.y, activeKnobWidth-1,35);
                background.backgroundColor = self.onColor;
                background.layer.borderColor = self.onColor.CGColor;
                onImageView.hidden=NO;
                offImageView.hidden=YES;
            }
            else {
                knob.frame = CGRectMake(self.bounds.size.width - normalKnobWidth , knob.frame.origin.y, normalKnobWidth, 35);
            background.backgroundColor = self.offColor;
            background.layer.borderColor = self.offColor.CGColor;
            onImageView.alpha = 0;
            offImageView.alpha=1.0;
            offImageView.hidden=NO;

            }
        } completion:^(BOOL finished) {
            isAnimating = NO;
        }];
    }
    else {
        if (self.tracking)
            knob.frame = CGRectMake(0, knob.frame.origin.y, activeKnobWidth-1,35);
        else
            knob.frame = CGRectMake(self.bounds.size.width - normalKnobWidth, knob.frame.origin.y, normalKnobWidth, 35);
      
        background.backgroundColor = self.offColor;
        background.layer.borderColor = self.offColor.CGColor;
        offImageView.hidden=NO;

    } 

    /*
    if (animated) {
        isAnimating = YES;
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking) {
                knob.frame = CGRectMake(-1, knob.frame.origin.y, normalKnobWidth + 1,35);
                background.backgroundColor = self.onColor;
                background.layer.borderColor = self.onColor.CGColor;
            }
            else {
                knob.frame = CGRectMake(self.bounds.size.width - normalKnobWidth, knob.frame.origin.y, normalKnobWidth, 35);
            background.backgroundColor = self.offColor;
                background.layer.borderColor = self.offColor.CGColor; }
            onImageView.alpha = 0;
            offImageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            isAnimating = YES;
        }];
    } */
}

@end
