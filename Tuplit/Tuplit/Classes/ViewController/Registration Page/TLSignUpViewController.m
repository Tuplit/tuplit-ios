//
//  TLSignUpViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 21/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLSignUpViewController.h"
#import "PhotoMoveAndScaleController.h"
#import "TLLeftMenuViewController.h"
#import "TLMerchantsViewController.h"
#import "TLSignUpManager.h"
#import "TLSocialNWSignUpViewController.h"
#import "TLLoginManager.h"
#import "TLWebViewController.h"
#import "TLTutorialViewController.h"
#import "TLUserDetailsManager.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "TLActionSheet.h"
@interface TLSignUpViewController ()<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoMoveAndScaleControllerDelegate, TLSignUpManagerDelegate, GPPSignInDelegate, TLLoginManagerDelegate, TLUserDetailsManagerDelegate,TLActionSheetDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *buttonFaceBook, *buttonGoogle, *buttonSignUp, *buttonTerms, *buttonPrivacy, *buttonHighLight;
    IBOutlet UITextField *textEmail, *textPassword, *textFirstName, *textLastName, *textPinCode, *textCellNumber;
    IBOutlet UIImageView *userImageView;
    IBOutlet UIToolbar *inputAccessoryView;
    IBOutlet UISegmentedControl *segment;
    IBOutlet UILabel *dobLabel;
    
    CGFloat scrollContentHeight;
    
    UITextField *currentTextField;
    UIActionSheet *actionSheet;
    UIImagePickerController *imagePicker;
    TLActionSheet *datePickerBase;
    UIDatePicker *datepicker;
    BOOL isPictureUpdated, isPush , isActionSheetOpen;
    
    TLSignUpManager *signUpManager;
    TLLoginManager *loginManager;
    TLUserDetailsManager *userDetailsManager;
    
    NSString *fbID, *googlePlusID;
    CLPlacemark *placeMark;
    BOOL dontClear, isSocialButtonPressed ,isAlredyRegister;
    
    NSDate *previousSelectiondate;
}
@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;

@end

@implementation TLSignUpViewController


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
    
    loginManager.delegate = nil;
    loginManager = nil;
    
    userDetailsManager.delegate = nil;
    userDetailsManager = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:LString(@"SIGNUP")];
    
    textEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    textFirstName.autocorrectionType = UITextAutocorrectionTypeNo;
    textLastName.autocorrectionType = UITextAutocorrectionTypeNo;
    textPinCode.autocorrectionType = UITextAutocorrectionTypeNo;
        
    // Back Button
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    [back backButtonWithTarget:self action:@selector(backButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:back];
    
    // Button
    [buttonFaceBook setUpButtonForTuplit];
    [buttonGoogle setUpButtonForTuplit];
    [buttonSignUp setUpButtonForTuplit];
    buttonHighLight.layer.cornerRadius = buttonHighLight.height/2;
    [buttonHighLight setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [buttonHighLight setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:224/255 green:224/255 blue:224/255 alpha:0.5]] forState:UIControlStateHighlighted];
    buttonHighLight.backgroundColor = [UIColor clearColor];
    buttonHighLight.clipsToBounds = YES;
    userImageView.layer.cornerRadius = userImageView.height/2;
    userImageView.contentMode = UIViewContentModeScaleAspectFit;
    [buttonTerms positionAtY:buttonTerms.yPosition-1];
    [buttonPrivacy positionAtY:buttonTerms.yPosition];
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    dobLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textFieldBg"]];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPicker)];
    [dobLabel setUserInteractionEnabled:YES];
    [dobLabel addGestureRecognizer:tap];
    
    // TextField
    [textEmail setupForTuplitStyle];
    [textPassword setupForTuplitStyle];
    [textFirstName setupForTuplitStyle];
    [textFirstName setupForTuplitStyle];
    [textLastName setupForTuplitStyle];
    // [textCellNumber setupForTuplitStyle];
    [textPinCode setupForTuplitStyle];
    textEmail.delegate = textPassword.delegate = textFirstName.delegate = textLastName.delegate = textPinCode.delegate = self;
    
    textEmail.inputAccessoryView = textPassword.inputAccessoryView = textFirstName.inputAccessoryView = textLastName.inputAccessoryView = textPinCode.inputAccessoryView = inputAccessoryView;
    
    inputAccessoryView.layer.borderWidth = 0.5;
    inputAccessoryView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [textPassword setRightViewIcon:getImage(@"ShowPassword", NO) target:self action:@selector(showPassword)];
    [textPinCode setRightViewIcon:getImage(@"Question", NO) target:self action:@selector(pinCodeAction)];
    
    scrollContentHeight = CGRectGetMaxY(buttonTerms.frame)+32;
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
    
    self.user = [UserModel new];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    
    dontClear = NO;
    
    userDetailsManager = [TLUserDetailsManager new];
    userDetailsManager.delegate = self;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(signUpsuccessAction) name:kCreditCardAdded object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    NSLog(@"%f", [CurrentLocation latitude]);
    NSLog(@"%f", [CurrentLocation longitude]);
    CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:[CurrentLocation latitude] longitude:[CurrentLocation longitude]];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:tempLocation completionHandler:
     ^(NSArray *placemarks, NSError* error) {
         if ([placemarks count] > 0) {
             placeMark = [placemarks objectAtIndex:0];
             self.user.ZipCode = placeMark.postalCode;
             self.user.Country = placeMark.country;
             APP_DELEGATE.postalCode = placeMark.postalCode;
             APP_DELEGATE.location = placeMark.locality;
             
             NSLog(@"%@", placeMark.country);
             NSLog(@"%@", placeMark.postalCode);
             NSLog(@"%@", placeMark.locality);
         } else if(error) {
             NSLog(@"%@", error);
         } else {
             NSLog(@"%@", placemarks);
         }
     }];
    
    if(!dontClear)
        [self clearAllData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFBSignupScreen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookSignUpNotificationCalled:) name:kFBSignupScreen object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User defined methods

