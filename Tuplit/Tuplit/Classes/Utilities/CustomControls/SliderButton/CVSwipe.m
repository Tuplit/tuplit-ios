//
//  SliderButton.m
//  Tuplit
//
//  Created by ev_mac8 on 17/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "CVSwipe.h"

//static const int animationFramesPerSec = 8;

@implementation CVSwipe
@synthesize delegate,swipeSlider;

-(id) initWithFrame:(CGRect)frame withImage:(UIImage *)image
{
    self = [super initWithFrame:frame];

    if (self) 
    {
        self.backgroundColor=[UIColor clearColor];
        
        swipeSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 221, 40)];
        CGRect sliderFrame = swipeSlider.frame;
        swipeSlider.frame = sliderFrame;
        swipeSlider.backgroundColor = [UIColor clearColor];
        [swipeSlider setMinimumTrackImage:[UIImage imageNamed:@"Nothing"] forState:UIControlStateNormal];
        [swipeSlider setMaximumTrackImage:[UIImage imageNamed:@"Nothing"] forState:UIControlStateNormal];
        [swipeSlider setThumbImage:image forState:UIControlStateNormal];
        swipeSlider.minimumValue = 0.0;
        swipeSlider.maximumValue = 1.0;
        swipeSlider.continuous = YES;
        swipeSlider.value = 0.0;
        [swipeSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        [swipeSlider addTarget:self action:@selector(touchesEnded:withEvent:) forControlEvents:UIControlEventValueChanged];
        NSString *labelText = NSLocalizedString(@"SWIPE_TO_CHECKOUT", @"SWIPE_TO_CHECKOUT");
        swipeLbl = [[UILabel alloc] initWithFrame:CGRectMake(40,0,200,40)];
        swipeLbl.center = CGPointMake(110,20);
        swipeLbl.textColor =UIColorFromRGB(0x333333);
        swipeLbl.textAlignment = NSTextAlignmentCenter;
        swipeLbl.backgroundColor =UIColorFromRGB(0xDbDbDb);
        swipeLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];;
        swipeLbl.text = labelText;
        [self addSubview:swipeLbl];
        [self addSubview:swipeSlider];
        
    }
    return self;
}
-(void)setSliderImage:(UIImage*)image
{
    [swipeSlider setThumbImage:image forState:UIControlStateNormal];
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [event.allTouches anyObject];
    
    if( touch.phase != UITouchPhaseMoved && touch.phase != UITouchPhaseBegan )
    {
        if (swipeSlider.value >= 0.65)
        {
            if (swipeSlider.value >=0.96)
            {
                [delegate performAction];
            }
            else
            {
               
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView animateWithDuration:0.2 animations:^{
                    [swipeSlider setFrame:CGRectMake(180, 0, 40, 40)];
                    [self performSelector:@selector(viewControlAction) withObject:nil afterDelay:0.2 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                }];
            }
            [swipeSlider setValue:0 animated: YES];
            swipeLbl.alpha = 1.0;
        }
        else if (swipeSlider.value <0.65)
        {
            [swipeSlider setValue:0 animated: YES];
            swipeLbl.alpha = 1.0;
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView animateWithDuration:1.0 animations:^{
                [swipeSlider setFrame:CGRectMake(0, 0, 221, 40)];
            }];
        }
    }
}

-(void) viewControlAction
{
    [delegate performAction];
    [swipeSlider setFrame:CGRectMake(0, 0, 221, 40)];
}

- (void) sliderChanged: (UISlider *) sender
{
    swipeLbl.alpha = MAX(0.0, 1.0 - (swipeSlider.value * 3.5));
    value=sender.value;
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:0.1 animations:^{
            [swipeSlider setFrame:CGRectMake(0, 0, 221, 40)];
        }];
}

@end
