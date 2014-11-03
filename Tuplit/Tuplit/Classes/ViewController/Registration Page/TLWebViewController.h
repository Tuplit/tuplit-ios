//
//  TLWebViewController.h
//  Tuplit
//
//  Created by ev_mac6 on 30/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLWebViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSURL *resourceUrl;
@property (nonatomic, retain) NSString *titleString;
@property (nonatomic,strong)UIViewController *viewController;
@end
