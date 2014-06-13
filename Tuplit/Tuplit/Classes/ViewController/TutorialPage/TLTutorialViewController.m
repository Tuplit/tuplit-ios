//
//  TLTutorialViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 12/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLTutorialViewController.h"

@interface TLTutorialViewController ()<UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *labelHeader, *labelDesc;
    IBOutlet UIButton *buttonNext, *buttonPrev, *buttonSkip;
    IBOutlet UIView *viewFooterBase;
    int numberOfSlides;
    NSTimer *timer;
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
    // Do any additional setup after loading the view from its nib.
    
    NSString *actualString = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit. Curabitur ac pretium ante. Suspendisse feugiat varous placerat.\n\nFusce eu nisi ac tellus scelerisque euismod in vel nibh. Ut congue enim ac dolor.\n\nPellentesque in aliquam est.";
    
    labelDesc.text = actualString ;
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = APP_DELEGATE.defaultColor;
    
    // To manage the number of slides
    numberOfSlides = [Global instance].tutorialScreenImages.count;
    for(int i = 0; i<numberOfSlides ; i++) {
        EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:nil imageViewFrame:CGRectMake(i*320, 0, 320, scrollView.frame.size.height)];
        imageView.imageURL = [NSURL URLWithString:[Global instance].tutorialScreenImages[i]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [scrollView addSubview:imageView];
    }
    
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [scrollView setContentSize:CGSizeMake(320*numberOfSlides, 0)];
    [scrollView setContentOffset:CGPointMake(0, 0)];
    
    scrollView.backgroundColor = [UIColor clearColor];
    [buttonSkip setTitleColor:APP_DELEGATE.defaultColor forState:UIControlStateNormal];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    [self performSelector:@selector(timerFireDelay) withObject:nil afterDelay:3];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action methods


- (void)timerFireDelay {
    
    [timer fire];
}

- (void)timerMethod {
    
    int page = 0;
    if(((scrollView.contentOffset.x) / 320) == numberOfSlides-1)
        page = 0;
    else
        page = ((scrollView.contentOffset.x) / 320)+1;
    
    int offsetX = page * scrollView.width;
    int offsetY = 0;
    
    CGPoint offset = CGPointMake(offsetX, offsetY);
	[self setScrollOffset:offset];
}

- (IBAction)skipAction:(id)sender {
    
    [TLUserDefaults setIsTutorialSkipped:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextAction:(id)sender {
    
    NSInteger page = (scrollView.contentOffset.x) / 320;
    page++;
    
    if(page==numberOfSlides) {
        [buttonNext setImage:getImage(@"TutorNextLight", NO) forState:UIControlStateNormal];
        
    } else {
        [self setScrollOffset:CGPointMake(page*320, 0)];
        [buttonNext setImage:getImage(@"TutorNext", NO) forState:UIControlStateNormal];
    }
}

- (IBAction)previousAction:(id)sender {
    
    NSInteger page = (scrollView.contentOffset.x) / 320;
    page++;
    
    if(page == 1) {
        [buttonPrev setImage:getImage(@"TutorPreviousLight", NO) forState:UIControlStateNormal];
    } else {
        [buttonPrev setImage:getImage(@"TutorPrevious", NO) forState:UIControlStateNormal];
        [self setScrollOffset:CGPointMake((page-2)*320, 0)];
    }
}

- (void)setScrollOffset:(CGPoint)offset {
    
    if(numberOfSlides == 1) {
        [buttonNext setImage:getImage(@"TutorNext", NO) forState:UIControlStateNormal];
        [buttonPrev setImage:getImage(@"TutorPrevious", NO) forState:UIControlStateNormal];
        
    } else if(offset.x == 0) {
        [buttonPrev setImage:getImage(@"TutorPreviousLight", NO) forState:UIControlStateNormal];
        [buttonNext setImage:getImage(@"TutorNext", NO) forState:UIControlStateNormal];
    } else if (offset.x == numberOfSlides*320) {
        [buttonPrev setImage:getImage(@"TutorPrevious", NO) forState:UIControlStateNormal];
        [buttonNext setImage:getImage(@"TutorNextLight", NO) forState:UIControlStateNormal];
    } else {
        [buttonPrev setImage:getImage(@"TutorPrevious", NO) forState:UIControlStateNormal];
        [buttonNext setImage:getImage(@"TutorNext", NO) forState:UIControlStateNormal];
    }
    
    [scrollView setContentOffset:offset animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_ {
    
    [self setScrollOffset:scrollView.contentOffset];
}


@end

