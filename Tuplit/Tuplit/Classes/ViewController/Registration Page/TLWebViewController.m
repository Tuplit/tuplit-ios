//
//  TLWebViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 30/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLWebViewController.h"
#import "TLSettingsViewController.h"

@interface TLWebViewController ()
@end

@implementation TLWebViewController

@synthesize webView,viewController;


#pragma mark - View life cycle methods.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:self.titleString];
    if([viewController isKindOfClass:[TLSettingsViewController class]])
    {
        if([self.titleString isEqualToString:LString(@"TERMS_OF_SERVICE")])
            [self.navigationItem setTitle:@"Terms of Use"];
    }
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    
    if([self.titleString isEqualToString:LString(@"TERMS_OF_SERVICE")] || [self.titleString isEqualToString:LString(@"LEGAL")]) {
        
        [self.webView loadHTMLString:[Global instance].termsContent baseURL:nil];
    } else if([self.titleString isEqualToString:LString(@"PRIVACY_POLICY")]) {
        
        [self.webView loadHTMLString:[Global instance].privacyContent baseURL:nil];
    } else if([self.titleString isEqualToString:LString(@"FAQ")]) {
        //        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[Global instance].faqUrl]]];
        [self.webView loadHTMLString:[Global instance].faqUrl baseURL:nil];
    }
    //    [self.webView loadHTMLString:[Global instance].termsContent baseURL:nil];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    [back backButtonWithTarget:self action:@selector(backButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:back];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action methods

- (void)backButtonAction:(id)sender {
    
    DISMISS_KEYBOARD;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

