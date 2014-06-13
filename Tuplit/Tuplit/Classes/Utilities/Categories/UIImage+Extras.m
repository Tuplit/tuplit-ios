
#import "UIImage+Extras.h"
#import "NSString+Extras.h"

@implementation UIImage(Extras)


static NSMutableDictionary *imageCache=nil;


- (UIImage *)resizedImageWithSize:(CGSize)size {
    
    if (self.size.width < size.width && self.size.height < size.height) return self;
    CGSize newSize = size;
    
    /*
    if (self.size.width > self.size.height) {
        
        newSize.height = (size.width/self.size.width) * self.size.height;
    
    } else if (self.size.width < self.size.height) {
        
         newSize.width = (size.height/self.size.height) * self.size.width;
    }*/
    
    float actualHeight = self.size.height;
    float actualWidth = self.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = size.width/size.height;
    
    if (imgRatio < maxRatio) {
        
        imgRatio = size.height / actualHeight;
        newSize.width = imgRatio * actualWidth;
        newSize.height = size.height;
    
    } else {
        
        imgRatio = size.width / actualWidth;
        newSize.height = imgRatio * actualHeight;
        newSize.width = size.width;
    }
    
    NSData *imageData = UIImagePNGRepresentation(self);
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    //if (NULL != UIGraphicsBeginImageContextWithOptions) UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //else
        UIGraphicsBeginImageContext(size);
    
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    */
    
    float _x = (size.width - newSize.width) / 2;
    float _y = (size.height - newSize.height) / 2;
    
    [compressedImage drawInRect:CGRectMake(_x, _y, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    return newImage;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


UIImage* getImage(NSString *imageName, BOOL cached) {
	
    UIImage *image = [imageCache objectForKey:imageName];
    
    if (!image) {
    
        if ([[imageName pathExtension] isEqualTo:@""]) imageName = [imageName stringByAppendingPathExtension:@"png"];
        NSString *imageFile = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], imageName];
        image = [UIImage imageWithContentsOfFile:imageFile];
        if (!image) return nil;
        if (cached) {
            
            if (!imageCache) imageCache = [NSMutableDictionary new];
            [imageCache setObject:image forKey:imageName];
        }
    }
    
    return image;
}

+ (UIImage *)cachedImageForKey:(NSString *)key {
	
	return [imageCache objectForKey:key];
}


+ (void)cacheImage:(UIImage *)image forKey:(NSString *)key {
	
	[imageCache setObject:image forKey:key];
}


+ (void)releaseImageCache {
    
    if (imageCache) {[imageCache removeAllObjects];  imageCache = nil;}
}


@end