-(void)setupdatePicker
{
    datePickerBase = [[TLActionSheet alloc]initWithFrame:CGRectMake(0.0, self.view.frame.size.height, self.view.frame.size.width, 200.0)];
    datePickerBase.delegate = self;
    
    if([dobLabel.text isEqualToString:@"  Date of Birth"])
    {
        
    }
    else
    {
        if(previousSelectiondate)
            datePickerBase.datepicker.date = previousSelectiondate;
    }
}

-(void)openPicker
{
    [self.view endEditing:YES];
    
    if(!isActionSheetOpen)
    {
        [self setupdatePicker];

        [self.view addSubview:datePickerBase];
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             CGRect frm = datePickerBase.frame;
                             frm.origin.y = frm.origin.y - 200.0;
                             datePickerBase.frame = frm;
                         }
                         completion:nil];
        isActionSheetOpen = YES;
    }
}
#pragma mark - Actionsheet delegate methods
-(void)doneAction
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    
    NSDate *pickedDOB = [datePickerBase.datepicker date];
    previousSelectiondate = [datePickerBase.datepicker date];
    
    NSString *DOB = [NSString stringWithFormat:@"  %@",[dateFormatter stringFromDate:pickedDOB]];
    dobLabel.text = DOB;
    dobLabel.textColor = [UIColor blackColor];
    NSLog (@"This is DOB %@", DOB);
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frm = datePickerBase.frame;
                         frm.origin.y = self.view.frame.size.height;
                         datePickerBase.frame = frm;
                     }
                     completion:^(BOOL finished){
                         [datePickerBase removeFromSuperview];
                         datePickerBase = nil;
                     }];
    isActionSheetOpen = NO;
}

-(void)cancelAction
{
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frm = datePickerBase.frame;
                         frm.origin.y = self.view.frame.size.height;
                         datePickerBase.frame = frm;
                     }
                     completion:^(BOOL finished){
                         [datePickerBase removeFromSuperview];
                         datePickerBase = nil;
                     }];
    isActionSheetOpen = NO;
}

#pragma mark - TextField delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if(isActionSheetOpen)
        [self cancelAction];
    
    CGPoint pt;
	CGRect rc = [textField bounds];
	rc = [textField convertRect:rc toView:scrollView];
	pt = rc.origin;
	pt.x = 0;
	pt.y -= 100;
    [scrollView setContentSize:CGSizeMake(320, scrollContentHeight+250)];
	[scrollView setContentOffset:pt animated:YES];
    
    currentTextField = textField;
    textPassword.secureTextEntry = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //    Allow only 4 char for PIN code
    if(textField==textPinCode)
    {
        NSString* searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if(searchString.length<5)
            return YES;
        else
            return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 40) ? NO : YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textPassword.secureTextEntry = YES;
}

- (void)showPassword {
    
    textPassword.secureTextEntry = !textPassword.isSecureTextEntry;
    textPassword.text = textPassword.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self next:nil];
    return YES;
}


#pragma mark - Action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0)
        [self takePictureAction];
    else if(buttonIndex == 1)
        [self takePhotoLibraryAction];
}


#pragma mark - Action Methods

