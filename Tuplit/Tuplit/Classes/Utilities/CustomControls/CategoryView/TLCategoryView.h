//
//  TLCatagoryView.h
//  Tuplit
//
//  Created by ev_mac11 on 19/08/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLCategoryView : UIView
@property double ctgviewHeight;

- (void)setUpCategoryView:(NSArray *)categories andWidth:(float)width;
-(void) removeCtgViews;

@end
