

#import "PhotoMoveAndScaleController.h"
#import <QuartzCore/QuartzCore.h>

@interface PhotoMoveAndScaleController ()

	- (void)cancelEdit;
	- (void)saveEdit;
	- (void)renderVisibleImage;
	- (UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
	- (UIImage *)compressedImageFromImage:(UIImage *)image newSize:(CGSize)new_size;
	- (void)compressOriginalImageIfNeeded;	
	- (void)toggleZoom;
	- (void)timerAction;
	UIImage *myBaby_scaleAndRotateImage(UIImage *image);

@end


@implementation PhotoMoveAndScaleController

@synthesize delegate;
//@synthesize original_image_path, thumbnail_image_path;
@synthesize originalImage, thumbnailImage;
@synthesize imagePath;
@synthesize imageCropperType=_imageCropperType;


- (id)initWithImage:(UIImage *)image imageCropperType:(ImageCropperType)imageCropperType { // imagePath:(NSString *)path {
	
	self = [super init];
	
	if (self) {
			
		//self.imagePath = path;
		self.originalImage = image;
		self.imageCropperType = imageCropperType;
	}
	
	return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}


- (void)dealloc {
    
    baseView = nil;
	scrollViewBase = nil;
	scrollView = nil;
    
    self.delegate = nil;
    self.imagePath = nil;
    self.originalImage = nil;
    self.thumbnailImage = nil;
    [super dealloc];
}

- (void)viewDidUnload {
    
	baseView = nil;
	scrollViewBase = nil;
	scrollView = nil;
    
    self.delegate = nil;
    self.imagePath = nil;
    self.originalImage = nil;
    self.thumbnailImage = nil;
    
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    [UIImage releaseImageCache];
}

- (void)loadView {
    
    [super loadView];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ORIENTATION_CHANGES" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrientationChanges) name:@"ORIENTATION_CHANGES" object:nil];
    
    CGFloat viewHeight = [[UIScreen mainScreen] bounds].size.height;
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
	[self setTitle:@"Move and Scale"];
	
	baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, viewHeight)];
	[baseView setBackgroundColor:[UIColor clearColor]];
	[self setView:baseView];


	scrollViewBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, viewHeight)];
	[scrollViewBase setBackgroundColor:[UIColor blackColor]];
	[baseView addSubview:scrollViewBase];
    
	self.originalImage = myBaby_scaleAndRotateImage(self.originalImage);
	
	scrollView = [[PhotoCropperScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, viewHeight) image:self.originalImage];
	[scrollView setDelegate:self];
    [scrollView setBackgroundColor:[UIColor clearColor]];
	UITapGestureRecognizer *tap_gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleZoom)];
	[tap_gr setNumberOfTapsRequired:2];
	[scrollView addGestureRecognizer:tap_gr];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
	[scrollViewBase addSubview:scrollView];
    
	CGRect frame = scrollView.imageContainer.frame;
    frame.origin.x = -scrollView.contentOffset.x;
    frame.origin.y = -scrollView.contentOffset.y;
	scrollView.imageContainer.frame = frame;
        
	[scrollView setContentSize:scrollView.imageContainer.frame.size];
	
    
    baseFrame = CGRectMake(0, 0, 320, viewHeight);
    
    CGRect topViewFrame,bottomViewFrame,leftViewFrame,rightViewFrame,topBorderFrame,bottomBorderFrame,leftBorderFrame,rightBorderFrame;
    
    if(self.imageCropperType == kImageCropperTypeProfileImage) {
        
        topViewFrame = CGRectMake(0, 0, 320, ((viewHeight-320)/2)-1);
        bottomViewFrame = CGRectMake(0, CGRectGetMaxY(topViewFrame)+320+1, 320, ((viewHeight-320)/2));
        leftViewFrame = CGRectMake(0, 0, 0, 0);
        rightViewFrame = CGRectMake(0, 0, 0, 0);
        topBorderFrame = CGRectMake(0, CGRectGetMaxY(topViewFrame), 320, 1);
        bottomBorderFrame = CGRectMake(0, bottomViewFrame.origin.y-1, 320, 1);
        leftBorderFrame = CGRectMake(0, CGRectGetMaxY(topBorderFrame), 1, bottomViewFrame.origin.y-1-CGRectGetMaxY(topBorderFrame));
        rightBorderFrame = CGRectMake(319, CGRectGetMaxY(topBorderFrame), 1, CGRectGetHeight(leftBorderFrame));
        
    } else if (self.imageCropperType == kImageCropperTypeBackgroundImage) {
        
        topViewFrame = CGRectMake(0, 0, 320, ((viewHeight-110)/2)-1);
        bottomViewFrame = CGRectMake(0, CGRectGetMaxY(topViewFrame)+110+1, 320, ((viewHeight-110)/2));
        leftViewFrame = CGRectMake(0, 0, 0, 0);
        rightViewFrame = CGRectMake(0, 0, 0, 0);
        topBorderFrame = CGRectMake(0, CGRectGetMaxY(topViewFrame), 320, 1);
        bottomBorderFrame = CGRectMake(0, bottomViewFrame.origin.y-1, 320, 1);
        leftBorderFrame = CGRectMake(0, CGRectGetMaxY(topBorderFrame), 1, bottomViewFrame.origin.y-1-CGRectGetMaxY(topBorderFrame));
        rightBorderFrame = CGRectMake(319, CGRectGetMaxY(topBorderFrame), 1, CGRectGetHeight(leftBorderFrame));
        
    } else {
        
        topViewFrame = CGRectMake(0, 0, 320, ((viewHeight-320)/2)-1);
        bottomViewFrame = CGRectMake(0, CGRectGetMaxY(topViewFrame)+320+1, 320, ((viewHeight-320)/2));
        leftViewFrame = CGRectMake(0, 0, 0, 0);
        rightViewFrame = CGRectMake(0, 0, 0, 0);
        topBorderFrame = CGRectMake(0, CGRectGetMaxY(topViewFrame), 320, 1);
        bottomBorderFrame = CGRectMake(0, bottomViewFrame.origin.y-1, 320, 1);
        leftBorderFrame = CGRectMake(0, CGRectGetMaxY(topBorderFrame), 1, bottomViewFrame.origin.y-1-CGRectGetMaxY(topBorderFrame));
        rightBorderFrame = CGRectMake(319, CGRectGetMaxY(topBorderFrame), 1, CGRectGetHeight(leftBorderFrame));
    }
    
    UIView *topView = [[UIView alloc] initWithFrame:topViewFrame];
    topView.backgroundColor = UIColorFromRGB(0x000000);
    topView.alpha = 0.7;
    topView.userInteractionEnabled = NO;
    [baseView addSubview:topView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:bottomViewFrame];
    bottomView.backgroundColor = UIColorFromRGB(0x000000);
    bottomView.userInteractionEnabled = NO;
    bottomView.alpha = 0.7;
    [baseView addSubview:bottomView];
    
    UIView *leftView = [[UIView alloc] initWithFrame:leftViewFrame];
    leftView.backgroundColor = UIColorFromRGB(0x000000);
    leftView.userInteractionEnabled = NO;
    leftView.alpha = 0.7;
    [baseView addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:rightViewFrame];
    rightView.backgroundColor = UIColorFromRGB(0x000000);
    rightView.userInteractionEnabled = NO;
    rightView.alpha = 0.7;
    [baseView addSubview:rightView];
    
    UIView *topBorder = [[UIView alloc] initWithFrame:topBorderFrame];
    topBorder.backgroundColor = UIColorFromRGB(0xaaaaaa);
    topBorder.userInteractionEnabled = NO;
    [baseView addSubview:topBorder];
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:bottomBorderFrame];
    bottomBorder.backgroundColor = UIColorFromRGB(0xaaaaaa);
    bottomBorder.userInteractionEnabled = NO;
    [baseView addSubview:bottomBorder];
    
    UIView *leftBorder = [[UIView alloc] initWithFrame:leftBorderFrame];
    leftBorder.backgroundColor = UIColorFromRGB(0xaaaaaa);
    leftBorder.userInteractionEnabled = NO;
    [baseView addSubview:leftBorder];
    
    UIView *rightBorder = [[UIView alloc] initWithFrame:rightBorderFrame];
    rightBorder.backgroundColor = UIColorFromRGB(0xaaaaaa);
    rightBorder.userInteractionEnabled = NO;
    [baseView addSubview:rightBorder];
    
