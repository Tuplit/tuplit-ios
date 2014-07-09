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

@interface TLWelcomeViewController ()<GPPSignInDelegate, UIScrollViewDelegate, TLLoginManagerDelegate, TLStaticContentManagerDelegate, TLUserDetailsManagerDelegate>
{
    IBOutlet UIButton *buttonFB, *buttonGoogle, *buttonEmail, *buttonLogin, *buttonSkip;
    IBOutlet PageControl *pageControl;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *welcomeBgView;
    IBOutlet UIView *footerBgView;
    UserModel *user;
    UIImage *userImage;
    NSString *faceBookID, *googlePlusID;
    TLLoginManager *loginManager;
    TLStaticContentManager *staticContentManager;
    CLPlacemark *placeMark;
    UIActivityIndicatorView *spinner;
    NSTimer *timer;
    
    TLUserDetailsManager *userDetailsManager;
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
    
    staticContentManager.delegate = nil;
    staticContentManager = nil;
    
    userDetailsManager.delegate = nil;
    userDetailsManager = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:LString(@"TUPLIT")];
    
    [buttonFB setUpButtonForTuplit];
    [buttonGoogle setUpButtonForTuplit];
    [buttonEmail setUpButtonForTuplit];
    
    [buttonLogin setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [buttonSkip setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    
    [pageControl bringToFront];
    
    scrollView.backgroundColor = [UIColor clearColor];
    
    if(![UI isIPhone5]) {
        scrollView.height = 220;
        pageControl.height = 20;
        scrollView.clipsToBounds = YES;
        [pageControl positionAtY:245];
        [footerBgView positionAtY:CGRectGetMaxY(scrollView.frame)];
        footerBgView.height = footerBgView.height+50;
        
        [welcomeBgView positionAtY:CGRectGetMinY(welcomeBgView.frame)];
        welcomeBgView.clipsToBounds = YES;
        [buttonFB positionAtY:CGRectGetMinY(buttonFB.frame)-5];
        [buttonGoogle positionAtY:CGRectGetMaxY(buttonFB.frame)+ 5];
        [buttonEmail positionAtY:CGRectGetMaxY(buttonGoogle.frame)+ 5];
        [buttonLogin positionAtY:CGRectGetMaxY(buttonEmail.frame)+ 10];
        [buttonSkip positionAtY:CGRectGetMaxY(buttonEmail.frame)+ 10];
    }
    
    user          = [UserModel new];
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
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [scrollView addSubview:spinner];
    spinner.center = scrollView.center;
    [spinner startAnimating];
    
    userDetailsManager = [TLUserDetailsManager new];
    userDetailsManager.delegate = self;
    
    if ([TLUserDefaults getCurrentUser]) {
        [userDetailsManager getUserDetailsWithUserID:[TLUserDefaults getCurrentUser].UserId];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
        
    NETWORK_TEST_PROCEDURE;
    if(!staticContentManager) {
        staticContentManager = [TLStaticContentManager new];
        staticContentManager.delegate = self;
    }
    
    [staticContentManager getStaticContents];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [timer invalidate];
}


#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_ {
	
	int page = scrollView.contentOffset.x / scrollView.frame.size.width;
	pageControl.currentPage = page;
}


#pragma mark - Action Methods

- (IBAction)googlePlusSignIn:(id)sender {
    
    NETWORK_TEST_PROCEDURE;
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    
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
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    [self getFBDetails];
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

- (IBAction)pageControlPageChanged {
    
    int offsetX = pageControl.currentPage * scrollView.width;
    int offsetY = 0;
    // if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
       // offsetY = -20;
	CGPoint offset = CGPointMake(offsetX, offsetY);
	[scrollView setContentOffset:offset animated:YES];
}

- (void)presentAMSlider {
    
        [TuplitConstants loadSliderHomePageWithAnimation:YES];
}

- (void)timerFireDelay {
    
    [timer fire];
}

- (void)timerMethod {
    
    int page = 0;
    //   NSLog(@"page=%d,page=%d",pageControl.currentPage,pageControl.numberOfPages-1);
    
    if(pageControl.currentPage == pageControl.numberOfPages-1)
        page = 0;
    else
        page = pageControl.currentPage+1;
    
    int offsetX = page * scrollView.width;
    int offsetY = 0;
    //if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    //    offsetY = -20;
	CGPoint offset = CGPointMake(offsetX, offsetY);
	[scrollView setContentOffset:offset animated:YES];
}


#pragma mark - GooglePlus methods

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error {
    
    // NSLog(@"Received error %@ and auth object %@",error, auth);
    
    if(error) {
        [[ProgressHud shared] hide];
        [UIAlertView alertViewWithMessage:LString(@"GOOGLE_ERROR")];
        
    } else {
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
                user.Email = [GPPSignIn sharedInstance].authentication.userEmail;
                user.GooglePlusId = person.identifier;
                user.FBId = @"";
                user.FirstName = person.name.givenName;
                user.LastName = person.name.familyName;
                
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


#pragma mark - Facebook Methods

- (void)getFBDetails {
    
    if(!_accountStore)
        _accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *facebookTypeAccount = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [_accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                           options:@{ACFacebookAppIdKey:FacebookAppID, ACFacebookPermissionsKey: @[@"email"]}
                                        completion:^(BOOL granted, NSError *error) {
                                            if (granted){
                                                NSArray *accounts = [_accountStore accountsWithAccountType:facebookTypeAccount];
                                                self.facebookAccount = [accounts lastObject];
                                                NSLog(@"Success");
                                                
                                                NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
                                                
                                                SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                                                          requestMethod:SLRequestMethodGET
                                                                                                    URL:meurl
                                                                                             parameters:nil];
                                                
                                                merequest.account = self.facebookAccount;
                                                
                                                [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                                    
                                                    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        // [self.socialDict setObject:[responseJSON objectForKey:@"id"] forKey:PARAM_FB_ID];
                                                        
                                                        
                                                        NSString *title = @"";
                                                        NSString *company = @"";
                                                        
                                                        NSArray *workAry = [responseJSON objectForKey:@"work"];
                                                        
                                                        if(workAry.count > 0) {
                                                            
                                                            NSDictionary *workDict = workAry[0];
                                                            if(workDict != nil) {
                                                                
                                                                NSString *compName = [[workDict objectForKey:@"employer"] objectForKey:@"name"];
                                                                NSString *title_ = [[workDict objectForKey:@"position"] objectForKey:@"name"];
                                                                company = NSNonNilString(compName);
                                                                title = NSNonNilString(title_);
                                                            }
                                                        }
                                                        
                                                        faceBookID = [responseJSON valueForKey:@"id"];
                                                        user.FBId = faceBookID;
                                                        user.GooglePlusId = @"";
                                                        user.Email = [responseJSON valueForKey:@"email"];
                                                        user.FirstName = [responseJSON valueForKey:@"first_name"];
                                                        user.LastName = [responseJSON valueForKey:@"last_name"];
                                                        
                                                        NSLog(@"%@", responseJSON);
                                                        // http://graph.facebook.com/100000883018352/picture?type=large
                                                        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", user.FBId]]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                            user.userImage = [UIImage imageWithData:data];
                                                            [self callLoginWebService];
                                                        }];
                                                        
                                                    });
                                                }];
                                                
                                            } else {
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                    // Fail gracefully...
                                                    NSLog(@"%@",error.description);
                                                    if([error code]== ACErrorAccountNotFound) {
                                                        
                                                        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                                                        controller.view.hidden = YES;
                                                        [self presentViewController:controller animated:NO completion:^{
                                                            [controller.view endEditing:YES];
                                                        }];
                                                        
                                                    } else if([error code]== ACErrorPermissionDenied) {
                                                        [UIAlertView alertViewWithMessage:LString(@"ACCESS_DENIED")];
                                                    } else {
                                                        [UIAlertView alertViewWithMessage:LString(@"UNABLE_CONNECT")];
                                                    }
                                                    [[ProgressHud shared] hide];
                                                });
                                            }
                                        }];
}


