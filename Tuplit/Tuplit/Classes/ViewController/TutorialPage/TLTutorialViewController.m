//
//  TLTutorialViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 12/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLTutorialViewController.h"
#import "SlideShowView.h"

@interface TLTutorialViewController ()<UIScrollViewDelegate>
{
    IBOutlet UIScrollView *_scrollView;
    SlideShowView *scrollView;
    IBOutlet UILabel *labelHeader, *labelDesc;
    IBOutlet UIButton *buttonNext, *buttonPrev, *buttonSkip;
    IBOutlet UIView *viewFooterBase;
    EGOImageView *imageView;
    UIView *codeSelectorView;
    int numberOfSlides;
    NSTimer *timer;
    float xposition;
    int leftPos,rightPos,pos;
    BOOL isTimer;
}
@end

@implementation TLTutorialViewController


#pragma mark - View life cycle methods.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *actualString = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit. Curabitur ac pretium ante. Suspendisse feugiat varous placerat.\n\nFusce eu nisi ac tellus scelerisque euismod in vel nibh. Ut congue enim ac dolor.\n\nPellentesque in aliquam est.";
    
    labelDesc.text = actualString ;
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }

    numberOfSlides = [Global instance].tutorialScreenImages.count;
    leftPos=0;
    rightPos=0;
    
    buttonNext.tag=101;
    buttonNext.tag=100;
    
    scrollView = [[SlideShowView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, [[UIScreen mainScreen] bounds].size.height)];
//    [scrollView loadData];
    [_scrollView addSubview:scrollView];
    NSArray *placeholderimages = [NSArray arrayWithObjects:@"Tut1",@"Tut2",@"Tut3",@"Tut4", nil];
    scrollView.slideShowInterval = 5;
    scrollView.isWelcome = YES;
    scrollView.slideShowImages = [Global instance].tutorialScreenImages;
    scrollView.placeholderImages = placeholderimages;
    scrollView.isShowPageControl = YES;
    [scrollView loadData];

    scrollView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    imageView.backgroundColor = [UIColor clearColor];
    
     xposition = 72;

//    [buttonSkip setTitleColor:APP_DELEGATE.defaultColor forState:UIControlStateNormal];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)loaddata
{
    scrollView.slideShowImages = [Global instance].tutorialScreenImages;
    [scrollView loadData];
}
- (IBAction)skipAction:(id)sender {
    
    [TLUserDefaults setIsTutorialSkipped:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)previousAction:(id)sender
{
    [scrollView previousAction:sender];
}
- (IBAction)nextAction:(id)sender
{
    [scrollView nextAction:sender];
}

@end