//    UIImage *img;
//    if(SYSTEM_VERSION_LESS_THAN(@"7.0"))
//        img = getImage(@"nav", NO);
//    else
//        img = getImage(@"nav_64", NO);
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    toolbar.frame = CGRectMake(0, 0, 320, SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 64 : 44);
    
//    UIBarButtonItem *leftBarBtnItem=[UIBarButtonItem SSCrossButtonItemWithTarget:self action:@selector(cancelEdit)];
//    
//    UIBarButtonItem *rightBarBtnItem=[UIBarButtonItem SSTickButtonItemWithImage:getImage(@"select",NO) Target:self action:@selector(saveEdit)];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdit)];
    if([cancelBtn respondsToSelector:@selector(tintColor)])
        cancelBtn.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveEdit)];
    if([doneBtn respondsToSelector:@selector(tintColor)])
        doneBtn.tintColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 31.0f : 11.0f, 150, 21.0f)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"Move and Scale"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [toolbar addSubview:titleLabel];
    
    [titleLabel centerHorizontally];
    
    UIBarButtonItem *flexibleSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *items = [[NSArray alloc] initWithObjects:cancelBtn,flexibleSpace1,flexibleSpace2,doneBtn,nil];
    [toolbar setItems:items animated:NO];
    [self.view addSubview:toolbar];
    
    [self recalculation];
}

