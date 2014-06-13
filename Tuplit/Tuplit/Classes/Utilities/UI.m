//
//  UIDevice+Devices.m
//  21Questions
//
//
//

#import "UI.h"

@implementation UI

+ (BOOL)isIPhone5 {
return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height * [UIScreen mainScreen].scale >= 1136);
}

+ (CGSize)appFrameSize {
	return [[UIScreen mainScreen] applicationFrame].size;
}

+ (float)appFrameHeight {
	return [UI appFrameSize].height;
}

+ (float)appFrameWidth {
	return [UI appFrameSize].width;
}

@end