- (void)clearAllData {
    
    textEmail.text = @"";
    textPassword.text = @"";
    textFirstName.text = @"";
    textLastName.text = @"";
    textPinCode.text = @"";
    userImageView.image = getImage(@"UserPlaceHolder", NO);
    isPictureUpdated = NO;
}

- (IBAction)googlePlusSignIn:(id)sender {
    
    NETWORK_TEST_PROCEDURE;
    
    isSocialButtonPressed = YES;
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    signIn.clientID = GOOGLE_CLIENT_ID;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    // signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    [GPPDeepLink readDeepLinkAfterInstall];
    if(![signIn trySilentAuthentication])
        [signIn authenticate];
    
}

- (IBAction)faceBookSignin:(id)sender {
    
    NETWORK_TEST_PROCEDURE;
    isSocialButtonPressed = YES;
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    [APP_DELEGATE doFacebookLogin:self];
}

- (IBAction)signUpAction:(id)sender {
    
    NETWORK_TEST_PROCEDURE;
    
    if(textEmail.text.length == 0)
        [self showAlertWithMessage:LString(@"ENTER_EMAIL")];
    else if(![textEmail.text isEmail])
        [self showAlertWithMessage:LString(@"ENTER_VALID_EMAIL")];
    else if(textPassword.text.length == 0)
        [self showAlertWithMessage:LString(@"ENTER_PASSWORD")];
    else if(textPassword.text.length < 6)
        [self showAlertWithMessage:LString(@"ENTER_ATLEAST_PASSWORD")];
    else if(textFirstName.text.length == 0)
        [self showAlertWithMessage:LString(@"ENTER_FITST_NAME")];
    else if(textLastName.text.length == 0)
        [self showAlertWithMessage:LString(@"ENTER_LAST_NAME")];
    else if([dobLabel.text isEqualToString:@"  Date of Birth"])
        [self showAlertWithMessage:LString(@"PLEASE_SELECT_DOB")];
    //    else if(textCellNumber.text.length == 0)
    //        [self showAlertWithMessage:LString(@"ENTER_CELL_NUMBER")];
    else if(textPinCode.text.length == 0)
        [self showAlertWithMessage:LString(@"ENTER_PIN")];
    else if(textPinCode.text.length<4)
        [self showAlertWithMessage:LString(@"PIN_ALERT")];
    else {
        [self dismiss:nil];
        self.user.Email     = textEmail.text;
        self.user.Password  = textPassword.text;
        self.user.FirstName = textFirstName.text;
        self.user.LastName  = textLastName.text;
        self.user.UserName  = @""; // [textFirstName.text stringByAppendingString:textLastName.text];
        self.user.PinCode   = textPinCode.text;
        if(isPictureUpdated) self.user.userImage = userImageView.image;
        self.user.ZipCode   = NSNonNilString([placeMark postalCode]);
        self.user.Country = NSNonNilString([placeMark country]);
        // self.user.CellNumber = NSNonNilString(textCellNumber.text);
        self.user.Location = NSNonNilString([placeMark locality]);
        self.user.FBId = @"";
        self.user.GooglePlusId = @"";
        
        if([segment selectedSegmentIndex]==0)
             self.user.Gender = @"1";
        else if([segment selectedSegmentIndex]==1)
            self.user.Gender = @"2";
        else
            self.user.Gender = @"0";
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        NSString *resultString = [formatter stringFromDate:previousSelectiondate];
        self.user.DOB = resultString;
        
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
    [self performSelector:@selector(popViewAfterDelay) withObject:nil afterDelay:0.4];
}

- (void)popViewAfterDelay {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pinCodeAction {
    
    [UIAlertView alertViewWithTitle:LString(@"SAVE_YOUR_TIME_WITH_PIN") message:LString(@"PIN_ALLOWS") cancelButtonTitle:LString(@"OK_GOT_IT")];
}

- (IBAction)takePhoto:(id)sender {
    
    [actionSheet showFromRect:buttonHighLight.frame inView:self.view animated:YES];
    [actionSheet showInView:self.view];
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
    [scrollView setContentSize:CGSizeMake(320, scrollContentHeight)];
    [scrollView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)termsAction:(id)sender {
    
    [self dismiss:nil];
    TLWebViewController *webVC = [[TLWebViewController alloc] initWithNibName:@"TLWebViewController" bundle:nil];
    webVC.titleString = LString(@"TERMS_OF_SERVICE");
    [webVC.webView loadHTMLString:[Global instance].termsContent baseURL:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
    [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
    dontClear = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)privacyAction:(id)sender {
    
    [self dismiss:nil];
    TLWebViewController *webVC = [[TLWebViewController alloc] initWithNibName:@"TLWebViewController" bundle:nil];
    webVC.titleString = LString(@"PRIVACY_POLICY");
    [webVC.webView loadHTMLString:[Global instance].privacyContent baseURL:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
    [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
    dontClear = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)takePictureAction
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        isPush = NO;
        dontClear = YES;
        [self presentViewController:imagePicker animated:YES completion:^{
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        }];
        
    } else {
        
        [UIAlertView alertViewWithMessage:LString(@"NO_VALID_CAMERA")];
    }
}

- (void)takePhotoLibraryAction
{
    isPush = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    dontClear = YES;
    [[imagePicker navigationBar] setTintColor:[UIColor whiteColor]];
    [[imagePicker navigationBar] setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
    
    imagePicker.allowsEditing = NO;
    imagePicker.wantsFullScreenLayout = NO;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)presentAMSlider {
    
    [TuplitConstants loadSliderHomePageWithAnimation:YES];
}

- (void)callLoginWebService {
    
    if(!loginManager) {
        loginManager = [TLLoginManager new];
        loginManager.delegate = self;
    }
    loginManager.user = self.user;
    [loginManager loginUserUsingSocialNW:YES];
}

- (IBAction)pushSocialNWViewController {
    
    TLSocialNWSignUpViewController *socialNWSignUp = [[TLSocialNWSignUpViewController alloc] initWithNibName:@"TLSocialNWSignUpViewController" bundle:nil];
    socialNWSignUp.user = self.user;
    dontClear = NO;
    [self.navigationController pushViewController:socialNWSignUp animated:YES];
}

-(void)signUpsuccessAction
{
    [[ProgressHud shared] showWithMessage:LString(@"REGISTERING") inTarget:self.navigationController.view];
    [userDetailsManager getUserDetailsWithUserID:[Global instance].user.UserId];
}
#pragma mark - UIImagePickerViewController Delegate

- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    PhotoMoveAndScaleController *photoMove=[[PhotoMoveAndScaleController alloc]initWithImage:image imageCropperType:kImageCropperTypeProfileImage];
	[photoMove setDelegate:self];
    dontClear = YES;
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
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];
}


#pragma mark - GooglePlus methods

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error {
    
    // NSLog(@"Received error %@ and auth object %@",error, auth);
    
    if(error) {
//        [[ProgressHud shared] hide];
        [UIAlertView alertViewWithMessage:LString(@"GOOGLE_ERROR")];
        
    } else {
        
        [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];

        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        plusService.apiVersion = @"v1";
        [plusService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error) {
            
            if (error) {
                NSLog(@"Error == %@", error);
                [[ProgressHud shared] hide];
                
            } else {
                googlePlusID = person.identifier;
                self.user.Email = [GPPSignIn sharedInstance].authentication.userEmail;
                self.user.GooglePlusId = person.identifier;
                self.user.FBId = @"";
                self.user.FirstName = person.name.givenName;
                self.user.LastName = person.name.familyName;
                self.user.DOB = person.birthday;
                
                //gender
                if([person.gender isEqualToString:@"male"])
                {
                    self.user.Gender = @"1";
                }
                else if([person.gender isEqualToString:@"female"])
                {
                    self.user.Gender = @"2";
                }
                else
                {
                    self.user.Gender = @"0";
                }
                
                @try {
                    NSString *urlString = [person.image.url stringByReplacingCharactersInRange:NSMakeRange(person.image.url.length-2, 2) withString:@""];
                    urlString = [urlString stringByAppendingString:@"120"];
                    self.user.Photo = urlString;
                }
                @catch (NSException *exception) {
                    self.user.Photo = person.image.url;
                }
                
                if(person.image.url){
                    
                    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.user.Photo]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                        self.user.userImage = [UIImage imageWithData:data];
                        [self callLoginWebService];
                    }];
                } else {
                    [self callLoginWebService];
                }
                
                /*
                 NSLog(@"Email= %@", [GPPSignIn sharedInstance].authentication.userEmail);
                 NSLog(@"GoogleID=%@", person.identifier);
                 NSLog(@"User Name=%@", [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName]);
                 NSLog(@"Gender=%@", person.gender);
                 NSLog(@"Image=%@", person.image.url);
                 */
            }
        }];
    }
}

