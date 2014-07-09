//
//  TLSocialNWSignUpViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 22/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLSocialNWSignUpViewController.h"
#import "PhotoMoveAndScaleController.h"
#import "TLLeftMenuViewController.h"
#import "TLMerchantsViewController.h"
#import "TLSignUpManager.h"
#import "TLTutorialViewController.h"
#import "TLLoginManager.h"
#import "TLUserDetailsManager.h"

@interface TLSocialNWSignUpViewController ()<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoMoveAndScaleControllerDelegate, TLSignUpManagerDelegate, TLLoginManagerDelegate,TLUserDetailsManagerDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *textFirstName, *textLastName, *textCellNumber, *textPinCode;
    IBOutlet UIButton *buttonSave, *buttonHighLight;
    IBOutlet UIImageView *userImageView;
    IBOutlet UIToolbar *inputAccessoryView;
    CGFloat scrollContentHeight;
    UITextField *currentTextField;
    UIActionSheet *actionSheet;
    UIImagePickerController *imagePicker;
    BOOL isPictureUpdated, isPush;
    TLSignUpManager *signUpManager;
    TLLoginManager *loginManager;
    TLUserDetailsManager *userDetailsManager;
}
@end

@implementation TLSocialNWSignUpViewController


#pragma mark - View life cycle methods.

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
    signUpManager.delegate = nil;
    signUpManager = nil;
    
    userDetailsManager.delegate = nil;
    userDetailsManager = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:LString(@"YOUR_DETAILS")];
    
    // Back Button
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    [back backButtonWithTarget:self action:@selector(backButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:back];
    
    // Text field
    [textFirstName setupForTuplitStyle];
    [textLastName setupForTuplitStyle];
    [textPinCode setupForTuplitStyle];
// [textCellNumber setupForTuplitStyle];
    [textPinCode setRightViewIcon:getImage(@"Question", NO) target:self action:@selector(pinCodeAction)];
    textFirstName.delegate = textLastName.delegate = textPinCode.delegate = self;
    textFirstName.inputAccessoryView = textLastName.inputAccessoryView = textPinCode.inputAccessoryView = inputAccessoryView;
    
    inputAccessoryView.layer.borderWidth = 0.5;
    inputAccessoryView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Button
    [buttonSave setUpButtonForTuplit];
    buttonHighLight.layer.cornerRadius = buttonHighLight.height/2;
    [buttonHighLight setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [buttonHighLight setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:224/255 green:224/255 blue:224/255 alpha:0.5]] forState:UIControlStateHighlighted];
    buttonHighLight.backgroundColor = [UIColor clearColor];
    buttonHighLight.clipsToBounds = YES;
    
    userImageView.layer.cornerRadius = userImageView.height/2;
    userImageView.contentMode = UIViewContentModeScaleAspectFill;
    userImageView.clipsToBounds=YES;
    
    scrollContentHeight = [UIScreen mainScreen].bounds.size.height-([UI isIPhone5]?-35:-105);
    [scrollView setContentSize:CGSizeMake(320, scrollContentHeight)];
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing = NO;
    
    isPictureUpdated = NO;
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LString(@"CANCEL") destructiveButtonTitle:nil otherButtonTitles:
                   LString(@"TAKE_PHOTO"),
                   LString(@"EXISTING_PHOTO"),
                   nil];
    
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:APP_DELEGATE.defaultColor forState:UIControlStateNormal];
        }
    }
    
    isPush = YES;
    
    if(self.user) {
        userImageView.image = self.user.userImage;
        if(self.user.userImage)
            isPictureUpdated = YES;
        textFirstName.text = [self.user.FirstName capitaliseFirstLetter];
        textLastName.text = [self.user.LastName capitaliseFirstLetter];
    }
    
    userDetailsManager = [TLUserDetailsManager new];
    userDetailsManager.delegate = self;
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated {
    
    if(isPush)
        [self performSelector:@selector(showKeyboardWithDelay) withObject:nil afterDelay:0.35];
}


#pragma mark - TextField delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    currentTextField = textField;
    
    if(textField == textPinCode) {
        if(![UI isIPhone5]) {
            if(textField == textPinCode)
                [scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(textPinCode.frame)-10) animated:YES];
           // else
             //   [scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(textCellNumber.frame)-10) animated:YES];
        }
        else
            [scrollView setContentOffset:CGPointMake(0, 10) animated:YES];
        
        if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.automaticallyAdjustsScrollViewInsets = YES;
        }
    } else {
        if(![UI isIPhone5])
        [scrollView setContentOffset:CGPointZero animated:YES];
    }
    
    [scrollView setContentSize:CGSizeMake(320, scrollContentHeight)];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 40) ? NO : YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self dismiss:nil];
    return YES;
}


#pragma mark - Action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self dismiss:nil];
    
    if(buttonIndex == 0)
        [self takePictureAction];
    else if(buttonIndex == 1)
        [self takePhotoLibraryAction];
}


#pragma mark - Action Methods

- (void)callLoginWebService {
    
    if(!loginManager) {
        loginManager = [TLLoginManager new];
        loginManager.delegate = self;
    }
    
    loginManager.user = self.user;
    [loginManager loginUserUsingSocialNW:YES];
}

