

@interface PhotoCropperScrollView : UIScrollView {

	UIImageView *imageContainer;
}

@property (nonatomic, strong) UIImageView *imageContainer;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@property (nonatomic, assign) CGSize contentOffsetInset;
		   
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image ;
- (void)centerContentView;

@end