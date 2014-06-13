//
//  TLMerchantsDetailViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLMerchantsDetailViewController.h"

@interface TLMerchantsDetailViewController ()

@end

@implementation TLMerchantsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:LString(@"MERCHANT_DETAILS")];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    [back backButtonWithTarget:self action:@selector(backButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:back];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)backButtonAction:(id)sender {
    
    DISMISS_KEYBOARD;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