- (IBAction)saveAction:(id)sender {
    
    if(textFirstName.text.length == 0)
        [self showAlertWithMessage:LString(@"ENTER_FITST_NAME")];
    else if(textLastName.text.length == 0)
        [self showAlertWithMessage:LString(@"ENTER_LAST_NAME")];
//    else if(textCellNumber.text.length == 0)
//        [self showAlertWithMessage:LString(@"ENTER_CELL_NUMBER")];
    else if(textPinCode.text.length == 0)
        [self showAlertWithMessage:LString(@"ENTER_PIN")];
    else {
        [self dismiss:nil];
        // Todo implement webservice here
        self.user.FirstName = textFirstName.text;
        self.user.LastName  = textLastName.text;
        self.user.UserName  = @"";
        self.user.PinCode   = textPinCode.text;
        if(isPictureUpdated)
            self.user.userImage = userImageView.image;
        self.user.ZipCode   = @"";
        self.user.Country = @"";
        // self.user.CellNumber = NSNonNilString(textCellNumber.text);
        
        if(!signUpManager) {
            signUpManager = [TLSignUpManager new];
            signUpManager.delegate = self;
        }
        
        signUpManager.user = self.user;
        [signUpManager registerUser:@"POST"];
        [[ProgressHud shared] showWithMessage:LString(@"REGISTERING") inTarget:self.navigationController.view];
    }
}

- (void)showAlertWithMessage :(NSString*)message {
    
    [UIAlertView alertViewWithMessage:message];
}

- (void)backButtonAction:(id)sender {
    
    [self dismiss:nil];
    [self performSelector:@selector(popViewWithDelay) withObject:nil afterDelay:0.4];
}

- (void)popViewWithDelay {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showKeyboardWithDelay {
    
    [textPinCode becomeFirstResponder];
}

- (IBAction)takePhoto:(id)sender {
    
    [actionSheet showFromRect:buttonHighLight.frame inView:self.view animated:YES];
    [actionSheet showInView:self.view];
}

- (void)pinCodeAction {
    
    [[[UIAlertView alloc] initWithTitle:LString(@"SAVE_YOUR_TIME_WITH_PIN") message:LString(@"PIN_ALLOWS") delegate:nil cancelButtonTitle:LString(@"OK_GOT_IT") otherButtonTitles:nil] show];
}

- (IBAction)previous:(id)sender {
    
    for(UITextField *textField in scrollView.subviews)
    {
        if(textField.tag == currentTextField.tag-1 && textField.tag != 0)
        {
            [textField becomeFirstResponder];
            break;
        }
    }
}

- (IBAction)next:(id)sender {
    
    for(UITextField *textField in scrollView.subviews)
    {
        if(textField.tag > currentTextField.tag)
        {
            [textField becomeFirstResponder];
            break;
        }
    }
}

- (IBAction)dismiss:(id)sender {
    
    DISMISS_KEYBOARD;
    [scrollView setContentSize:CGSizeMake(320, 400)];
    [scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)takePictureAction
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        isPush = NO;
        [self presentViewController:imagePicker animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
        
    } else {
        
        [UIAlertView alertViewWithMessage:LString(@"NO_VALID_CAMERA")];
    }
}

- (void)takePhotoLibraryAction
{
    isPush = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (IBAction)presentAMSlider {

   [TuplitConstants loadSliderHomePageWithAnimation:YES];
}


# pragma mark - UIImagePickerViewController Delegate

- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    PhotoMoveAndScaleController *photoMove=[[PhotoMoveAndScaleController alloc]initWithImage:image imageCropperType:kImageCropperTypeProfileImage];
	[photoMove setDelegate:self];
    [Picker pushViewController:photoMove animated:YES];
}

- (void)onEditCancelledCropperType:(ImageCropperType)imageCropperType {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)onEditCompletedWithOriginalImage:(UIImage *)_originalImage thumbnailImage:(UIImage *)_thumbnailImage imageCropperType:(ImageCropperType)imageCropperType
{
    isPictureUpdated = YES;
    userImageView.image=_thumbnailImage;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];
}


#pragma mark - TLSignUpManager delegate methods

- (void)signUpManager:(TLSignUpManager *)signUpManager registerSuccessfullWithUser:(UserModel *)user isAlreadyRegistered:(BOOL)isAlreadyRegistered {
    
    [self callLoginWebService];
}

- (void)signUpManager:(TLSignUpManager *)signUpManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *) errorMsg {
    
    [UIAlertView alertViewWithMessage:errorMsg];
    [[ProgressHud shared] hide];
}

- (void)signUpManagerFailed:(TLSignUpManager *)signUpManager {
    
    [[ProgressHud shared] hide];
}

#pragma mark - TLLoginManager delegate method

- (void)loginManager:(TLLoginManager *)loginManager loginSuccessfullWithUser:(UserModel *)user {
    
    [TLUserDefaults setIsTutorialSkipped:NO];
    [Global instance].user = user;
    [TLUserDefaults setAccessToken:user.AccessToken];
    [userDetailsManager getUserDetailsWithUserID:user.UserId];
    [[ProgressHud shared] hide];
}

- (void)loginManager:(TLLoginManager *)loginManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    [[ProgressHud shared] hide];
}

- (void)loginManagerLoginFailed:(TLLoginManager *)loginManager {
    
    [[ProgressHud shared] hide];
}

#pragma mark - TLUserDetailsManagerDelegate methods

- (void)userDetailManagerSuccess:(TLUserDetailsManager *)userDetailsManager withUser:(UserModel*)user_ withUserDetail:(UserDetailModel*)userDetail_ {
        
    [TLUserDefaults setCurrentUser:user_];
    [[ProgressHud shared] hide];
    [self presentAMSlider];
}

- (void)userDetailsManager:(TLUserDetailsManager *)userDetailsManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    [[ProgressHud shared] hide];
}

- (void)userDetailsManagerFailed:(TLUserDetailsManager *)userDetailsManager {
    
    [[ProgressHud shared] hide];
}

@end
