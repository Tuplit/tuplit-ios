//
//  TLSettingsViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLSettingsViewController.h"
#import "CustomSwitch.h"
#import "TLTutorialViewController.h"
#import "TLPinCodeViewController.h"
#import "TuplitConstants.h"
#import "TLStaticContentManager.h"
#import "TLHelpCenterViewController.h"
#import "TLWebViewController.h"
#import "UserModel.h"

@interface TLSettingsViewController ()<TLStaticContentManagerDelegate>
{
    
    UIScrollView *scrollView;
    CGFloat baseViewWidth,baseViewHeight;
    
    
    CustomSwitch *notificationSwitch;
    CustomSwitch *buySwitch;
    CustomSwitch *receiveSwitch;
    CustomSwitch *sendMoneySwitch;
    CustomSwitch *dealOfferSwitch;
    CustomSwitch *passcodeSwitch;
    CustomSwitch *rememberSwitch;
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

#pragma mark - View Life Cycle Methods.

-(void) loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setTitle:LString(@"SETTINGS")];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
    [navleftButton buttonWithIcon:getImage(@"List", NO) target:self action:@selector(presentLeftMenuViewController:) isLeft:NO];
    [self.navigationItem setLeftBarButtonItem:navleftButton];
    
    baseViewWidth= self.view.frame.size.width;
    baseViewHeight= self.view.frame.size.height;
    
    int adjustHeight = 64;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        adjustHeight = 64;
    }
    else
    {
        adjustHeight = 44;
    }
    
    UIView *baseView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight-adjustHeight)];
    baseView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:baseView];
    
    //    NSArray *sectionNames = [NSArray arrayWithObjects:@"",@"Notifications",@"Security",@"",@", nil]
    UserModel *userdetails = [TLUserDefaults getCurrentUser];
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, baseViewWidth, baseView.frame.size.height)];
    scrollView.bounces=YES;
    scrollView.userInteractionEnabled=YES;
    scrollView.backgroundColor=[UIColor clearColor];
    [baseView addSubview:scrollView];
    
    UILabel *soundsLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, 20, 188, 35)];
    soundsLbl.text=LString(@"SOUND");
    soundsLbl.textColor=UIColorFromRGB(0x000000);
    soundsLbl.textAlignment=NSTextAlignmentLeft;
    soundsLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    soundsLbl.backgroundColor=[UIColor clearColor];
    [scrollView addSubview:soundsLbl];
    
    CustomSwitch *soundsSwitch=[[CustomSwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(soundsLbl.frame), 20, 102, 35)];
    soundsSwitch.onText=LString(@"ON");
    soundsSwitch.offText=LString(@"OFF");
    [soundsSwitch setOn:[userdetails.Sounds boolValue] animated:YES];
    [soundsSwitch addTarget:self action:@selector(soundSwitchAction:) forControlEvents:UIControlEventValueChanged];
    soundsSwitch.isRounded=NO;
    [scrollView addSubview:soundsSwitch];
    
    //    Notification Part
    
    UIView *notificationView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(soundsLbl.frame), baseViewWidth, 263)];
    notificationView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:notificationView];
    
    UILabel *notificationLbl=[[UILabel alloc] initWithFrame:CGRectMake(15,0,290, 45)];
    notificationLbl.text=LString(@"NOTIFICATION");
    notificationLbl.textColor=UIColorFromRGB(0x999999);
    notificationLbl.textAlignment=NSTextAlignmentLeft;
    notificationLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    notificationLbl.backgroundColor=[UIColor clearColor];
    [notificationView addSubview:notificationLbl];
    
    UILabel *allNotificationLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(notificationLbl.frame), 188, 35)];
    allNotificationLbl.text=LString(@"ALL_NOTIFICATION");
    allNotificationLbl.textColor=UIColorFromRGB(0x000000);
    allNotificationLbl.textAlignment=NSTextAlignmentLeft;
    allNotificationLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    allNotificationLbl.backgroundColor=[UIColor clearColor];
    [notificationView addSubview:allNotificationLbl];
    
    notificationSwitch=[[CustomSwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(allNotificationLbl.frame), CGRectGetMaxY(notificationLbl.frame), 102, 35)];
    notificationSwitch.onText=LString(@"ON");
    notificationSwitch.offText=LString(@"OFF");
    notificationSwitch.isRounded=NO;
    [notificationSwitch setOn:[userdetails.PushNotification boolValue] animated:YES];
    [notificationSwitch addTarget:self action:@selector(notificationSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [notificationView addSubview:notificationSwitch];
    
    UILabel *buySomethingLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(allNotificationLbl.frame) + 10, 188, 35)];
    buySomethingLbl.text=LString(@"BUY_SOMETHING");
    buySomethingLbl.textColor=UIColorFromRGB(0x000000);
    buySomethingLbl.textAlignment=NSTextAlignmentLeft;
    buySomethingLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    buySomethingLbl.backgroundColor=[UIColor clearColor];
    [notificationView addSubview:buySomethingLbl];
    
    buySwitch=[[CustomSwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buySomethingLbl.frame), CGRectGetMaxY(allNotificationLbl.frame) +10, 102, 35)];
    buySwitch.onText=LString(@"ON");
    buySwitch.offText=LString(@"OFF");
    buySwitch.isRounded=NO;
    [buySwitch setOn:[userdetails.BuySomething boolValue]animated:YES];
    [buySwitch addTarget:self action:@selector(buySwitchAction:) forControlEvents:UIControlEventValueChanged];
    [notificationView addSubview:buySwitch];
    
    UILabel *receiveMoneyLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(buySomethingLbl.frame)+10, 188, 35)];
    receiveMoneyLbl.text=LString(@"RECEIVE_MONEY");
    receiveMoneyLbl.textColor=UIColorFromRGB(0x000000);
    receiveMoneyLbl.textAlignment=NSTextAlignmentLeft;
    receiveMoneyLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    receiveMoneyLbl.backgroundColor=[UIColor clearColor];
    [notificationView addSubview:receiveMoneyLbl];
    
    receiveSwitch=[[CustomSwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(receiveMoneyLbl.frame), CGRectGetMaxY(buySomethingLbl.frame)+10, 102, 35)];
    receiveSwitch.onText=LString(@"ON");
    receiveSwitch.offText=LString(@"OFF");
    receiveSwitch.isRounded=NO;
    [receiveSwitch setOn:[userdetails.RecieveCredit boolValue]animated:YES];
    [receiveSwitch addTarget:self action:@selector(receiveSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [notificationView addSubview:receiveSwitch];
    
    UILabel *sendMoneyLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(receiveMoneyLbl.frame)+10, 188, 35)];
    sendMoneyLbl.text=LString(@"SEND_MONEY");
    sendMoneyLbl.textColor=UIColorFromRGB(0x000000);
    sendMoneyLbl.textAlignment=NSTextAlignmentLeft;
    sendMoneyLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    sendMoneyLbl.backgroundColor=[UIColor clearColor];
    [notificationView addSubview:sendMoneyLbl];
    
    sendMoneySwitch=[[CustomSwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sendMoneyLbl.frame), CGRectGetMaxY(receiveMoneyLbl.frame)+10, 102, 35)];
    sendMoneySwitch.onText=LString(@"ON");
    sendMoneySwitch.offText=LString(@"OFF");
    sendMoneySwitch.isRounded=NO;
    [sendMoneySwitch setOn:[userdetails.SendCredit boolValue]animated:YES];
    [sendMoneySwitch addTarget:self action:@selector(senMoneySwitchAction:) forControlEvents:UIControlEventValueChanged];
    [notificationView addSubview:sendMoneySwitch];
    
    UILabel *dealOfferLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(sendMoneyLbl.frame)+10, 188, 35)];
    dealOfferLbl.text=LString(@"DEAL_OFFERS");
    dealOfferLbl.textColor=UIColorFromRGB(0x000000);
    dealOfferLbl.textAlignment=NSTextAlignmentLeft;
    dealOfferLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    dealOfferLbl.backgroundColor=[UIColor clearColor];
    [notificationView addSubview:dealOfferLbl];
    
    dealOfferSwitch=[[CustomSwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dealOfferLbl.frame), CGRectGetMaxY(sendMoneyLbl.frame)+10, 102, 35)];
    dealOfferSwitch.onText=LString(@"ON");
    dealOfferSwitch.offText=LString(@"OFF");
    dealOfferSwitch.isRounded=NO;
    [dealOfferSwitch setOn:[userdetails.DealsOffers boolValue]animated:YES];
    [dealOfferSwitch addTarget:self action:@selector(dealOfferSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [notificationView addSubview:dealOfferSwitch];
    
    //    Security Part
    UIView *securityView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(notificationView.frame), baseViewWidth, 186)];
    securityView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:securityView];
    
    UILabel *securityLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, 0,290, 45)];
    securityLbl.text=LString(@"SECURITY");
    securityLbl.textColor=UIColorFromRGB(0x999999);
    securityLbl.textAlignment=NSTextAlignmentLeft;
    securityLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    securityLbl.backgroundColor=[UIColor clearColor];
    [securityView addSubview:securityLbl];
    
    UILabel *passcodeLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(securityLbl.frame), 188, 35)];
    passcodeLbl.text=LString(@"PASSCODE");
    passcodeLbl.textColor=UIColorFromRGB(0x000000);
    passcodeLbl.textAlignment=NSTextAlignmentLeft;
    passcodeLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    passcodeLbl.backgroundColor=[UIColor clearColor];
    [securityView addSubview:passcodeLbl];
    
    passcodeSwitch=[[CustomSwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passcodeLbl.frame), CGRectGetMaxY(securityLbl.frame), 102, 35)];
    passcodeSwitch.onText=LString(@"ON");
    passcodeSwitch.offText=LString(@"OFF");
    [passcodeSwitch setOn:[userdetails.Passcode boolValue]animated:YES];
    passcodeSwitch.isRounded=NO;
    [passcodeSwitch addTarget:self action:@selector(passcodeSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [securityView addSubview:passcodeSwitch];
    
    UILabel *rememberMeLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(passcodeLbl.frame)+10, 188, 35/2)];
    rememberMeLbl.text=LString(@"REMEMBER_ME");
    rememberMeLbl.textColor=UIColorFromRGB(0x000000);
    rememberMeLbl.textAlignment=NSTextAlignmentLeft;
    rememberMeLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    rememberMeLbl.backgroundColor=[UIColor clearColor];
    [securityView addSubview:rememberMeLbl];
    
    UILabel *rememberSubLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(rememberMeLbl.frame), 188, 35/2)];
    rememberSubLbl.text=LString(@"(Picture, Payment Prefs., Favorites, etc.)");
    rememberSubLbl.textColor=UIColorFromRGB(0x999999);
    rememberSubLbl.textAlignment=NSTextAlignmentLeft;
    rememberSubLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:9.0];
    rememberSubLbl.backgroundColor=[UIColor clearColor];
    [securityView addSubview:rememberSubLbl];
    
    rememberSwitch=[[CustomSwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rememberMeLbl.frame), CGRectGetMaxY(passcodeLbl.frame)+10, 102, 35)];
    rememberSwitch.onText=LString(@"ON");
    rememberSwitch.offText=LString(@"OFF");
    [rememberSwitch setOn:[userdetails.RememberMe boolValue]animated:YES];
    rememberSwitch.isRounded=NO;
    [rememberSwitch addTarget:self action:@selector(rememberSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [securityView addSubview:rememberSwitch];
    
    UIButton *changePinBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [changePinBtn setFrame:CGRectMake(15, CGRectGetMaxY(rememberSubLbl.frame)+19, 290, 45)];
    [changePinBtn setTitle:LString(@"CHANGE_PIN_CODE") forState:UIControlStateNormal];
    [changePinBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    changePinBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    changePinBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [changePinBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [changePinBtn addTarget:self action:@selector(changePinCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [securityView addSubview:changePinBtn];
    
//    UIButton *addNumberBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [addNumberBtn setFrame:CGRectMake(15, CGRectGetMaxY(changePinBtn.frame) +10, 290, 45)];
//    [addNumberBtn setTitle:LString(@"ADD_NUMBER") forState:UIControlStateNormal];
//    [addNumberBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//    addNumberBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
//    addNumberBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
//    [addNumberBtn setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
//    [addNumberBtn addTarget:self action:@selector(addNumberAction) forControlEvents:UIControlEventTouchUpInside];
//    [securityView addSubview:addNumberBtn];
    
    //    Support Part
    
    UIView *supportView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(securityView.frame), baseViewWidth, 200)];
    supportView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:supportView];
    
    UIButton *helpCenterBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [helpCenterBtn setFrame:CGRectMake(15, 12, 290, 45)];
    [helpCenterBtn setTitle:LString(@"HELP_CENTER") forState:UIControlStateNormal];
    [helpCenterBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    helpCenterBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    helpCenterBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [helpCenterBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [helpCenterBtn addTarget:self action:@selector(openHelpCenter) forControlEvents:UIControlEventTouchUpInside];
    [supportView addSubview:helpCenterBtn];
    
    UIButton *legalBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [legalBtn setFrame:CGRectMake(15, CGRectGetMaxY(helpCenterBtn.frame) +10, 290, 45)];
    [legalBtn setTitle:LString(@"LEGAL") forState:UIControlStateNormal];
    [legalBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    legalBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    legalBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [legalBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [legalBtn addTarget:self action:@selector(termsAndLegalInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [supportView addSubview:legalBtn];
    
    UIButton *logOutBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [logOutBtn setFrame:CGRectMake(15, CGRectGetMaxY(legalBtn.frame) +10, 290, 45)];
    [logOutBtn setTitle:LString(@"LOG_OUT") forState:UIControlStateNormal];
    [logOutBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    logOutBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    logOutBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [logOutBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [logOutBtn addTarget:self action:@selector(logOutAction) forControlEvents:UIControlEventTouchUpInside];
    [supportView addSubview:logOutBtn];

//    UILabel *aboutLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, 0 + 15, 100, 20)];
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    aboutLbl.text= [NSString stringWithFormat:@"About (v%@)",version];
//    aboutLbl.textColor=UIColorFromRGB(0x999999);
//    aboutLbl.textAlignment=NSTextAlignmentLeft;
//    aboutLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
//    aboutLbl.backgroundColor=[UIColor clearColor];
//    [supportView addSubview:aboutLbl];
//    
//    UILabel *customerSupportLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(aboutLbl.frame) + 10, 150, 20)];
//    customerSupportLbl.text=LString(@"CUSTOMER_SUPPORT");
//    customerSupportLbl.textColor=UIColorFromRGB(0x999999);
//    customerSupportLbl.textAlignment=NSTextAlignmentLeft;
//    customerSupportLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
//    customerSupportLbl.backgroundColor=[UIColor clearColor];
//    [supportView addSubview:customerSupportLbl];
//    
//    UILabel *emailLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(customerSupportLbl.frame)+5, 50, 20)];
//    emailLbl.text=LString(@"EMAIL");
//    emailLbl.textColor=UIColorFromRGB(0x000000);
//    emailLbl.textAlignment=NSTextAlignmentLeft;
//    emailLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
//    emailLbl.backgroundColor=[UIColor clearColor];
//    [supportView addSubview:emailLbl];
//    
//    UILabel *emailIDLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(emailLbl.frame)+ 4, CGRectGetMaxY(customerSupportLbl.frame)+5, 200, 20)];
//    emailIDLbl.text=CUSTOMER_SUPPORT_EMAIL;
//    emailIDLbl.textColor=UIColorFromRGB(0x00b3a4);
//    emailIDLbl.textAlignment=NSTextAlignmentLeft;
//    emailIDLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
//    emailIDLbl.backgroundColor=[UIColor clearColor];
//    emailIDLbl.userInteractionEnabled = YES;
//    UITapGestureRecognizer *emailtapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(supportMailAction)];
//    [emailIDLbl addGestureRecognizer:emailtapGesture];
//    [supportView addSubview:emailIDLbl];
//    
//    UILabel *phoneLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(emailLbl.frame)+5, 60, 20)];
//    phoneLbl.text=LString(@"PHONE");
//    phoneLbl.textColor=UIColorFromRGB(0x000000);
//    phoneLbl.textAlignment=NSTextAlignmentLeft;
//    phoneLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
//    phoneLbl.backgroundColor=[UIColor clearColor];
//    [supportView addSubview:phoneLbl];
//    
//    UILabel *phoneNumberLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLbl.frame), CGRectGetMaxY(emailLbl.frame)+5, 200, 20)];
//    phoneNumberLbl.text=CUSTOMER_SUPPORT_PNUMBER;
//    phoneNumberLbl.textColor=UIColorFromRGB(0x00b3a4);
//    phoneNumberLbl.textAlignment=NSTextAlignmentLeft;
//    phoneNumberLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
//    phoneNumberLbl.backgroundColor=[UIColor clearColor];
//    phoneNumberLbl.userInteractionEnabled = YES;
//    UITapGestureRecognizer *phonetapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneNumCallAction)];
//    [phoneNumberLbl addGestureRecognizer:phonetapGesture];
//    [supportView addSubview:phoneNumberLbl];
//    
//    UIButton *questionBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [questionBtn setFrame:CGRectMake(15, CGRectGetMaxY(phoneLbl.frame)+15, 290, 45)];
//    [questionBtn setTitle:LString(@"FAQ") forState:UIControlStateNormal];
//    [questionBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//    questionBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
//    questionBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
//    [questionBtn setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
//    [questionBtn addTarget:self action:@selector(frequentQuestionAction) forControlEvents:UIControlEventTouchUpInside];
//    [supportView addSubview:questionBtn];
//    
//    UIButton *tutorialBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [tutorialBtn setFrame:CGRectMake(15, CGRectGetMaxY(questionBtn.frame) +10, 290, 45)];
//    [tutorialBtn setTitle:LString(@"TUTORIALS") forState:UIControlStateNormal];
//    [tutorialBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//    tutorialBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
//    tutorialBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
//    [tutorialBtn setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
//    [tutorialBtn addTarget:self action:@selector(tutorialAction) forControlEvents:UIControlEventTouchUpInside];
//    [supportView addSubview:tutorialBtn];
//    
//    UIButton *termsLegalInfoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [termsLegalInfoBtn setFrame:CGRectMake(15, CGRectGetMaxY(tutorialBtn.frame) +10, 290, 45)];
//    [termsLegalInfoBtn setTitle:LString(@"TERMS_LEGAL_INFO") forState:UIControlStateNormal];
//    [termsLegalInfoBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//    termsLegalInfoBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
//    termsLegalInfoBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
//    [termsLegalInfoBtn setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
//    [termsLegalInfoBtn addTarget:self action:@selector(termsAndLegalInfoAction) forControlEvents:UIControlEventTouchUpInside];
//    [supportView addSubview:termsLegalInfoBtn];
//    
//    UIButton *privacybtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [privacybtn setFrame:CGRectMake(15, CGRectGetMaxY(termsLegalInfoBtn.frame) +10, 290, 45)];
//    [privacybtn setTitle:LString(@"PRIVACY_POLICY") forState:UIControlStateNormal];
//    [privacybtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//    privacybtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
//    privacybtn.titleLabel.textAlignment=NSTextAlignmentCenter;
//    [privacybtn setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
//    [privacybtn addTarget:self action:@selector(privacyPolicyAction) forControlEvents:UIControlEventTouchUpInside];
//    [supportView addSubview:privacybtn];
//    
//    
    
    scrollView.contentSize=CGSizeMake(baseViewWidth,CGRectGetMaxY(supportView.frame)+30);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    if (screenHeight < 568)
    {
        scrollView.contentSize=CGSizeMake(baseViewWidth,CGRectGetMaxY(supportView.frame)+100);
    }
    
    if([TLUserDefaults isGuestUser])
    {
        notificationSwitch.enabled = NO;
        buySwitch.enabled = NO;
        receiveSwitch.enabled = NO;
        sendMoneySwitch.enabled = NO;
        dealOfferSwitch.enabled = NO;
        passcodeSwitch.enabled = NO;
        rememberSwitch.enabled = NO;
        changePinBtn.enabled = NO;
//        addNumberBtn.enabled = NO;
        soundsSwitch.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    
    UserModel *userdetails = [TLUserDefaults getCurrentUser];
    
    [buySwitch setOn:[userdetails.BuySomething boolValue]animated:YES];
    [receiveSwitch setOn:[userdetails.RecieveCredit boolValue]animated:YES];
    [sendMoneySwitch setOn:[userdetails.SendCredit boolValue]animated:YES];
    [dealOfferSwitch setOn:[userdetails.DealsOffers boolValue]animated:YES];
    [passcodeSwitch setOn:[userdetails.Passcode boolValue]animated:YES];
    [rememberSwitch setOn:[userdetails.RememberMe boolValue]animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - User Defined Methods

-(void)callService:(NSDictionary*)queryParams
{
    
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    
    TLSettingsManager *settingManager = [[TLSettingsManager alloc]init];
    settingManager.delegate = self;
    [settingManager callService:queryParams];
}

-(void) logOutAction
{
    [UIAlertView alertViewWithTitle:@"Tuplit" message:LString(@"LOG_OUT_ALERT") cancelButtonTitle:LString(@"NO") otherButtonTitles:[NSArray arrayWithObject:LString(@"YES")]
                          onDismiss:^(int buttonIndex)
     {
         if(buttonIndex == 0)
         {
             [TuplitConstants userLogout];
         }
     }
                           onCancel:^()
     {
         NSLog(@"Cancelled");
     }];
    
}

-(void) changePinCodeAction
{
    TLPinCodeViewController *pincodeVC=[[TLPinCodeViewController alloc] init];
    pincodeVC.navigationTitle = LString(@"ENTER_PIN_CODE");
    pincodeVC.isverifyPin = NO;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pincodeVC];
    [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void) addNumberAction
{
    [UIAlertView alertViewWithMessage:@"Add Number is under construction. Will be available in future demos."];
    NSLog(@"Add Number Action...");
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
    [self presentViewController:tutorialViewController animated:YES completion:nil];
}

-(void)openHelpCenter
{
    TLHelpCenterViewController *helpCenterViewController=[[TLHelpCenterViewController alloc]init];
    [self.navigationController pushViewController:helpCenterViewController animated:YES];
}

-(void) privacyPolicyAction
{
    TLWebViewController *webVC = [[TLWebViewController alloc] initWithNibName:@"TLWebViewController" bundle:nil];
    webVC.titleString = LString(@"PRIVACY_POLICY");
    webVC.viewController =self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
    [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void) termsAndLegalInfoAction
{
    TLWebViewController *webVC = [[TLWebViewController alloc] initWithNibName:@"TLWebViewController" bundle:nil];
    webVC.titleString = LString(@"LEGAL");
    webVC.viewController =self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
    [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void) soundSwitchAction : (CustomSwitch *) sender
{
    NETWORK_TEST_PROCEDURE
    
    _user_model = [self getcurrentUserDetails];
    
    if(sender.isOn)
        _user_model.Sounds = [NSString stringWithFormat:@"%d",1];
    else
        _user_model.Sounds = [NSString stringWithFormat:@"%d",0];
    
    NSDictionary *queryParams = @{
                                  @"Type"   : NSNonNilString(@"Sounds"),
                                  @"Action" : [NSString stringWithFormat:@"%d",sender.isOn],
                                  };
    [self callService:queryParams];
    
}

-(void) notificationSwitchAction : (CustomSwitch *) sender
{
    NETWORK_TEST_PROCEDURE
    
    _user_model = [self getcurrentUserDetails];
    if(sender.isOn)
    {
//        buySwitch.on = YES;
//        receiveSwitch.on = YES;
//        sendMoneySwitch.on = YES;
//        dealOfferSwitch.on = YES;
        
        [buySwitch showOn:YES];
        [receiveSwitch showOn:YES];
        [sendMoneySwitch showOn:YES];
        [dealOfferSwitch showOn:YES];
        
        
        _user_model.PushNotification = [NSString stringWithFormat:@"%d",1];
        _user_model.BuySomething = [NSString stringWithFormat:@"%d",1];
        _user_model.RecieveCredit = [NSString stringWithFormat:@"%d",1];
        _user_model.SendCredit = [NSString stringWithFormat:@"%d",1];
        _user_model.DealsOffers = [NSString stringWithFormat:@"%d",1];
        
    }
    else
    {
//        buySwitch.on = NO;
//        receiveSwitch.on = NO;
//        sendMoneySwitch.on = NO;
//        dealOfferSwitch.on = NO;
        
        [buySwitch showOff:YES];
        [receiveSwitch showOff:YES];
        [sendMoneySwitch showOff:YES];
        [dealOfferSwitch showOff:YES];
        
        _user_model.PushNotification = [NSString stringWithFormat:@"%d",0];
        _user_model.BuySomething = [NSString stringWithFormat:@"%d",0];
        _user_model.RecieveCredit = [NSString stringWithFormat:@"%d",0];
        _user_model.SendCredit = [NSString stringWithFormat:@"%d",0];
        _user_model.DealsOffers = [NSString stringWithFormat:@"%d",0];
    }
    NSDictionary *queryParams = @{
                                  @"Type"   : NSNonNilString(@"All"),
                                  @"Action" : [NSString stringWithFormat:@"%d",sender.isOn],
                                  };
    [self callService:queryParams];
}


-(void) buySwitchAction : (CustomSwitch *) sender
{
    NETWORK_TEST_PROCEDURE
    
    _user_model = [self getcurrentUserDetails];
    _user_model.BuySomething = [NSString stringWithFormat:@"%d",sender.isOn];
    
    [self checkButtons];
    
    NSDictionary *queryParams = @{
                                  @"Type"   : NSNonNilString(@"BuySomething"),
                                  @"Action" : [NSString stringWithFormat:@"%d",sender.isOn],
                                  };
    
    [self callService:queryParams];
    
}


-(void) receiveSwitchAction : (CustomSwitch *) sender
{
    NETWORK_TEST_PROCEDURE
    
    _user_model = [self getcurrentUserDetails];
    _user_model.RecieveCredit = [NSString stringWithFormat:@"%d",sender.isOn];
    
    [self checkButtons];
    
    NSDictionary *queryParams = @{
                                  @"Type"   : NSNonNilString(@"RecieveCredit"),
                                  @"Action" : [NSString stringWithFormat:@"%d",sender.isOn],
                                  };
    [self callService:queryParams];
    
}

-(void) senMoneySwitchAction : (CustomSwitch *) sender
{
    NETWORK_TEST_PROCEDURE
    
    _user_model = [self getcurrentUserDetails];
    _user_model.SendCredit = [NSString stringWithFormat:@"%d",sender.isOn];
    
    [self checkButtons];
    
    NSDictionary *queryParams = @{
                                  @"Type"   : NSNonNilString(@"SendCredit"),
                                  @"Action" : [NSString stringWithFormat:@"%d",sender.isOn],
                                  };
    [self callService:queryParams];
    
}


-(void) dealOfferSwitchAction : (CustomSwitch *) sender
{
    NETWORK_TEST_PROCEDURE
    
    _user_model = [self getcurrentUserDetails];
    _user_model.DealsOffers = [NSString stringWithFormat:@"%d",sender.isOn];
    
    [self checkButtons];
    
    NSDictionary *queryParams = @{
                                  @"Type"   : NSNonNilString(@"DealsOffers"),
                                  @"Action" : [NSString stringWithFormat:@"%d",sender.isOn],
                                  };
    [self callService:queryParams];
    
}


-(void) passcodeSwitchAction : (CustomSwitch *) sender
{
    NETWORK_TEST_PROCEDURE
    
    _user_model = [self getcurrentUserDetails];
    _user_model.Passcode = [NSString stringWithFormat:@"%d",sender.isOn];
    
    NSDictionary *queryParams = @{
                                  @"Type"   : NSNonNilString(@"Passcode"),
                                  @"Action" : [NSString stringWithFormat:@"%d",sender.isOn],
                                  };
    [self callService:queryParams];
}


-(void) paymentSwitchAction : (CustomSwitch *) sender
{
    NETWORK_TEST_PROCEDURE
    
    _user_model = [self getcurrentUserDetails];
    _user_model.PaymentPreference = [NSString stringWithFormat:@"%d",sender.isOn];
    
    NSDictionary *queryParams = @{
                                  @"Type"   : NSNonNilString(@"PaymentPreference"),
                                  @"Action" : [NSString stringWithFormat:@"%d",sender.isOn],
                                  };
    [self callService:queryParams];
}

-(void) rememberSwitchAction : (CustomSwitch *) sender
{
    NETWORK_TEST_PROCEDURE
    
    _user_model = [self getcurrentUserDetails];
    _user_model.RememberMe = [NSString stringWithFormat:@"%d",sender.isOn];
    
    NSDictionary *queryParams = @{
                                  @"Type"   : NSNonNilString(@"RememberMe"),
                                  @"Action" : [NSString stringWithFormat:@"%d",sender.isOn],
                                  };
    [self callService:queryParams];
}

-(void)supportMailAction
{
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.navigationBar.barStyle = UIBarStyleDefault;
        [[controller navigationBar] setTintColor:UIColorFromRGB(0XFFFFFF)];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[NSArray arrayWithObject:CUSTOMER_SUPPORT_EMAIL]];
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
    NSString *phoneString =  [TuplitConstants formatPhoneNumber:CUSTOMER_SUPPORT_PNUMBER];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LString(@"TUPLIT") message:phoneString delegate:self cancelButtonTitle:LString(@"CANCEL") otherButtonTitles:LString(@"Call"), nil];
    alertView.tag = 9010;
    [alertView show];
}
-(UserModel*)getcurrentUserDetails
{
    UserModel *user = [TLUserDefaults getCurrentUser];
    return user;
}
-(void)checkButtons
{
    if((buySwitch.isOn || receiveSwitch.isOn || sendMoneySwitch.isOn || dealOfferSwitch.isOn) && !notificationSwitch.isOn)
    {
//        notificationSwitch.on = YES;
        [notificationSwitch showOn:YES];
        
        NSDictionary *queryParams = @{
                                      @"Type"   : NSNonNilString(@"All"),
                                      @"Action" : [NSString stringWithFormat:@"%d",1],
                                      };
        [self callService:queryParams];
        _user_model.PushNotification = [NSString stringWithFormat:@"%d",1];
    }
    else if(!buySwitch.isOn && !receiveSwitch.isOn && !sendMoneySwitch.isOn && !dealOfferSwitch.isOn)
    {
        notificationSwitch.on = NO;
        
        NSDictionary *queryParams = @{
                                      @"Type"   : NSNonNilString(@"All"),
                                      @"Action" : [NSString stringWithFormat:@"%d",0],
                                      };
        [self callService:queryParams];
        _user_model.PushNotification = [NSString stringWithFormat:@"%d",0];
    }
}
#pragma mark - UIAlertViewDelegate Source Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag == 9010) {
        
        if (buttonIndex == 1) {
            
            UIDevice *device = [UIDevice currentDevice];
            
            NSString *unfilteredString = CUSTOMER_SUPPORT_PNUMBER;
            NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
            NSString *resultString = [[unfilteredString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
            
            NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",resultString]];
            
            if ([[device model] isEqualToString:@"iPhone"] ) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            }
        }
    }
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self.navigationController  dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - TLSettingsManager delegate
- (void)settingsManager:(TLSettingsManager *)settingsManager updateSuccessfullWithUserSettings:(NSString *)successmessage
{
    if([settingsManager.serviceType isEqualToString:@"RememberMe"])
    {
        if(_user_model.RememberMe.intValue==1) {
            [TLUserDefaults setIsRememberMe:YES];
        }
        else
        {
            [TLUserDefaults setIsRememberMe:NO];
        }
    }
    [TLUserDefaults setCurrentUser:_user_model];
    [[ProgressHud shared] hide];
}
- (void)settingsManagererror:(TLSettingsManager *)settingsManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *) errorMsg
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)settingsManagerFailed:(TLSettingsManager *)settingsManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}
@end

