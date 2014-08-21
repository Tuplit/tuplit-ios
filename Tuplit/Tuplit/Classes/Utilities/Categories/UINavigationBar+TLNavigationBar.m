//
//  UINavigationBar+TLNavigationBar.m
//  Tuplit
//
//

#import "UINavigationBar+TLNavigationBar.h"

@implementation UINavigationBar (TLNavigationBar)


+ (void)initialize {
    
    [super initialize];
    
    /* iOS5-only to customize the nav bar appearance */
    
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        UIImage *img;
        if(SYSTEM_VERSION_LESS_THAN(@"7.0"))
            img = getImage(@"nav", NO);
        else
            img = getImage(@"nav_64", NO);
//        [[UINavigationBar appearance] setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
//        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
        
        if(SYSTEM_VERSION_EQUAL_TO(@"6.0"))
            [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault]; // MFMailComposeViewController's navigationBar backgroundcolor
        else
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
        
        [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    }
}


/* drawRect: customization works in pre iOS5 versions */

- (void)drawRect:(CGRect)rect {
        
    UIImage *img = getImage(@"nav", NO);
	//if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_5_0) {
		rect.size.height = img.size.height;
	//}
    [self setTintColor:[UIColor whiteColor]];
    [img drawInRect:rect];
}

@end
