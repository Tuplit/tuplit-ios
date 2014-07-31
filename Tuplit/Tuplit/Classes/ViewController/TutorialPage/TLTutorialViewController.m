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
    EGOImageView *imageView;
    int numberOfSlides;
    NSTimer *timer;
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
    
//    self.view.backgroundColor = APP_DELEGATE.defaultColor;
    self.view.backgroundColor=UIColorFromRGB(0x31869B);
    
    numberOfSlides = [Global instance].tutorialScreenImages.count;
    leftPos=0;
    rightPos=0;
    
    buttonNext.tag=101;
    buttonNext.tag=100;
    
    [self addImageWithName:[NSURL URLWithString:[Global instance].tutorialScreenImages[numberOfSlides-1]] atPosition:0];

    for(int i = 0; i<numberOfSlides; i++) 
    {
        [self addImageWithName:[NSURL URLWithString:[Global instance].tutorialScreenImages[i]] atPosition:i];
    }	
    [self addImageWithName:[NSURL URLWithString:[Global instance].tutorialScreenImages[0]] atPosition:numberOfSlides];
    
    scrollView.bounces = NO;
    scrollView.delegate = self;
	scrollView.contentSize = CGSizeMake((320*numberOfSlides)+ 320, 324); 
	[scrollView scrollRectToVisible:CGRectMake(0,0,320,324) animated:NO]; 
    [scrollView setContentOffset:CGPointMake(0, 0)];
    
    [buttonSkip setTitleColor:APP_DELEGATE.defaultColor forState:UIControlStateNormal];
    
    isTimer =YES;
    [self timerAction];
}

-(void) timerAction
{
    if (!isTimer)
    {
        [timer invalidate];
    }
    else
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [self performSelector:@selector(timerFireDelay) withObject:nil afterDelay:3];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    isTimer=YES;
    [self timerAction];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action methods

- (void)addImageWithName:(NSURL*)imageString atPosition:(int)position 
{
    imageView = [[EGOImageView alloc] initWithPlaceholderImage:nil imageViewFrame:CGRectMake(position*320, 0, 320, scrollView.frame.size.height)];
    imageView.imageURL = imageString;    
    imageView.contentMode = UIViewContentModeScaleToFill;
    [scrollView addSubview:imageView];
    
}
- (void)timerFireDelay 
{
    [timer fire];
}

- (void)timerMethod
{
    NSInteger page = (scrollView.contentOffset.x) / 320;
    
    if (page == numberOfSlides)
        page=0;
    else
        page++;
    
    if (page == 5)
        page=0;
    
    int offsetX = page * scrollView.width;
    int offsetY = 0;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self setScrollOffset:offset];
}

- (IBAction)skipAction:(id)sender {
    
    [TLUserDefaults setIsTutorialSkipped:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)previousAction:(id)sender 
{
    NSInteger page = (scrollView.contentOffset.x) / 320;
    ++page;
    if(page == 1) 
    {
        [self previousButtonAction];  
    }
    else 
    {
        [self setScrollOffset:CGPointMake((page-2)*320, 0)];
        leftPos=0;
    }
}

-(void) previousButtonAction
{
    if(leftPos< numberOfSlides +1)
    {
        leftPos +=1;
        if (leftPos == numberOfSlides +1)
        {
            leftPos=1;
        }
        NSLog(@"%d",numberOfSlides-leftPos);
        [self addImageWithName:[NSURL URLWithString:[Global instance].tutorialScreenImages[numberOfSlides-leftPos]] atPosition:numberOfSlides-leftPos];
        [scrollView setContentOffset:CGPointMake(320*(numberOfSlides), 0)];
    } 
    if (numberOfSlides-leftPos == 1)
    {
        [scrollView scrollRectToVisible:CGRectMake(320*(numberOfSlides+1),0,320,324) animated:NO]; 
    }
}

- (IBAction)nextAction:(id)sender {
    
    NSInteger page = (scrollView.contentOffset.x) / 320;
    page++;
    isTimer=NO;
    [self timerAction];
    if(page==numberOfSlides)
    {
        [self nextButtonAction];
    } 
    else
    {
        [self setScrollOffset:CGPointMake(page*320, 0)];
    }
}

-(void) nextButtonAction
{
    if(rightPos< numberOfSlides +1)
    {
        rightPos +=1;
        if (rightPos == numberOfSlides +1)
        {
            rightPos=1;
        }
        
        [self addImageWithName:[NSURL URLWithString:[Global instance].tutorialScreenImages[rightPos-1]] atPosition:rightPos-1];
        [scrollView setContentOffset:CGPointMake(0, 0)];
        
        if (rightPos-1 == numberOfSlides- 1)
        {
            [scrollView scrollRectToVisible:CGRectMake(0,0,320,324) animated:NO];         
        }
    } 
}

- (void)setScrollOffset:(CGPoint)offset 
{
    if (offset.x == 320*(numberOfSlides)) 
    {
        [scrollView scrollRectToVisible:CGRectMake(0,0,320,324) animated:NO];    
    }
    else
        [scrollView setContentOffset:offset animated:YES];   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender 
{            
    if (scrollView.contentOffset.x == 0) 
    {         
        [scrollView scrollRectToVisible:CGRectMake(320*(numberOfSlides),0,320,324) animated:NO];     
	}    
    else if (scrollView.contentOffset.x >= 320*numberOfSlides)
    {         
        [scrollView scrollRectToVisible:CGRectMake(0,0,320,324) animated:NO];         
	} 
}


@end


