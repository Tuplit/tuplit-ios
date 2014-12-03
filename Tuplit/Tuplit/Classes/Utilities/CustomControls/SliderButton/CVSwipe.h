//
//  SliderButton.h
//  Tuplit
//
//  Created by ev_mac8 on 17/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CVSwipe;

@protocol CVSwipeProtocol <NSObject>

-(void) performAction;

@end

@interface CVSwipe : UIControl
{
    UILabel	*swipeLbl ;
    CGFloat value;
}

@property(nonatomic,retain) id <CVSwipeProtocol> delegate;
@property(nonatomic,strong) UISlider *swipeSlider;

- (id)initWithFrame:(CGRect)frame withImage:(UIImage*)image;
-(void)setSliderImage:(UIImage*)image;

@end
