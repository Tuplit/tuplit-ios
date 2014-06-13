//
//  DiscountView.h
//  Sample
//
//  Created by ev_mac11 on 29/05/14.
//  Copyright (c) 2014 ev_mac11. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChoiceButton;

@protocol ChoiceButtonDelegate <NSObject>

- (void) choiceButton:(ChoiceButton*) choiceButton selectedButtonIndex:(int)index;

@end

@interface ChoiceButton : UIControl
{
    BOOL isSelected;
    float xVal;
    int tag;
    
    NSArray *titleArray;
    UIScrollView *scrollView;
}

- (id)initWithFrame:(CGRect)vframe withTitles:(NSArray*)title;

@property (nonatomic) BOOL isSelected;
@property (nonatomic, unsafe_unretained) id<ChoiceButtonDelegate> delegate;

-(void)setViewHeight:(CGFloat)height;

@end