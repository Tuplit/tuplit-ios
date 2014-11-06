//
//  TLWelcomeViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 21/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//
// 0x00b3a4

#import "TLWelcomeViewController.h"
#import "TLLoginViewController.h"
#import "TLSignUpViewController.h"
#import "TLSocialNWSignUpViewController.h"
#import "TLLeftMenuViewController.h"
#import "TLMerchantsViewController.h"
#import "TLTutorialViewController.h"
#import "PageControl.h"
#import "TLLoginManager.h"
#import "TLStaticContentManager.h"
#import "Global.h"
#import "TLUserDetailsManager.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "UserModel.h"
#import "SlideShowView.h"


//#define UIColorFromRGBAlpha(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TLWelcomeViewController ()<GPPSignInDelegate, UIScrollViewDelegate, TLLoginManagerDelegate, TLUserDetailsManagerDelegate>
{
    IBOutlet UIButton *buttonFB, *buttonGoogle, *buttonEmail, *buttonLogin, *buttonSkip;
    IBOutlet PageControl *pageControl;
    IBOutlet UIScrollView *_scrollView;
    SlideShowView *scrollView;
    IBOutlet UIImageView *welcomeBgPlaceholderView;
    IBOutlet UIView *footerBgView;
    UserModel *user;
    UIImage *userImage;
    NSString *faceBookID, *googlePlusID;
    TLLoginManager *loginManager;
    CLPlacemark *placeMark;
    UIActivityIndicatorView *spinner;
    NSTimer *timer;
    
    TLUserDetailsManager *userDetailsManager;
    BOOL isSocialLogin;
}
@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;
@end

