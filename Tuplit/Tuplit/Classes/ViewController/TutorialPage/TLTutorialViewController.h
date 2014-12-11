//
//  TLTutorialViewController.h
//  Tuplit
//
//  Created by ev_mac6 on 12/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLTutorialViewController : UIViewController
@property (nonatomic, weak)id delegate;
-(void)loaddata;
@property BOOL isWelcome;
@end
