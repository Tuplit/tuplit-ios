
#import <UIKit/UIKit.h>

@interface UIImage(Extras)

- (UIImage *)resizedImageWithSize:(CGSize)size;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
+ (void)releaseImageCache;
+ (UIImage *)cachedImageForKey:(NSString *)key;
+ (void)cacheImage:(UIImage *)image forKey:(NSString *)key;
UIImage* getImage(NSString *imageName, BOOL cached);

@end
