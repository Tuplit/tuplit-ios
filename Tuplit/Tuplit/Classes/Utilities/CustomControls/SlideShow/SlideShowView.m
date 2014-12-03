//
//  SlideShowView.m
//  Tuplit
//
//  Created by ev_mac11 on 28/08/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "SlideShowView.h"

#define PAGECONTROL_SPACE 8

@implementation SlideShowView
@synthesize slideShowImages,placeholderImages;
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
    self.scrollFrame = frame;
    return self;
}

-(void)loadData
{
    
    if(self.placeholderImages.count>0)
    {
        numberOfSlides = (int)[self.placeholderImages count];
    }
    else
    {
        numberOfSlides = (int)[self.slideShowImages count];
    }
    
    if(numberOfSlides == 0)
    {
        if(self.isWelcome)
        {
           bgimageView = [[UIImageView alloc]initWithImage:getImage(@"welcomePlaceholder", NO)];
            bgimageView.frame = CGRectMake(0, 0, self.width, self.height);
            [self addSubview:bgimageView];
        }
    }
    else
    {
        width = self.width;
        height = self.height;
        bgimageView.image = nil;
        if(self.placeholderImages.count>0)
        {
            for (int i = 0; i < numberOfSlides; i++) {
                
                [self addImageWithlocalName:self.placeholderImages[i] atPosition:i];
            }
            [self addImageWithlocalName:self.placeholderImages[0] atPosition:numberOfSlides];
        }
        else
        {
            for (int i = 0; i < numberOfSlides; i++) {
                
                [self addImageWithName:[NSURL URLWithString:self.slideShowImages[i]] atPosition:i];
            }
            [self addImageWithName:[NSURL URLWithString:self.slideShowImages[0]] atPosition:numberOfSlides];
        }
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
        
        xposition = (self.width - ((numberOfSlides-1)*PAGECONTROL_SPACE) - ((numberOfSlides-1)*PAGECONTROL_SPACE))/2 - PAGECONTROL_SPACE;
        
        if(self.isShowPageControl)
        {
            codeSelectorView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-100, self.width,50)];
            codeSelectorView.backgroundColor = [UIColor clearColor];
            [self.superview addSubview:codeSelectorView];
            
            for (int i = 0; i<numberOfSlides; i++) {
                UIImage *selectorImg ;//= getImage(@"control", NO);
                if(i==0)
                {
                    selectorImg = getImage(@"control_s", NO);
                }
                else
                {
                    selectorImg = getImage(@"control", NO);
                }
                
                UIImageView *codeSelectorImgView = [[UIImageView alloc]initWithImage:selectorImg];
                codeSelectorImgView.frame = CGRectMake(xposition + PAGECONTROL_SPACE, (codeSelectorView.height - PAGECONTROL_SPACE)/2, PAGECONTROL_SPACE, PAGECONTROL_SPACE);
                codeSelectorImgView.tag = i + 1;
                codeSelectorImgView.backgroundColor=[UIColor clearColor];
                [codeSelectorView addSubview:codeSelectorImgView];
                
                xposition = CGRectGetMaxX(codeSelectorImgView.frame);
            }
        }
        [self timerAction];
    }
    
   
}

- (void)addImageWithName:(NSURL*)imageString atPosition:(int)position
{
    EGOImageView *imageView;
    
    if(self.isWelcome)
    {
        imageView = [[EGOImageView alloc] initWithPlaceholderImage:getImage(@"welcomePlaceholder", NO) imageViewFrame:CGRectMake(position*width, 0, width, height)];
    }
    else
    {
        imageView = [[EGOImageView alloc] initWithPlaceholderImage:nil imageViewFrame:CGRectMake(position*width, 0, width, height)];
    }
    
    imageView.imageURL = imageString;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    [self  addSubview:imageView];
    
}

- (void)addImageWithlocalName:(NSString*)imageName atPosition:(int)position
{
    EGOImageView *imageView;
    imageView = [[EGOImageView alloc] initWithPlaceholderImage:nil imageViewFrame:CGRectMake(position*width, 0, width, height)];
    imageView.image = getImage(imageName, NO);
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
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
    int page = (self.contentOffset.x) / width;
    
    if (page == numberOfSlides)
        page=0;
    else
        page++;
    
//      NSLog(@"page = %d",page);
    [self fillCodeCircles:page+1 andIsRightSwipped:YES];
    
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
    _lastContentOffset = scrollView.contentOffset.x;
    [timer invalidate];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    if(numberOfSlides>1)
    {
         int page = (self.contentOffset.x) / width;
        if (_lastContentOffset < (int)sender.contentOffset.x) {
             [self fillCodeCircles:page+1 andIsRightSwipped:YES];
        }
        else if (_lastContentOffset > (int)sender.contentOffset.x) {
             [self fillCodeCircles:page+1 andIsRightSwipped:NO];
        }
       
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
-(void)fillCodeCircles :(int)tag andIsRightSwipped :(BOOL)isright
{
    //    NSLog(@"tag = %d",tag);
    
    if(self.isShowPageControl)
    {
        for (int i=0; i<numberOfSlides; i++) {
            UIImageView *selectorImage1 = (UIImageView *)[codeSelectorView viewWithTag:i+1];
            [selectorImage1 setImage:getImage(@"control", NO)];
        }
       
        
        if(isright)
        {
            if(tag == numberOfSlides+1)
            {
                UIImageView *selectorImage = (UIImageView *)[codeSelectorView viewWithTag:1];
                [selectorImage setImage:getImage(@"control_s", NO)];
                
            }
            else
            {
                UIImageView *selectorImage = (UIImageView *)[codeSelectorView viewWithTag:tag];
                [selectorImage setImage:getImage(@"control_s", NO)];
            }
        }
        else
        {
            if(tag == numberOfSlides)
            {
                UIImageView *selectorImage = (UIImageView *)[codeSelectorView viewWithTag:4];
                [selectorImage setImage:getImage(@"control_s", NO)];
                
            }
            else
            {
                UIImageView *selectorImage = (UIImageView *)[codeSelectorView viewWithTag:tag];
                [selectorImage setImage:getImage(@"control_s", NO)];
                
            }
        }
    }
    
}

@end
