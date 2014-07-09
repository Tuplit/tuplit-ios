//
//  TopUpViewController1.m
//  Tuplit
//
//  Created by ev_mac8 on 13/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TopUpViewController.h"

@interface TopUpViewController()

@end

@implementation TopUpViewController

#pragma mark - View Life Cycle Methods.

-(void) loadView
{
    [super loadView];
    [self.navigationItem setTitle:LString(@"TOP_UP_TITLE")];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] initWithImage:getImage(@"BackArrow", NO) style:UIBarButtonItemStylePlain target:self action:@selector(backToUserProfile)];
    [self.navigationItem setLeftBarButtonItem:navleftButton];
    
    baseViewWidth=self.view.frame.size.width;
    baseViewHeight=self.view.frame.size.height;
    
    UIView *baseView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    baseView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:baseView];
    
    UILabel *selectTopUpLbl=[[UILabel alloc] initWithFrame:CGRectMake(14, 0, baseViewWidth-28, 50)];
    selectTopUpLbl.text=LString(@"SELECT_TOP_UP_AMOUNT");
    selectTopUpLbl.textColor=UIColorFromRGB(0x999999);
    selectTopUpLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    selectTopUpLbl.textAlignment=NSTextAlignmentLeft;
    selectTopUpLbl.backgroundColor=[UIColor clearColor];
    [baseView addSubview:selectTopUpLbl];
    
    tenRupeeTopUpBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [tenRupeeTopUpBtn setFrame:CGRectMake(14, CGRectGetMaxY(selectTopUpLbl.frame),94,45)];
    [tenRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [tenRupeeTopUpBtn setTitle:@"£10" forState:UIControlStateNormal];
    tenRupeeTopUpBtn.tag=1000;
    [tenRupeeTopUpBtn addTarget:self action:@selector(rechargeTenRupeeTopUp:) forControlEvents:UIControlEventTouchUpInside];
    tenRupeeTopUpBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:16.0];
    [tenRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"buttonLightRBg.png"] forState:UIControlStateNormal];
    [baseView addSubview:tenRupeeTopUpBtn];
    
    twentyRupeeTopUpBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [twentyRupeeTopUpBtn setFrame:CGRectMake(CGRectGetMaxX(tenRupeeTopUpBtn.frame) + 5 , CGRectGetMaxY(selectTopUpLbl.frame),94,45)];
    twentyRupeeTopUpBtn.tag=1001;
    [twentyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setTitle:@"£20" forState:UIControlStateNormal];
    twentyRupeeTopUpBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:16.0];
    [twentyRupeeTopUpBtn addTarget:self action:@selector(rechargeTwentyRupeeTopUp:) forControlEvents:UIControlEventTouchUpInside];
    [twentyRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"buttonLightRBg.png"] forState:UIControlStateNormal];
    [baseView addSubview:twentyRupeeTopUpBtn];
    
    fiftyRupeeTopUpBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [fiftyRupeeTopUpBtn setFrame:CGRectMake(CGRectGetMaxX(twentyRupeeTopUpBtn.frame) + 5, CGRectGetMaxY(selectTopUpLbl.frame),94,45)];
    fiftyRupeeTopUpBtn.tag=1002;
    [fiftyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setTitle:@"£50" forState:UIControlStateNormal];
    fiftyRupeeTopUpBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:16.0];
    fiftyRupeeTopUpBtn.backgroundColor=[UIColor clearColor];
    [fiftyRupeeTopUpBtn addTarget:self action:@selector(rechargeFiftyRupeeTopUp:) forControlEvents:UIControlEventTouchUpInside];
    [fiftyRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"buttonLightRBg.png"] forState:UIControlStateNormal];
    [baseView addSubview:fiftyRupeeTopUpBtn];
    
    UILabel *topUpAmountTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(tenRupeeTopUpBtn.frame)+ 25 +5, 193, 40)];
    topUpAmountTitleLbl.text=LString(@"TYPE_OWN_AMOUNT");
    topUpAmountTitleLbl.numberOfLines=0;
    topUpAmountTitleLbl.textAlignment=NSTextAlignmentLeft;
    topUpAmountTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    topUpAmountTitleLbl.textColor=UIColorFromRGB(0x999999);
    topUpAmountTitleLbl.backgroundColor=[UIColor clearColor];
    [baseView addSubview:topUpAmountTitleLbl];
    
    topUpAmountTxt=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topUpAmountTitleLbl.frame)+5, CGRectGetMaxY(tenRupeeTopUpBtn.frame)+25, 94, 45)];
    topUpAmountTxt.placeholder=@"£";
    topUpAmountTxt.textColor=UIColorFromRGB(0x999999);
    topUpAmountTxt.keyboardType=UIKeyboardTypeNumberPad;
    topUpAmountTxt.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    topUpAmountTxt.textAlignment=NSTextAlignmentCenter;
    topUpAmountTxt.backgroundColor=[UIColor clearColor];
    [topUpAmountTxt addTarget:self action:@selector(textFieldAmount:) forControlEvents:UIControlEventEditingDidBegin];
    [topUpAmountTxt setBackground:[UIImage imageNamed:@"textFieldBg.png"]];
    [baseView addSubview:topUpAmountTxt];
    
    UIButton *addCreditCardBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [addCreditCardBtn setFrame:CGRectMake(14, CGRectGetMaxY(topUpAmountTitleLbl.frame)+25,baseViewWidth-28,45)];
    [addCreditCardBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [addCreditCardBtn setTitle:LString(@"CREDIT_TOP_UP") forState:UIControlStateNormal];
    addCreditCardBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    [addCreditCardBtn setBackgroundColor:[UIColor clearColor]];
    [addCreditCardBtn addTarget:self action:@selector(topUpUsingCreditCard:) forControlEvents:UIControlEventTouchUpInside];
    addCreditCardBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [addCreditCardBtn setBackgroundImage:[UIImage imageNamed:@"buttonBg.png"] forState:UIControlStateNormal];
    [baseView addSubview:addCreditCardBtn];
    
    UINavigationBar *navigationBar =[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth,40)];
    UINavigationItem *navigtionItem=[[UINavigationItem alloc] init];
    navigationBar.backgroundColor=[UIColor lightGrayColor];
    UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithTitle:LString(@"DISMISS") style:UIBarButtonItemStyleBordered target:self action:@selector(dismissButtonClicked:)];
    [dismiss setTintColor:UIColorFromRGB(0X009999)];
    navigtionItem.rightBarButtonItem=dismiss;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:navigtionItem, nil];
    [navigationBar setItems:array];
    topUpAmountTxt.inputAccessoryView=navigationBar;
  
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

