//
//  TLSettingsViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLSettingsViewController.h"
#import "TLTutorialViewController.h"
#import "TuplitConstants.h"


@interface TLSettingsViewController ()
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *buttonLogout, *buttonTutorial;
    TLTutorialViewController *tutorVC;
}
@end

@implementation TLSettingsViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setTitle:LString(@"SETTINGS")];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] initWithImage:getImage(@"List", NO) style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    [self.navigationItem setLeftBarButtonItem:navleftButton];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [buttonLogout setUpButtonForTuplit];
    [buttonTutorial setUpButtonForTuplit];
    
    tutorVC = [[TLTutorialViewController alloc] initWithNibName:@"TLTutorialViewController" bundle:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action methods

- (IBAction)logOutAction {
    
    [TuplitConstants userLogout];
}

- (IBAction)presentTutorial {
    
    [self presentViewController:tutorVC animated:YES completion:nil];
}


@end