#pragma mark - TLLoginManager delegate method

- (void)loginManager:(TLLoginManager *)loginManager loginSuccessfullWithUser:(UserModel *)userModel {
    
    [Global instance].user = userModel;
    [TLUserDefaults setAccessToken:userModel.AccessToken];
    [userDetailsManager getUserDetailsWithUserID:userModel.UserId];
}

- (void)loginManager:(TLLoginManager *)loginManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    [[ProgressHud shared] hide];
    [self pushSocialNWViewController];
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

#pragma mark - TLStaticContentManager delegate methods

- (void)staticContentManagerSuccess:(TLStaticContentManager *)staticContentManager {
    
    [spinner stopAnimating];
    // To manage the number of slides
    for (int i=0; i<[Global instance].welcomeScreenImages.count; i++) {
        EGOImageView *egoIV = (EGOImageView*)[scrollView viewWithTag:100+i];
        [egoIV removeFromSuperview];
    }
    
    int numberOfSlides = [Global instance].welcomeScreenImages.count;
    pageControl.numberOfPages = numberOfSlides;
    for(int i = 0; i<numberOfSlides ; i++) {
        EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:nil imageViewFrame:CGRectMake(i*320, 0, 320, scrollView.height)];
        imageView.tag = 100+i;
        imageView.clipsToBounds = YES;
        NSURL *imageUrl = [NSURL URLWithString:[Global instance].welcomeScreenImages[i]];
        [imageView setImageURL:imageUrl];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    [self performSelector:@selector(timerFireDelay) withObject:nil afterDelay:3];
    
    scrollView.delegate = self;
    [scrollView setContentSize:CGSizeMake(320*numberOfSlides, scrollView.height)];
}

- (void)staticContentManager:(TLStaticContentManager *)staticContentManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    pageControl.numberOfPages = 0;
    [spinner stopAnimating];
    [UIAlertView alertViewWithMessage:errorMsg];
}

- (void)staticContentManagerFailed:(TLStaticContentManager *)staticContentManager {
    
    [spinner stopAnimating];
}

@end