-(void)backToUserProfile
{
     [self.navigationController popViewControllerAnimated:YES];
}
-(void) rechargeTenRupeeTopUp: (id) sender
{
    amtType=1;
    topUpAmountTxt.placeholder =@"£";
    [tenRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"rotateButtonBg"] forState:UIControlStateNormal];
    [tenRupeeTopUpBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"buttonLightRBg.png"] forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"buttonLightRBg.png"] forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    DISMISS_KEYBOARD;
}
-(void) rechargeTwentyRupeeTopUp: (id) sender
{
    amtType=2;
    topUpAmountTxt.placeholder=@"£";
    [twentyRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"rotateButtonBg"] forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [tenRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"buttonLightRBg.png"] forState:UIControlStateNormal];
    [tenRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"buttonLightRBg.png"] forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
     DISMISS_KEYBOARD;

}
-(void) rechargeFiftyRupeeTopUp : (id) sender
{
    amtType=3;
    topUpAmountTxt.placeholder=@"£";
    [fiftyRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"rotateButtonBg"] forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"buttonLightRBg.png"] forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [tenRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"buttonLightRBg.png"] forState:UIControlStateNormal];
    [tenRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    DISMISS_KEYBOARD;
}
-(void) topUpUsingCreditCard :(id) sender
{
    amount=0;
    if ([tenRupeeTopUpBtn.titleLabel.text isEqualToString:@"£10"] && amtType == 1)
    {
        amount=@"£10";
        [self showAlertMsg: amount];
    }
    else if ([twentyRupeeTopUpBtn.titleLabel.text isEqualToString:@"£20"] && amtType == 2)
    {
        amount=@"£20";
        [self showAlertMsg: amount];
    }
    else if ([fiftyRupeeTopUpBtn.titleLabel.text isEqualToString:@"£50"] && amtType == 3)
    {
        amount=@"£50";
        [self showAlertMsg: amount];
    }
    else
    {
        amount=topUpAmountTxt.text;
        if ([amount isEqualToString:@""] ||  amount.integerValue <= 50)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Failure" message:@"Error, enter above £50 to recharge" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if (amount.integerValue <=5000)
        {
             [self showAlertMsg: amount];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Failure" message:@"Error, enter below £5000 to recharge" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


-(void) showAlertMsg : (NSString*) sender
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat:@"%@ is Recharged",sender] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)dismissButtonClicked:(id)sender
{
    DISMISS_KEYBOARD;
}

-(void) textFieldAmount:(id) sender
{
    amtType=0;
    [tenRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"buttonLightRBg.png"] forState:UIControlStateNormal];
    [tenRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];  
    [twentyRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"buttonLightRBg.png"] forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setBackgroundImage:[UIImage imageNamed:@"buttonLightRBg.png"] forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    
}

@end