- (void)recalculation
{
    CGSize imageSize = self.originalImage.size;
	CGSize scrollSize = scrollView.frame.size;
	float image_max_pixel = 0, scroll_max_pixel = 0;
    
	if (imageSize.height > imageSize.width) {
		
		image_max_pixel = imageSize.height;
		scroll_max_pixel = scrollSize.height;
        
	} else {
		
		image_max_pixel = imageSize.width;
		scroll_max_pixel = scrollSize.width;
	}
    
	/*
	float zoomscale = 1.0;
	if (image_max_pixel <= scroll_max_pixel) zoomscale = 1.0;
	else zoomscale = scroll_max_pixel / image_max_pixel;
	[scrollView setMinimumZoomScale:zoomscale];
	*/
	

	if (_imageCropperType == kImageCropperTypeProfileImage) {
		float offsetHeight = 110;
		if ([UI isIPhone5]) offsetHeight += 88;
		scrollView.contentOffsetInset = CGSizeMake(-18, offsetHeight);
	} else if (_imageCropperType == kImageCropperTypeBackgroundImage) {
		float offsetHeight = 250;
		if ([UI isIPhone5]) offsetHeight += 88;
		scrollView.contentOffsetInset = CGSizeMake(-18, offsetHeight);
	} else {
        float offsetHeight = 110;
		if ([UI isIPhone5]) offsetHeight += 88;
		scrollView.contentOffsetInset = CGSizeMake(-18, offsetHeight);
    }
	
	/*
	CGSize contentSize = scrollView.contentSize;
	 if (contentSize.height < 416) contentSize.height = 416;
	 if (contentSize.width < 320) contentSize.width = 320;
	 contentSize.width += 20;
	 contentSize.height += 116;
	[scrollView setContentSize:contentSize];

	
	scrollView.imageContainer.center = CGPointMake(scrollView.contentSize.width/2 , scrollView.contentSize.height/2);
	//ALog(@"%f %f", scrollView.frame.size.height, scrollView.imageContainer.frame.size.height);
	//scrollView.contentOffset = CGPointMake(scrollView.imageContainer.frame.origin.x, scrollView.imageContainer.frame.origin.y);
	 */
	
	float zoomScale = (scrollSize.width/imageSize.width);
	zoomScaleToFit = zoomScale;
	[scrollView setZoomScale:zoomScale];
	[scrollView setMinimumZoomScale:(scrollSize.width/imageSize.width)/2];
	if (zoomScale > 1) {
		scrollView.maximumZoomScale = zoomScale * 3;
	} else {
		scrollView.maximumZoomScale = 2;
	}
	

/*
	CGPoint _offset = scrollView.contentOffset;
	_offset.x = ((scrollView.contentSize.width - scrollView.imageContainer.frame.size.width) / 2) + 10;
	_offset.y = ((scrollView.contentSize.height - scrollView.imageContainer.frame.size.height) / 2) + ([UI isIPhone5]?-18:28);
	[scrollView setContentOffset:_offset animated:NO];
	[scrollView setNeedsDisplay];
 */
}


