//
//  TLForgotPasswordViewController.m
//  Tuplit
//
//  Created by ev_mac1 on 12/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLForgotPasswordViewController.h"
#import "TLForgotPasswordManager.h"

@interface TLForgotPasswordViewController ()<TLForgotPasswordManagerDelegate>
{
    IBOutlet UITextField *textEmail;
    IBOutlet UIButton *buttonSubmit;
    TLForgotPasswordManager *forgotPWManager;
}

@end

@implementation TLForgotPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    forgotPWManager.delegate = nil;
    forgotPWManager = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:LString(@"FORGOT_PASSWORD")];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    [back backButtonWithTarget:self action:@selector(backButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:back];
    
    [buttonSubmit setUpButtonForTuplit];
    [textEmail setupForTuplitStyle];
    
    forgotPWManager = [TLForgotPasswordManager new];
    forgotPWManager.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self performSelector:@selector(showKeyboardWithDelay) withObject:nil afterDelay:0.35];
}


#pragma TextField methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self forgotPasswordAction];
    return YES;
}


#pragma mark - Action methods

- (IBAction)forgotPasswordAction {
    
    NETWORK_TEST_PROCEDURE;
    if(textEmail.text.length == 0) {
        [UIAlertView alertViewWithMessage:LString(@"ENTER_EMAIL")];
        
    } else if(![textEmail.text isEmail]) {
        [UIAlertView alertViewWithMessage:LString(@"ENTER_VALID_EMAIL")];
        
    } else {
        DISMISS_KEYBOARD;
        [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
        [forgotPWManager forgotPasswordForEmail:textEmail.text];
    }
}

- (void)showKeyboardWithDelay {
    
    [textEmail becomeFirstResponder];
}

- (void)backButtonAction:(id)sender {
    
    DISMISS_KEYBOARD;
    [self performSelector:@selector(popViewAfterDelay) withObject:nil afterDelay:0.4];
}

- (void)popViewAfterDelay {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Touches method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    DISMISS_KEYBOARD;
}


#pragma mark - TLForgotPasswordManager delegate methods

- (void)forgotPasswordManagerSuccess:(TLForgotPasswordManager *)forgotPasswordManager {
    
    [[ProgressHud shared] hide];
}

- (void)forgotPasswordManager:(TLForgotPasswordManager *)forgotPasswordManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg {
    
    [[ProgressHud shared] hide];
     [UIAlertView alertViewWithMessage:errorMsg];
}

- (void)forgotPasswordManagerFailed:(TLForgotPasswordManager *)forgotPasswordManager {
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

@end