@implementation TLWelcomeViewController


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
    self.accountStore = nil;
    self.facebookAccount = nil;
    
    loginManager.delegate = nil;
    loginManager = nil;
    
    userDetailsManager.delegate = nil;
    userDetailsManager = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView = [[SlideShowView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [scrollView loadData];
    [_scrollView addSubview:scrollView];
    
    [self.navigationItem setTitle:LString(@"TUPLIT")];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    
    buttonFB.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    buttonGoogle.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    buttonEmail.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    
    [buttonFB setBackgroundColor:UIColorFromRGB(0x61c1dc)];
    [buttonGoogle setBackgroundColor:UIColorFromRGB(0xff8388)];
    [buttonEmail setBackgroundColor:UIColorFromRGB(0x00b3a4)];
    
    [buttonFB setAlpha:0.7];
    [buttonGoogle setAlpha:0.7];
    [buttonEmail setAlpha:0.7];
    
    [buttonLogin setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [buttonSkip setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    [pageControl bringToFront];
    
    scrollView.backgroundColor = [UIColor clearColor];
    
    
//    if(![UI isIPhone5]) {
//        
//        scrollView.height = 220;
//        pageControl.height = 20;
//        scrollView.clipsToBounds = YES;
//        [pageControl positionAtY:245];
//        [footerBgView positionAtY:CGRectGetMaxY(scrollView.frame)];
//        footerBgView.height = footerBgView.height+50;
//        
//        [welcomeBgView positionAtY:CGRectGetMinY(welcomeBgView.frame)];
//        welcomeBgView.clipsToBounds = YES;
//        [buttonFB positionAtY:CGRectGetMinY(buttonFB.frame)-5];
//        [buttonGoogle positionAtY:CGRectGetMaxY(buttonFB.frame)+ 5];
//        [buttonEmail positionAtY:CGRectGetMaxY(buttonGoogle.frame)+ 5];
//        [buttonLogin positionAtY:CGRectGetMaxY(buttonEmail.frame)+ 10];
//        [buttonSkip positionAtY:CGRectGetMaxY(buttonEmail.frame)+ 10];
//    }
    
    user = [UserModel new];
    user.Country  = [CurrentLocation Country];
    user.ZipCode  = [CurrentLocation Zip];
    user.Platform = LString(@"IOS");
    
    CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:[CurrentLocation latitude] longitude:[CurrentLocation longitude]];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:tempLocation completionHandler:
     ^(NSArray *placemarks, NSError* error) {
         if ([placemarks count] > 0) {
             placeMark = [placemarks objectAtIndex:0];
             user.ZipCode = placeMark.postalCode;
             user.Country = placeMark.country;
             user.Location = placeMark.locality;
             APP_DELEGATE.postalCode = placeMark.postalCode;
             APP_DELEGATE.location = placeMark.locality;
         } else if(error) {
             NSLog(@"%@", error);
         } else {
             NSLog(@"%@", placemarks);
         }
     }];
    
//    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    [scrollView addSubview:spinner];
//    spinner.center = scrollView.center;
//    [spinner startAnimating];
    
    //    if([TLUserDefaults isGuestUser])
    //    {
    //        [TLUserDefaults setCurrentUser:nil];
    //        [TLUserDefaults setIsGuestUser:NO];
    //
    ////        [self presentAMSlider];
    //    }
    //    else
    //    {
    //        if ([TLUserDefaults getCurrentUser].RememberMe.intValue==1) {
    ////            [self presentAMSlider];
    //            [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    //            userDetailsManager = [TLUserDetailsManager new];
    //            userDetailsManager.delegate = self;
    //            [userDetailsManager getUserDetailsWithUserID:[TLUserDefaults getCurrentUser].UserId];
    //        }
    //    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFBWelcomeScreen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookWelcomeNotificationCalled:) name:kFBWelcomeScreen object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWelcomeScreenSlideShowStarter object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSlider) name:kWelcomeScreenSlideShowStarter object:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [timer invalidate];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    if([TLUserDefaults isGuestUser])
    {
        [TLUserDefaults setCurrentUser:nil];
        [TLUserDefaults setIsGuestUser:NO];
    }
    else
    {
        if([TLUserDefaults getCurrentUser])
        {
            [self presentAMSlider];
            [[TLAppLocationController sharedManager]startUpdatingLocation];
            isSocialLogin = NO;
            [self performSelectorOnMainThread:@selector(callUserService) withObject:nil waitUntilDone:NO];
        }
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_ {
	
//	int page = scrollView.contentOffset.x / scrollView.frame.size.width;
//	pageControl.currentPage = page;
}


#pragma mark - Action Methods

- (void)startTimer {
//    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
//    [timer performSelector:@selector(fire) withObject:nil afterDelay:3];
}

- (IBAction)faceBookSignin:(id)sender {
    isSocialLogin = YES;
    NETWORK_TEST_PROCEDURE;
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    [APP_DELEGATE doFacebookLogin:self];
}

- (IBAction)googlePlusSignIn:(id)sender {
    isSocialLogin = YES;
    NETWORK_TEST_PROCEDURE;
    
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

- (IBAction)registerWithEmail:(id)sender {
    
    TLSignUpViewController *signUpVC = [[TLSignUpViewController alloc] initWithNibName:@"TLSignUpViewController" bundle:nil];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

- (IBAction)loginAction:(id)sender {
    
    TLLoginViewController *loginVC = [[TLLoginViewController alloc] initWithNibName:@"TLLoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)skipAction:(id)sender {
    
    NETWORK_TEST_PROCEDURE;
    
    [TLUserDefaults setCurrentUser:nil];
    [TLUserDefaults setIsGuestUser:YES];
    [self presentAMSlider];
}

- (IBAction)pageControlPageChanged {
    
    int offsetX = pageControl.currentPage * scrollView.width;
    int offsetY = 0;
    // if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    // offsetY = -20;
	CGPoint offset = CGPointMake(offsetX, offsetY);
	[scrollView setContentOffset:offset animated:YES];
}


- (void)callLoginWebService {
    
    if(!loginManager) {
        loginManager = [TLLoginManager new];
        loginManager.delegate = self;
    }
    
    loginManager.user = user;
    [loginManager loginUserUsingSocialNW:YES];
}

- (void)pushSocialNWViewController {
    
    TLSocialNWSignUpViewController *socialSignUpVC = [[TLSocialNWSignUpViewController alloc] initWithNibName:@"TLSocialNWSignUpViewController" bundle:nil];
    socialSignUpVC.user = user;
    [self.navigationController pushViewController:socialSignUpVC animated:YES];
}

- (void)presentAMSlider {
    
    [TuplitConstants loadSliderHomePageWithAnimation:YES];
}

-(void) loadSlider {
    welcomeBgPlaceholderView.hidden = YES;
    scrollView.slideShowInterval = 5;
    scrollView.slideShowImages = [Global instance].welcomeScreenImages;
    scrollView.isWelcome =YES;
    [scrollView loadData];
}

- (void)timerMethod {
    
    int page = 0;
    
    if(pageControl.currentPage == pageControl.numberOfPages - 1)
        page = 0;
    else
        page = pageControl.currentPage+1;
    
    int offsetX = page * scrollView.width;
    int offsetY = 0;
    
	CGPoint offset = CGPointMake(offsetX, offsetY);
	[scrollView setContentOffset:offset animated:YES];
}
-(void)callUserService
{
    //    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    userDetailsManager = [TLUserDetailsManager new];
    userDetailsManager.delegate = self;
    [userDetailsManager getUserDetailsWithUserID:[TLUserDefaults getCurrentUser].UserId];
    
}

#pragma mark - GooglePlus methods

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error {
    
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
                NSLog(@"%@", person.birthday);
                googlePlusID = person.identifier;
                user.Email = [GPPSignIn sharedInstance].authentication.userEmail;
                user.GooglePlusId = person.identifier;
                user.FBId = @"";
                user.FirstName = person.name.givenName;
                user.LastName = person.name.familyName;
                user.DOB = person.birthday;
                
                //gender
                if([person.gender isEqualToString:@"male"])
                {
                    user.Gender = @"1";
                }
                else if([person.gender isEqualToString:@"female"])
                {
                    user.Gender = @"2";
                }
                else
                {
                    user.Gender = @"0";
                }
                
                @try {
                    NSString *urlString = [person.image.url stringByReplacingCharactersInRange:NSMakeRange(person.image.url.length-2, 2) withString:@""];
                    urlString = [urlString stringByAppendingString:@"120"];
                    
                    user.Photo = urlString;
                    
                }
                @catch (NSException *exception) {
                    user.Photo = person.image.url;
                }
                
                if(person.image.url){
                    
                    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:user.Photo]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                        user.userImage = [UIImage imageWithData:data];
                        [self callLoginWebService];
                    }];
                } else {
                    [self callLoginWebService];
                }
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

-(void)facebookWelcomeNotificationCalled:(NSNotification*)notif
{
    if([notif object])
    {
        NSDictionary *dict = (NSDictionary *)[notif object];
        NSLog(@"facebook dictionary = %@",dict);
        
        
        user.FBId = [dict valueForKey:@"id"];
        user.GooglePlusId = @"";
        user.Email = [dict valueForKey:@"email"];
        user.FirstName = [dict valueForKey:@"first_name"];
        user.LastName = [dict valueForKey:@"last_name"];
        
        //gender
        if([[dict valueForKey:@"gender"]isEqualToString:@"male"])
        {
            user.Gender = @"1";
        }
        else if([[dict valueForKey:@"gender"]isEqualToString:@"female"])
        {
            user.Gender = @"2";
        }
        else
        {
            user.Gender = @"0";
        }
        
        // dob
        if([dict valueForKey:@"birthday"])
            user.DOB = [TuplitConstants facebookFormattedDate:[dict valueForKey:@"birthday"]];

        user.userImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[dict valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"]]]];
        [self callLoginWebService];
    }
    else
    {
        [UIAlertView alertViewWithMessage:LString(@"UNABLE_CONNECT")];
        [[ProgressHud shared] hide];
    }
}

#pragma mark - TLLoginManager delegate method

- (void)loginManager:(TLLoginManager *)loginManager loginSuccessfullWithUser:(UserModel *)userModel {
    
    [Global instance].user = userModel;
    [TLUserDefaults setAccessToken:userModel.AccessToken];
    
    userDetailsManager = [TLUserDetailsManager new];
    userDetailsManager.delegate = self;
    [userDetailsManager getUserDetailsWithUserID:userModel.UserId];
    
     [[TLAppLocationController sharedManager]startUpdatingLocation];
    
}

- (void)loginManager:(TLLoginManager *)loginManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    [[ProgressHud shared] hide];
    [self pushSocialNWViewController];
}

- (void)loginManagerLoginFailed:(TLLoginManager *)loginManager {
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

#pragma mark - TLUserDetailsManagerDelegate methods

- (void)userDetailManagerSuccess:(TLUserDetailsManager *)userDetailsManager withUser:(UserModel*)user_ withUserDetail:(UserDetailModel*)userDetail_ {
    
    [TLUserDefaults setCurrentUser:user_];
    [[ProgressHud shared] hide];
    if(isSocialLogin)
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


