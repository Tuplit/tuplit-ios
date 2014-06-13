
#import "PhotoCropperScrollView.h"


@implementation PhotoCropperScrollView
@synthesize imageContainer;
@synthesize orientation;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image {
	
	self = [super initWithFrame:frame];
	
	if (self) {
		
		[self setExclusiveTouch:YES];
		[self setClipsToBounds:NO];
		[self setMaximumZoomScale:2.0f];
		[self setShowsVerticalScrollIndicator:YES];
		[self setShowsHorizontalScrollIndicator:YES];
		[self setBouncesZoom:YES];
		[self setAlwaysBounceVertical:YES];
		[self setAlwaysBounceHorizontal:YES];
		[self setDecelerationRate:UIScrollViewDecelerationRateFast];
		[self setContentMode:UIViewContentModeCenter];
		
		self.imageContainer = [[UIImageView alloc]initWithFrame:CGRectZero];
		[self.imageContainer setAlpha:1.0];
		[self.imageContainer setBackgroundColor:[UIColor clearColor]];
		[self.imageContainer setImage:image];
		[self.imageContainer sizeToFit];
		[self addSubview:imageContainer];
		self.backgroundColor = [UIColor clearColor];
		
		[self setContentInset:UIEdgeInsetsMake(58, 10, 58, 10)];
	}
	
	return self;
}

- (void)dealloc {
    
    imageContainer = nil;
    [super dealloc];
}

- (void)layoutSubviews {
	
    [super layoutSubviews];
    
    /* center the image as it becomes smaller than the size of the screen */
	
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter =  self.imageContainer.frame;
	
    /* center horizontally */
	
    if (frameToCenter.size.width < boundsSize.width) {
		
		frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
		frameToCenter.origin.x -= self.contentInset.left;
	}
    else {
		
		frameToCenter.origin.x  = -self.contentInset.left;
	}
	
    /* center vertically */
	
    if (frameToCenter.size.height < boundsSize.height) {
		
		frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
		frameToCenter.origin.y -= self.contentInset.top;
		
	} else {
		
		frameToCenter.origin.y = -self.contentInset.top;
	}
    
	CGSize contentSize_ = self.imageContainer.frame.size;
	contentSize_.width += self.contentOffsetInset.width;
	contentSize_.height += self.contentOffsetInset.height;
	[self setContentSize:contentSize_];
	
	self.imageContainer.center = CGPointMake(self.contentSize.width/2 , self.contentSize.height/2);
}


- (void)centerContentView {
	
	self.imageContainer.center = CGPointMake(self.contentSize.width/2 , self.contentSize.height/2);
}


@end
