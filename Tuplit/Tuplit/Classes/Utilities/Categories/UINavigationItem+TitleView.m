//
//  UINavigationController+TitleView.m
//  21Questions
//
//  Created by Purushothaman on 04/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UINavigationItem+TitleView.h"

@implementation UINavigationItem (TitleView)

- (void)setTitleLogo {
    
    UIImage *titleLogo = getImage(@"top_logo", NO);
    UIImageView *titleView = [[UIImageView alloc] initWithImage:titleLogo];
    titleView.frame = CGRectMake(0, 0, titleLogo.size.width, titleLogo.size.height);
    self.titleView = titleView;
}

- (void)setTitle:(NSString *)title {
    
    UILabel *label = nil;
    
    if([self.titleView isKindOfClass:[UILabel class]])
        label = (UILabel *)self.titleView;
    
    if(label == nil) {
    
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
    }
    
    label.text = title;
    [label sizeToFit];
    label.adjustsFontSizeToFitWidth=NO;
    self.titleView=label;
}

@end
