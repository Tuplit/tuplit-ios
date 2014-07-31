//
//  TLLoginViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 21/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLLoginViewController.h"
#import "TLLeftMenuViewController.h"
#import "TLMerchantsViewController.h"
#import "TLLoginManager.h"
#import "UserModel.h"
#import "TLForgotPasswordViewController.h"
#import "TLTutorialViewController.h"
#import "TLUserDetailsManager.h"

@interface TLLoginViewController ()<UITextFieldDelegate, TLLoginManagerDelegate, TLUserDetailsManagerDelegate>
{
    IBOutlet UITextField *emailTextField, *passwordTextField;
    IBOutlet UIButton *buttonLogin, *buttonForgotPW;
    TLLoginManager *loginManager;
    TLUserDetailsManager *userDetailsManager;
    
}
@end

@implementation TLLoginViewController


#pragma mark - View life cycle methods

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
    loginManager.delegate = nil;
    loginManager = nil;
    
    userDetailsManager.delegate = nil;
    userDetailsManager = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:LString(@"LOGIN")];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    
    // Back Button
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    [back backButtonWithTarget:self action:@selector(backButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:back];
    
    // TextField
    [emailTextField setupForTuplitStyle];
    [passwordTextField setupForTuplitStyle];
    emailTextField.delegate = passwordTextField.delegate = self;
    
    // Button
    [buttonLogin setUpButtonForTuplit];
    [buttonForgotPW setTitleColor:APP_DELEGATE.defaultColor forState:UIControlStateNormal];
    
    userDetailsManager = [[TLUserDetailsManager alloc] init];
    userDetailsManager.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self performSelector:@selector(showKeyboardWithDelay) withObject:nil afterDelay:0.35];
}


#pragma mark - Action Methods

- (void)showKeyboardWithDelay {
    
    [emailTextField becomeFirstResponder];
}

- (void)backButtonAction:(id)sender {
    
    DISMISS_KEYBOARD;
    [self performSelector:@selector(popViewAfterDelay) withObject:nil afterDelay:0.4];
}

- (void)popViewAfterDelay {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)forgotPasswordAction:(id)sender {
    
    // v1/users/forgetPassword
    DISMISS_KEYBOARD;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showKeyboardWithDelay) object:nil];
    
    TLForgotPasswordViewController *forgotPW = [[TLForgotPasswordViewController alloc] initWithNibName:@"TLForgotPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgotPW animated:YES];
}

- (IBAction)logInAction:(id)sender {
    
    NETWORK_TEST_PROCEDURE;
    if(emailTextField.text.length == 0) {
        [UIAlertView alertViewWithMessage:LString(@"ENTER_EMAIL")];
        [emailTextField becomeFirstResponder];
    } else if(![emailTextField.text isEmail]) {
        [UIAlertView alertViewWithMessage:LString(@"ENTER_VALID_EMAIL")];
        [passwordTextField becomeFirstResponder];
    } else if(passwordTextField.text.length == 0) {
        [UIAlertView alertViewWithMessage:LString(@"ENTER_PASSWORD")];
        [passwordTextField becomeFirstResponder];
    }
    else
    {
        DISMISS_KEYBOARD;
        if(!loginManager) {
            
            loginManager = [TLLoginManager new];
            loginManager.delegate = self;
        }
        
        UserModel *user_ = [UserModel new];
        user_.Email = emailTextField.text;
        user_.Password = passwordTextField.text;
        
        loginManager.user = user_;
        [loginManager loginUserUsingSocialNW:NO];
        [[ProgressHud shared] showWithMessage:LString(@"SIGNING_IN") inTarget:self.navigationController.view];
    }
}

#pragma mark - Tutorial Skip method

- (void)presentAMSlider {
    
    [TuplitConstants loadSliderHomePageWithAnimation:YES];
}


#pragma TextField methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField == emailTextField) [passwordTextField becomeFirstResponder];
    else                            [self logInAction:nil];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    DISMISS_KEYBOARD;
}


#pragma mark - LoginManager delegate methods

- (void)loginManager:(TLLoginManager *)loginManager loginSuccessfullWithUser:(UserModel *)user {
    
  
    [Global instance].user = user;
    [TLUserDefaults setAccessToken:user.AccessToken];
    [userDetailsManager getUserDetailsWithUserID:user.UserId];
}

- (void)loginManager:(TLLoginManager *)loginManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg {
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}

- (void)loginManagerLoginFailed:(TLLoginManager *)loginManager {
    
    [[ProgressHud shared] hide];
}


#pragma mark - TLUserDetailsManagerDelegate methods

- (void)userDetailManagerSuccess:(TLUserDetailsManager *)userDetailsManager withUser:(UserModel*)user_ withUserDetail:(UserDetailModel*)userDetail_ {
    
    [TLUserDefaults setCurrentUser:user_];
    [self presentAMSlider];
    [[ProgressHud shared] hide];
}

- (void)userDetailsManager:(TLUserDetailsManager *)userDetailsManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    [[ProgressHud shared] hide];
}

- (void)userDetailsManagerFailed:(TLUserDetailsManager *)userDetailsManager {
    
    [[ProgressHud shared] hide];
}

@end

