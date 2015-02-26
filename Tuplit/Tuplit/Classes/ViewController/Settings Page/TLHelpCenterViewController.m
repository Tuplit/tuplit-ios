//
//  TLHelpCenterViewController.m
//  Tuplit
//
//  Created by ev_mac11 on 11/09/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLHelpCenterViewController.h"
#import "TLTutorialViewController.h"
#import "TLWebViewController.h"

@interface TLHelpCenterViewController ()
{
      CGFloat baseViewWidth,baseViewHeight;
}
@end

@implementation TLHelpCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle Methods.

-(void)loadView
{
    [super loadView];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setTitle:LString(@"HELP_CENTER")];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
    [navleftButton backButtonWithTarget:self action:@selector(backToSettings)];
    [self.navigationItem setLeftBarButtonItem:navleftButton];
    
    baseViewWidth= self.view.frame.size.width;
    baseViewHeight= self.view.frame.size.height;
    
    UIView *supportView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, baseViewWidth, 250)];
    supportView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:supportView];
    
    UILabel *aboutLbl=[[UILabel alloc] initWithFrame:CGRectMake(15,15, 100, 20)];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    aboutLbl.text= [NSString stringWithFormat:@"About (v%@)",version];
    aboutLbl.textColor=UIColorFromRGB(0x999999);
    aboutLbl.textAlignment=NSTextAlignmentLeft;
    aboutLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    aboutLbl.backgroundColor=[UIColor clearColor];
    [supportView addSubview:aboutLbl];
    
    UILabel *customerSupportLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(aboutLbl.frame) + 10, 150, 20)];
    customerSupportLbl.text=LString(@"CUSTOMER_SUPPORT");
    customerSupportLbl.textColor=UIColorFromRGB(0x999999);
    customerSupportLbl.textAlignment=NSTextAlignmentLeft;
    customerSupportLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    customerSupportLbl.backgroundColor=[UIColor clearColor];
    [supportView addSubview:customerSupportLbl];
    
    UILabel *emailLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(customerSupportLbl.frame)+5, 50, 20)];
    emailLbl.text=LString(@"EMAIL");
    emailLbl.textColor=UIColorFromRGB(0x000000);
    emailLbl.textAlignment=NSTextAlignmentLeft;
    emailLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    emailLbl.backgroundColor=[UIColor clearColor];
    [supportView addSubview:emailLbl];
    
    UILabel *emailIDLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(emailLbl.frame)+ 4, CGRectGetMaxY(customerSupportLbl.frame)+5, 200, 20)];
    emailIDLbl.text=[TLUserDefaults contactEmail];
    emailIDLbl.textColor=UIColorFromRGB(0x00b3a4);
    emailIDLbl.textAlignment=NSTextAlignmentLeft;
    emailIDLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    emailIDLbl.backgroundColor=[UIColor clearColor];
    emailIDLbl.userInteractionEnabled = YES;
    UITapGestureRecognizer *emailtapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(supportMailAction)];
    [emailIDLbl addGestureRecognizer:emailtapGesture];
    [supportView addSubview:emailIDLbl];
    
    UILabel *phoneLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(emailLbl.frame)+5, 60, 20)];
    phoneLbl.text=LString(@"PHONE");
    phoneLbl.textColor=UIColorFromRGB(0x000000);
    phoneLbl.textAlignment=NSTextAlignmentLeft;
    phoneLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    phoneLbl.backgroundColor=[UIColor clearColor];
    [supportView addSubview:phoneLbl];
    
    UILabel *phoneNumberLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLbl.frame), CGRectGetMaxY(emailLbl.frame)+5, 200, 20)];
    phoneNumberLbl.text=[TLUserDefaults contactphone];
    phoneNumberLbl.textColor=UIColorFromRGB(0x00b3a4);
    phoneNumberLbl.textAlignment=NSTextAlignmentLeft;
    phoneNumberLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    phoneNumberLbl.backgroundColor=[UIColor clearColor];
    phoneNumberLbl.userInteractionEnabled = YES;
    UITapGestureRecognizer *phonetapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneNumCallAction)];
    [phoneNumberLbl addGestureRecognizer:phonetapGesture];
    [supportView addSubview:phoneNumberLbl];
    
    UIButton *questionBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [questionBtn setFrame:CGRectMake(15, CGRectGetMaxY(phoneLbl.frame)+15, 290, 45)];
    [questionBtn setTitle:LString(@"FAQ") forState:UIControlStateNormal];
    [questionBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    questionBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    questionBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [questionBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [questionBtn addTarget:self action:@selector(frequentQuestionAction) forControlEvents:UIControlEventTouchUpInside];
    [supportView addSubview:questionBtn];
    
    UIButton *tutorialBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [tutorialBtn setFrame:CGRectMake(15, CGRectGetMaxY(questionBtn.frame) +10, 290, 45)];
    [tutorialBtn setTitle:LString(@"TUTORIALS") forState:UIControlStateNormal];
    [tutorialBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    tutorialBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    tutorialBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [tutorialBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [tutorialBtn addTarget:self action:@selector(tutorialAction) forControlEvents:UIControlEventTouchUpInside];
    [supportView addSubview:tutorialBtn];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToSettings
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - User Defined Methods

-(void)supportMailAction
{
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.navigationBar.barStyle = UIBarStyleDefault;
        [[controller navigationBar] setTintColor:UIColorFromRGB(0XFFFFFF)];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[NSArray arrayWithObject:[TLUserDefaults contactEmail]]];
        [controller setSubject:@"Tuplit"];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            
            [controller.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        }
        else
        {
            [controller.navigationBar setTintColor:[UIColor blackColor]];
        }
        
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        [UIAlertView alertViewWithMessage:LString(@"EMAIL_ACCOUNT_SETUP")];
    }
}
-(void)phoneNumCallAction
{
    NSString *phoneString =  [TuplitConstants formatPhoneNumber:[TLUserDefaults contactphone]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LString(@"TUPLIT") message:phoneString delegate:self cancelButtonTitle:LString(@"CANCEL") otherButtonTitles:LString(@"Call"), nil];
    alertView.tag = 9010;
    [alertView show];
}

-(void) frequentQuestionAction
{
    //    [UIAlertView alertViewWithMessage:@"FAQ is under construction. Will be available in future demos."];
    TLWebViewController *webVC = [[TLWebViewController alloc] initWithNibName:@"TLWebViewController" bundle:nil];
    webVC.titleString = LString(@"FAQ");
    webVC.viewController =self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
    [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void) tutorialAction
{
    TLTutorialViewController *tutorialViewController=[[TLTutorialViewController alloc] initWithNibName:@"TLTutorialViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tutorialViewController];
    [nav.navigationController setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self.navigationController  dismissViewControllerAnimated:YES completion:NULL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
