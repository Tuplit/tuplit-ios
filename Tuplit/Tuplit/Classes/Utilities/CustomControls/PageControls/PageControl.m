//
//  PageControl.m
//  Tuplit
//
//  Created by ev_mac6 on 29/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "PageControl.h"

@implementation PageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    activeImage   = [UIImage imageNamed:@"PageCurrent"];
    inactiveImage = [UIImage imageNamed:@"PageOther"];
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self updateDots];
}

-(void) updateDots
{
    if(SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        for (int i = 0; i < [self.subviews count]; i++)
        {
            UIImageView* dot = [self.subviews objectAtIndex:i];
            
            dot.width = 5;
            dot.height = 2;
            dot.clipsToBounds = YES;
            
            if (i == self.currentPage) dot.image = activeImage;
            else dot.image = inactiveImage;
        }
    } else {
        for (int i = 0; i < [self.subviews count]; i++)
        {
            UIImageView * dot = [self imageViewForSubview:  [self.subviews objectAtIndex: i]];
            if (i == self.currentPage) dot.image = activeImage;
            else dot.image = inactiveImage;
        }
    }
}

- (UIImageView *) imageViewForSubview: (UIView *) view
{
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]])
    {
        for (UIView* subview in view.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 2)];
            [view addSubview:dot];
        }
    }
    else
    {
        dot = (UIImageView *) view;
    }
    
    return dot;
}

- (void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

@end


