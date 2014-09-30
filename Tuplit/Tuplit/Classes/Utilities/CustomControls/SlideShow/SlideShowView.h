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
}

@property (strong,nonatomic)NSArray *slideShowImages;
@property (assign,nonatomic)int slideShowInterval;
-(void)loadData;
- (IBAction)previousAction:(id)sender;
- (IBAction)nextAction:(id)sender;
@end