//Sign out the user
- (void)signOut {
    
    [[GPPSignIn sharedInstance] signOut];
}

// Revoking access tokens and disconnecting the app
- (void)disconnect {
    
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
        
    } else {
        // The user is signed out and disconnected.
        // Clean up user data as specified by the Google+ terms.
        // @"GooglePlusId"
    }
}


#pragma mark - facebook notification

-(void)facebookSignUpNotificationCalled:(NSNotification*)notif
{
    if([notif object])
    {
        NSDictionary *dict = (NSDictionary *)[notif object];
        NSLog(@"facebook dictionary = %@",dict);
        
        self.user.FBId = [dict valueForKey:@"id"];
        self.user.GooglePlusId = @"";
        self.user.Email = [dict valueForKey:@"email"];
        self.user.FirstName = [dict valueForKey:@"first_name"];
        self.user.LastName = [dict valueForKey:@"last_name"];
        self.user.userImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[dict valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"]]]];
     //gender
        if([[dict valueForKey:@"gender"]isEqualToString:@"male"])
        {
            self.user.Gender = @"1";
        }
        else if([[dict valueForKey:@"gender"]isEqualToString:@"female"])
        {
            self.user.Gender = @"2";
        }
        else
        {
            self.user.Gender = @"0";
        }
        
    // dob
        if([dict valueForKey:@"birthday"])
            self.user.DOB = [TuplitConstants facebookFormattedDate:[dict valueForKey:@"birthday"]];
        
        [self callLoginWebService];
        
    }
    else
    {
        [UIAlertView alertViewWithMessage:LString(@"UNABLE_CONNECT")];
        [[ProgressHud shared] hide];
    }
}


#pragma mark - SignUpManagerDelegate methods

- (void)signUpManager:(TLSignUpManager *)signUpManager registerSuccessfullWithUser:(UserModel *)user isAlreadyRegistered:(BOOL)isAlreadyRegistered {
    
    NSLog(@"isAlreadyRegistered = %d",isAlreadyRegistered);
    isAlredyRegister = isAlreadyRegistered;
    
    APP_DELEGATE.loginDetails = @{
                                  @"Email"            : NSNonNilString(textEmail.text),
                                  @"Password"         : NSNonNilString(textPassword.text),
                                  };
    [TLUserDefaults setRememberMeDetails:APP_DELEGATE.loginDetails];
    
    [TLUserDefaults setIsTutorialSkipped:NO];
    if(!loginManager) {
        loginManager = [TLLoginManager new];
        loginManager.delegate = self;
    }
    loginManager.user = self.user;
    [loginManager loginUserUsingSocialNW:NO];
    
}

- (void)signUpManager:(TLSignUpManager *)signUpManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg {
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}

- (void)signUpManagerFailed:(TLSignUpManager *)signUpManager {
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}


#pragma mark - TLLoginManager delegate method

- (void)loginManager:(TLLoginManager *)loginManager loginSuccessfullWithUser:(UserModel *)user {
    
    [Global instance].user = user;
    [TLUserDefaults setAccessToken:user.AccessToken];
    [[ProgressHud shared] hide];
    
    if(!isSocialButtonPressed)
    {
        TLAddCreditCardViewController *addCrCardViewController=[[TLAddCreditCardViewController alloc]init];
        addCrCardViewController.viewController = self;
        [self.navigationController pushViewController:addCrCardViewController animated:YES];
    }
    else
    {
        [userDetailsManager getUserDetailsWithUserID:user.UserId];
    }
    [[TLAppLocationController sharedManager]startUpdatingLocation];
}

- (void)loginManager:(TLLoginManager *)loginManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    if(isSocialButtonPressed) {
        [[ProgressHud shared] hide];
        [self pushSocialNWViewController];
    } else {
        [UIAlertView alertViewWithMessage:errorMsg];
        [[ProgressHud shared] hide];
    }
    [UIAlertView alertViewWithMessage:errorMsg];
}

- (void)loginManagerLoginFailed:(TLLoginManager *)loginManager {
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}


#pragma mark - TLUserDetailsManagerDelegate methods

- (void)userDetailManagerSuccess:(TLUserDetailsManager *)userDetailsManager withUser:(UserModel*)user_ withUserDetail:(UserDetailModel*)userDetail_ {
    
    if(user_.RememberMe.intValue==1) {
        [TLUserDefaults setIsRememberMe:YES];
    }
    else
    {
        [TLUserDefaults setIsRememberMe:NO];
    }
    
    [TLUserDefaults setCurrentUser:user_];
    [TLUserDefaults setIsTutorialSkipped:isSocialButtonPressed];
    [[ProgressHud shared] hide];
    
    [self presentAMSlider];
    
}

- (void)userDetailsManager:(TLUserDetailsManager *)userDetailsManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}

- (void)userDetailsManagerFailed:(TLUserDetailsManager *)userDetailsManager {
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

@end

