//
//  TLCartViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLCartViewController.h"

@interface TLCartViewController ()

@end

@implementation TLCartViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:LString(@"CART")];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] initWithImage:getImage(@"List", NO) style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    [self.navigationItem setLeftBarButtonItem:navleftButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
