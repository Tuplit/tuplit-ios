

#import <UIKit/UIKit.h>
#import "PhotoCropperScrollView.h"

typedef enum {
	kImageCropperTypeBackgroundImage = 1,
	kImageCropperTypeProfileImage = 2,
    kImageCropperTypePostImage = 3
} ImageCropperType;

@protocol PhotoMoveAndScaleControllerDelegate

- (void)onEditCompletedWithOriginalImage:(UIImage *)_originalImage thumbnailImage:(UIImage *)_thumbnailImage imageCropperType:(ImageCropperType)imageCropperType;
- (void)onEditCancelledCropperType:(ImageCropperType)imageCropperType;

@end


#define BG_IMAGE_CROPPER_RECT		CGRectMake(0,-([UI appFrameHeight]+20-110)/2, 320, 110)//40,-82, 400, 130 //10,-82, 441, 130
#define BG_IMAGE_THUMBNAIL_SIZE		CGSizeMake(160, 55)

#define PROFILE_IMAGE_CROPPER_RECT_POTRAIT	CGRectMake(0, -([UI appFrameHeight]+20-300)/2, 300, 300)//40,-82, 400, 130 //10,-82, 441, 130
#define PROFILE_IMAGE_THUMBNAIL_SIZE		CGSizeMake(61, 61)

#define POST_IMAGE_CROPPER_RECT_POTRAIT	CGRectMake(0, -([UI appFrameHeight]+20-320)/2, 320, 320)//40,-82, 400, 130 //10,-82, 441, 130
#define POST_IMAGE_THUMBNAIL_SIZE		CGSizeMake(160, 160)

#define UIColorFromRGB(rgbValue)				[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]



@class HomeViewController;
@interface PhotoMoveAndScaleController : UIViewController <UIScrollViewDelegate> {

	__weak id								<PhotoMoveAndScaleControllerDelegate> delegate;
	//UIImageView					*imageView;
	PhotoCropperScrollView	*scrollView;
	//UIView						*imageCropper;
	NSString						*imagePath;
	//NSString						*thumbnail_image_path;
	UIView							*baseView;
	UIView							*scrollViewBase;
	UIImage							*originalImage;
	UIImage							*thumbnailImage;
    UIImageView                     *cropper_overlay;
    BOOL                            isCardImage;
	float							zoomScaleToFit;
    
    CGRect baseFrame;
}


@property(nonatomic, weak) id <PhotoMoveAndScaleControllerDelegate> delegate;
@property(nonatomic, strong) NSString *imagePath;
//@property(nonatomic, retain) NSString *thumbnail_image_path;
@property(nonatomic, strong) UIImage *originalImage;
@property(nonatomic, strong) UIImage *thumbnailImage;
@property(nonatomic, assign) ImageCropperType imageCropperType;

- (id)initWithImage:(UIImage *)image imageCropperType:(ImageCropperType)imageCropperType;// imagePath:(NSString *)path;


@end
