//
//  SlideShowView.m
//  Tuplit
//
//  Created by ev_mac11 on 28/08/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "SlideShowView.h"

@implementation SlideShowView
@synthesize slideShowImages;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
     
    }
    return self;
}

-(void)loadData
{
    numberOfSlides = [self.slideShowImages count];
    
    width = self.width;
    height = self.height;
    
    for (int i = 0; i < numberOfSlides; i++) {
        
         [self addImageWithName:[NSURL URLWithString:self.slideShowImages[i]] atPosition:i];
    }
     [self addImageWithName:[NSURL URLWithString:self.slideShowImages[0]] atPosition:numberOfSlides]; 
    self.translatesAutoresizingMaskIntoConstraints  = NO;
    self.bounces = NO;
    self.delegate = self;
    if(numberOfSlides>1)
    {
        self.pagingEnabled = YES;
        self.contentSize = CGSizeMake((width*numberOfSlides)+ width, height);
    }
    else
    {
        self.contentSize = CGSizeMake(width, height);
    }
    [self scrollRectToVisible:CGRectMake(0,0,width,height) animated:NO];
    [self setContentOffset:CGPointMake(0, 0)];

    [self timerAction];
}

- (void)addImageWithName:(NSURL*)imageString atPosition:(int)position
{
    EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:nil imageViewFrame:CGRectMake(position*width, 0, width, height)];
    imageView.imageURL = imageString;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self  addSubview:imageView];
    
}

-(void) timerAction
{
    [timer invalidate];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:self.slideShowInterval target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    //    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //    [self performSelector:@selector(timerFireDelay) withObject:nil afterDelay:8];
    
}

- (void)timerFireDelay
{
    [timer fire];
}

- (void)timerMethod
{
    NSInteger page = (self.contentOffset.x) / width;
    
    if (page == numberOfSlides)
        page=0;
    else
        page++;
    
    //    if (page == 5)
    //        page=0;
    
    int offsetX = page * width;
    int offsetY = 0;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self setScrollOffset:offset];
}

- (IBAction)previousAction:(id)sender
{
    [self timerAction];
    NSInteger page = (self.contentOffset.x) / width;
    ++page;
    if(page == 1)
    {
        [self previousButtonAction];
    }
    else
    {
        [self setScrollOffset:CGPointMake((page-2)*width, 0)];
        leftPos=0;
    }
}

-(void) previousButtonAction
{
    [self timerAction];
    if(leftPos< numberOfSlides +1)
    {
        leftPos +=1;
        if (leftPos == numberOfSlides +1)
        {
            leftPos=1;
        }
        NSLog(@"%d",numberOfSlides-leftPos);
        [self addImageWithName:[NSURL URLWithString:[Global instance].tutorialScreenImages[numberOfSlides-leftPos]] atPosition:numberOfSlides-leftPos];
        [self setContentOffset:CGPointMake(width*(numberOfSlides), 0)];
    }
    if (numberOfSlides-leftPos == 1)
    {
        [self scrollRectToVisible:CGRectMake(width*(numberOfSlides+1),0,width,height) animated:NO];
    }
}

- (IBAction)nextAction:(id)sender {
    [self timerAction];
    NSInteger page = (self.contentOffset.x) / width;
    page++;

    [self timerAction];
    if(page==numberOfSlides)
    {
        [self nextButtonAction];
    }
    else
    {
        [self setScrollOffset:CGPointMake(page*width, 0)];
    }
}

-(void) nextButtonAction
{
    [self timerAction];
    if(rightPos< numberOfSlides +1)
    {
        rightPos +=1;
        if (rightPos == numberOfSlides +1)
        {
            rightPos=1;
        }
        
        [self addImageWithName:[NSURL URLWithString:[Global instance].tutorialScreenImages[rightPos-1]] atPosition:rightPos-1];
        [self setContentOffset:CGPointMake(0, 0)];
        
        if (rightPos-1 == numberOfSlides- 1)
        {
            [self scrollRectToVisible:CGRectMake(0,0,width,height) animated:NO];
        }
    }
}

- (void)setScrollOffset:(CGPoint)offset
{
    if(numberOfSlides>1)
    {
        if (offset.x == width*(numberOfSlides))
        {
            [self scrollRectToVisible:CGRectMake(0,0,width,height) animated:NO];
        }
        else
            [self setContentOffset:offset animated:YES];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [timer invalidate];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    if(numberOfSlides>1)
    {
        if (self.contentOffset.x == 0)
        {
            [self scrollRectToVisible:CGRectMake(width*(numberOfSlides),0,width,height) animated:NO];
        }
        else if (self.contentOffset.x == width*numberOfSlides)
        {
            [self scrollRectToVisible:CGRectMake(0,0,width,height) animated:NO];
        }
    }
    [self timerAction];
}

@end
