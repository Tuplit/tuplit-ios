//
//  SlideShowView.h
//  Tuplit
//
//  Created by ev_mac11 on 28/08/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideShowView : UIScrollView<UIScrollViewDelegate>
{
    int numberOfSlides;
    NSTimer *timer;
    int leftPos,rightPos,pos;
    BOOL isTimer;
    double width,height;
    UIView *codeSelectorView;
    float xposition;
    UIImageView *bgimageView;
}

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) CGRect scrollFrame;
@property (strong,nonatomic)NSArray *slideShowImages;
@property (strong,nonatomic)NSArray *placeholderImages;
@property (assign,nonatomic)int slideShowInterval;
@property BOOL isShowPageControl;
@property BOOL isWelcome;
-(void)loadData;
- (IBAction)previousAction:(id)sender;
- (IBAction)nextAction:(id)sender;

@end