- (void)viewWillAppear:(BOOL)animated {
    
    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
	[scrollView setZoomScale:zoomScaleToFit];
//	[scrollView setNeedsDisplay];
	
	[self performSelector:@selector(centerScrollView) withObject:nil afterDelay:0.0];
	
	/*
	CGPoint _offset = scrollView.contentOffset;
	_offset.x = ((scrollView.contentSize.width - (scrollView.imageContainer.frame.size.width*zoomScaleToFit)) / 2);
	_offset.y = ((scrollView.contentSize.height- (scrollView.imageContainer.frame.size.height*zoomScaleToFit)) / 2);
	[scrollView setContentOffset:_offset animated:NO];
	[scrollView setNeedsDisplay;
	 */
}


- (void)centerScrollView {
	
	float _width = scrollView.contentSize.width;
	float _height = scrollView.contentSize.height;
	float _x = (_width - scrollView.frame.size.width)/2;
	float _y = (_height - scrollView.frame.size.height)/2;
	CGRect _rect = CGRectMake(_x, _y, scrollView.frame.size.width, scrollView.frame.size.height);
	scrollView.contentOffset = _rect.origin;
}


- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	//[scrollView setZoomScale:zoomScaleToFit];
}


// User Defined Methods ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)toggleZoom {
	
	//ALog(@"zoomScale: %f, min: %f, max: %f", scrollView.zoomScale, scrollView.minimumZoomScale, scrollView.maximumZoomScale);
	//if (scrollView.zoomScale == 1.5 && scrollView.minimumZoomScale == 1.5) return;
	
	if (scrollView.zoomScale < scrollView.maximumZoomScale) {
		
		[scrollView setZoomScale:scrollView.maximumZoomScale animated:YES];
        
	} else {
		
		[scrollView setZoomScale:zoomScaleToFit animated:YES];
	}
}


- (void)compressOriginalImageIfNeeded {
    
	float maxSize = 300;
	CGSize newSize;
	newSize.width = self.originalImage.size.width;
	newSize.height = self.originalImage.size.height;
    
	if (newSize.width <= maxSize && newSize.height <= maxSize)
        return;
	
	if (self.originalImage.size.height > self.originalImage.size.width) {
		
		newSize.height = maxSize;
		newSize.width = (self.originalImage.size.width / self.originalImage.size.height) * maxSize;
		
	}
    else {
		
		newSize.width = maxSize;
		newSize.height = (self.originalImage.size.height / self.originalImage.size.width) * maxSize;
	}
	
	self.originalImage = [self compressedImageFromImage:self.originalImage newSize:newSize];
    
}

- (void)cancelEdit {
    
	[delegate onEditCancelledCropperType:self.imageCropperType];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)saveEdit {
	
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
}


- (void)timerAction {
	
	[self renderVisibleImage];
	[self compressOriginalImageIfNeeded];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [delegate onEditCompletedWithOriginalImage:self.originalImage thumbnailImage:self.thumbnailImage imageCropperType:self.imageCropperType];
    }];
	
    
}


