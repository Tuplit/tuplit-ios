//
//  DiscountView.m
//  Sample
//
//  Created by ev_mac11 on 29/05/14.
//  Copyright (c) 2014 ev_mac11. All rights reserved.
//

#import "ChoiceButton.h"

#define CHOICE_BUTTON_WIDTH 48
#define CHOICE_BUTTON_HEIGHT 23

@implementation ChoiceButton

@synthesize delegate,isSelected;

- (id)initWithFrame:(CGRect)vframe withTitles:(NSArray*) titles
{
    self = [super initWithFrame:vframe];
    
    if (self) {
        
        self.frame = vframe;
        self.backgroundColor = [UIColor clearColor];
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:scrollView];
        
        titleArray = titles;
        
        xVal = 4.5;
        
        int i = 0;
        
        for(NSString *title in titleArray)
        {
            UIButton *dBtn = [[UIButton alloc]initWithFrame:CGRectMake(xVal, 6, CHOICE_BUTTON_WIDTH, CHOICE_BUTTON_HEIGHT)];
            dBtn.tag = i+1;
            dBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            if(i==0)
            {
                [dBtn setBackgroundColor:UIColorFromRGB(0x01b3a5)];
                [dBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                [dBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13]];
            }
            else
            {
                [dBtn setBackgroundColor:UIColorFromRGB(0x7fd9d0)];
                [dBtn setTitleColor:UIColorFromRGB(0x00998c) forState:UIControlStateNormal];
                [dBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
            }
            
            [dBtn setTitle:title forState:UIControlStateNormal];
            
            [dBtn addTarget:self action:@selector(updateLabel:) forControlEvents:UIControlEventTouchDown];
            [scrollView addSubview:dBtn];
            
            isSelected = NO;
            
            xVal += CHOICE_BUTTON_WIDTH + 4.5;
            
            i++;
        }
        [scrollView setContentSize:CGSizeMake(xVal, 34)];
        
        tag = 1;
        
    }
    return self;
}

-(void)updateLabel:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if(tag!=btn.tag)
    {
        if((tag!=btn.tag&&isSelected)||tag==1)
        {
            UIButton *tempBtn = (UIButton*)[self viewWithTag:tag];
            [tempBtn setTitleColor:UIColorFromRGB(0x00998c) forState:UIControlStateNormal];
            [tempBtn setBackgroundColor:UIColorFromRGB(0x7fd9d0)];
            [tempBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
            isSelected = NO;
        }
        if(!isSelected)
        {
            UIButton *tbtn = (UIButton*)sender;
            [tbtn setBackgroundColor:UIColorFromRGB(0x01b3a5)];
            [tbtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [tbtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13]];
            isSelected = YES;
        }
        else
        {
            UIButton *tbtn = (UIButton*)sender;
            [tbtn setTitleColor:UIColorFromRGB(0x00998c) forState:UIControlStateNormal];
            [tbtn setBackgroundColor:UIColorFromRGB(0x7fd9d0)];
            [tbtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
            isSelected = NO;
        }
        
        [delegate choiceButton:self selectedButtonIndex:(int)btn.tag-1];
        
        tag = (int)btn.tag;
    }
}

-(void)setViewHeight:(CGFloat)height
{
    CGRect newRect = self.frame;
    newRect.size.height = height;
    self.frame = newRect;
    scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
@end