- (void)renderVisibleImage {
    
    CGFloat scale = 1.0;
	if([[UIScreen mainScreen]respondsToSelector:@selector(scale)]) {
		CGFloat tmp = [[UIScreen mainScreen]scale];
		if (tmp > 1.5) {
			scale = 2.0;
		}
	}
    
	if (NULL != UIGraphicsBeginImageContextWithOptions) UIGraphicsBeginImageContextWithOptions(CGSizeMake(baseFrame.size.width, baseFrame.size.height), NO, 0);
	else UIGraphicsBeginImageContext(baseFrame.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
    scrollViewBase.backgroundColor = [UIColor whiteColor];
	[[scrollViewBase layer] renderInContext:context];
	UIImage *original_image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    scrollViewBase.backgroundColor = [UIColor blackColor];
    
	UIImage *cropped_image = nil, *thumbnail = nil;
    
    if (self.imageCropperType == kImageCropperTypeBackgroundImage) {
        
        cropped_image = [self imageByCropping:original_image toRect:BG_IMAGE_CROPPER_RECT];
        thumbnail = [self compressedImageFromImage:cropped_image newSize:BG_IMAGE_THUMBNAIL_SIZE];
        
    } else if (self.imageCropperType == kImageCropperTypeProfileImage) {
        
        cropped_image = [self imageByCropping:original_image toRect:PROFILE_IMAGE_CROPPER_RECT_POTRAIT];
        thumbnail = [self compressedImageFromImage:cropped_image newSize:PROFILE_IMAGE_THUMBNAIL_SIZE];
        
    } else {
        
        cropped_image = [self imageByCropping:original_image toRect:POST_IMAGE_CROPPER_RECT_POTRAIT];
        thumbnail = [self compressedImageFromImage:cropped_image newSize:POST_IMAGE_THUMBNAIL_SIZE];
    }
    
    self.originalImage = cropped_image;
	self.thumbnailImage = thumbnail;
}


- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect {
    
	if (NULL != UIGraphicsBeginImageContextWithOptions) UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
	else UIGraphicsBeginImageContext(rect.size);
	
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
	CGContextClipToRect( currentContext, clippedRect);
	CGRect drawRect = CGRectMake(rect.origin.x * -1, rect.origin.y * -1, imageToCrop.size.width, imageToCrop.size.height);
	CGContextTranslateCTM(currentContext, 0.0, drawRect.size.height);
	CGContextScaleCTM(currentContext, 1.0, -1.0);
	CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return cropped;
}


- (UIImage *)compressedImageFromImage:(UIImage *)image newSize:(CGSize)new_size {
	
	NSData *real_image = UIImagePNGRepresentation(image);
	UIImage *compressed_image = [UIImage imageWithData:real_image];
	if (NULL != UIGraphicsBeginImageContextWithOptions) UIGraphicsBeginImageContextWithOptions(new_size, NO, 0);
	else UIGraphicsBeginImageContext(new_size);
	[compressed_image drawInRect:CGRectMake(0.0, 0.0, new_size.width, new_size.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return newImage;
}

UIImage *myBaby_scaleAndRotateImage(UIImage *image) {
	
    int kMaxResolution = image.size.width > image.size.height? image.size.width:image.size.height;
	
    CGImageRef imgRef = image.CGImage;
	
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
	
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
	if (width > kMaxResolution || height > kMaxResolution) {
        
		CGFloat ratio = width/height;
        
		if (ratio > 1) {
            
			bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
            
		} else {
			
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
	
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
			
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
			
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
			
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
			
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
			
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
			
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
			
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
			
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
			
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
    }
	
    UIGraphicsBeginImageContext(bounds.size);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
	
    CGContextConcatCTM(context, transform);
	
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	//CGImageRelease(imgRef);
	
    return imageCopy;
}



// Scrollview Delegate Methods ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (UIView *)viewForZoomingInScrollView:(PhotoCropperScrollView *)_scrollView {
	
	return scrollView.imageContainer;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView_ {
	
	//NSLog(@"%@", NSStringFromCGPoint(scrollView_.contentOffset));
}


- (void)scrollViewDidZoom:(UIScrollView *)_scrollView
{
    
   /* if (scrollView.imageContainer.frame.size.width < 1024 && scrollView.imageContainer.frame.size.height < 704)
    {
        CGPoint _offset = scrollView.contentOffset;
		_offset.x = (scrollView.contentSize.width - scrollView.frame.size.width) / 2;
		_offset.y = (scrollView.contentSize.height - scrollView.frame.size.height) / 2;
        [_scrollView setContentOffset:_offset animated:YES];
    } */

}


- (void)scrollViewDidEndZooming:(UIScrollView *)_scrollView withView:(UIView *)view atScale:(float)scale {
	
	//if (scrollView.imageContainer.frame.size.width < 1024 && scrollView.imageContainer.frame.size.height < 704) {
    if (scrollView.imageContainer.frame.size.width < 350 && scrollView.imageContainer.frame.size.height < 480) {
		
		CGPoint _offset = scrollView.contentOffset;
		_offset.x = (scrollView.contentSize.width - scrollView.frame.size.width) / 2;
		_offset.y = (scrollView.contentSize.height - scrollView.frame.size.height) / 2;
		[scrollView setContentOffset:_offset animated:YES];
	}
	//}
}


@end
