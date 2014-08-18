//
//  PinCodeViewController.m
//  Tuplit
//
//  Created by ev_mac8 on 27/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLPinCodeViewController.h"

@interface TLPinCodeViewController ()

@end

@implementation TLPinCodeViewController
@synthesize navigationTitle,isConformPinCode,pinCodeValue;

#pragma mark - View Life Cycle Methods.

-(void)dealloc
{
    _delegate = nil;
}
-(void) loadView
{
    [super loadView];
    
    [self.navigationItem setTitle:navigationTitle];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
    [navleftButton buttonWithIcon:getImage(@"close", NO) target:self action:@selector(closeAction:) isLeft:NO];
    [self.navigationItem setLeftBarButtonItem:navleftButton];
    
    normalNumberArray = [NSMutableArray arrayWithObjects:@"1_n.png", @"2_n.png", @"3_n.png", @"4_n.png", @"5_n.png", @"6_n.png",@"7_n.png", @"8_n.png", @"9_n.png", @"0_n.png", nil];
    selectedNumberArray = [NSMutableArray arrayWithObjects:@"1.png", @"2.png", @"3.png", @"4.png", @"5.png", @"6.png", @"7.png", @"8.png", @"9.png", @"0.png", nil];
    
    baseViewWidth= self.view.frame.size.width;
    baseViewHeight= self.view.frame.size.height;
    
    UIView *baseView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    baseView.backgroundColor=[UIColor colorWithPatternImage:getImage(@"bg.png", NO)];
    [self.view addSubview:baseView];
    
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    scrollView.userInteractionEnabled=YES;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        scrollView.delaysContentTouches = NO;
    [baseView addSubview:scrollView];
    
    codeSelectorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, baseView.frame.size.width, 120)];
    codeSelectorView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:codeSelectorView];
    
    xposition = 72;
    for (int i = 0; i<4; i++) {
        
        UIImageView *codeSelectorImgView = [[UIImageView alloc]initWithImage:getImage(@"dot", NO)];
        codeSelectorImgView.frame = CGRectMake(xposition + 25, 60, 13, 13);
        codeSelectorImgView.tag = i + 1;
        codeSelectorImgView.backgroundColor=[UIColor clearColor];
        [codeSelectorView addSubview:codeSelectorImgView];
        
        xposition = CGRectGetMaxX(codeSelectorImgView.frame);
    }
    
    numberPadView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(codeSelectorView.frame), baseView.frame.size.width, 382)];
    numberPadView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:numberPadView];
    
    xposition = 13;
    yposition = 0;
    int row = 1;
    
    for (int j = 1; j <= 10; j++) {
        
        float ypos = yposition;
        
        UIButton *numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        numberBtn.frame = CGRectMake(xposition + 15, ypos + 10, 76, 76);
        numberBtn.tag = j + 110;
        [numberBtn addTarget:self action:@selector(numberPadAction:) forControlEvents:UIControlEventTouchUpInside];
        [numberBtn setImage:getImage([normalNumberArray objectAtIndex:j-1], NO) forState:UIControlStateNormal];
        [numberBtn setImage:getImage([selectedNumberArray objectAtIndex:j-1],NO) forState:UIControlStateSelected];
        [numberBtn setImage:getImage([selectedNumberArray objectAtIndex:j-1],NO) forState:UIControlStateHighlighted];
       
        numberBtn.backgroundColor=[UIColor clearColor];
        [numberPadView addSubview:numberBtn];
        
        if (j < row * 3) {
            xposition = CGRectGetMaxX(numberBtn.frame) + 1.5;
        }
        else{
            if (j == 9) xposition = 107;
            else xposition = 13;
            yposition = CGRectGetMaxY(numberBtn.frame) + 3;
            row++;
        }
    }
    
    if (baseViewHeight <= 480) 
    {
        scrollView.contentSize = CGSizeMake(baseView.frame.size.width, CGRectGetMaxY(numberPadView.frame) + 30);
    }
    pinCode=@"";
    count=0;
    clickCount=0;
    isConformPinCode = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
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

-(void) closeAction : (id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) numberPadAction : (UIButton *) button
{
   
//        UIButton *clickedBtn = (UIButton *)[numberPadView viewWithTag:button.tag];
    
        int value;
        
        if (button.tag == 120) 
        {
            value = button.tag - button.tag; 
        }
        else
        {
            value = button.tag - 110;
        }
        
//        [clickedBtn setImage:getImage([selectedNumberArray objectAtIndex:button.tag - 111], NO) forState:UIControlStateNormal];
        pinCode = [pinCode stringByAppendingString:[NSString stringWithFormat:@"%d", value]];
        count++;
        [self fillCodeCircles:count];
    
    if (pinCode.length == 4)
    {
        if(!isPinVerfied)
        {
            NETWORK_TEST_PROCEDURE
            
            [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
            
            TLVerifyPinManager *setPinCode = [[TLVerifyPinManager alloc]init];
            setPinCode.delegate = self;
            [setPinCode verifyPinCode:pinCode];
        }
        else
        {
            if(!isConformPinCode)
            {
                self.pinCodeValue = pinCode;
                [self.navigationItem setTitle:LString(@"CONFORM_PIN_CODE")];
                [self resetToClear:YES];
            }
            else
            {
                if([pinCode isEqualToString:self.pinCodeValue])
                {
                    NETWORK_TEST_PROCEDURE
                    
                    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
                    
                    TLSetPinManager *setPinCode = [[TLSetPinManager alloc]init];
                    setPinCode.delegate = self;
                    [setPinCode updatePinCode:pinCode];
                }
                else
                {
                    [UIAlertView alertViewWithMessage:LString(@"PIN_CODE_MISMATCH")];
                    [self resetToClear:YES];
                }
            }
        }
    }
    
}

-(void)fillCodeCircles :(int)tag
{
    UIImageView *selectorImage = (UIImageView *)[codeSelectorView viewWithTag:tag];
    [selectorImage setImage:getImage(@"dot_s", NO)];
}

-(void)unfillCodeCircles
{
    for (int i =1; i <= 4; i++) 
    {
        UIImageView *selectorImage = (UIImageView *)[codeSelectorView viewWithTag:i];
        [selectorImage setImage:getImage(@"dot", NO)];
    }
}

-(void)resetToClear:(BOOL)isConformPin
{
    pinCode=@"";
    clickCount = 0;
    for (int i = 1; i <= 10; i++)
    {
        UIButton *buttons = (UIButton *)[numberPadView viewWithTag:i + 110];
        [buttons setImage:getImage([normalNumberArray objectAtIndex:i-1], NO) forState:UIControlStateNormal];
    }
    count = 0;
    [self unfillCodeCircles];
    isConformPinCode = isConformPin;
}

#pragma mark - TLSetPinManager Delegate Methods

- (void)setPinManagerSuccess:(TLSetPinManager *)pinManager updateSuccessfullWithUser:(NSString *)notification
{
    [[ProgressHud shared] hide];
    [self closeAction:nil];
    [UIAlertView alertViewWithMessage:LString(@"PINCODE_UPDATED")];
}
- (void)setPinManager:(TLSetPinManager *)pinManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *) errorMsg
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
     [self closeAction:nil];
}
- (void)setPinManagerFailed:(TLSetPinManager *)pinManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
    [self closeAction:nil];
}

#pragma mark - TLVerifyPinManager Delegate Methods

- (void)verifyPinManagerSuccessWithValue:(NSString*)pinType Withnotification:(NSString *)notification
{
    if(!isPinVerfied)
    {
        if(pinType.intValue)
        {
            isPinVerfied = YES;
            if(self.isverifyPin)
            {
                if(_delegate)
                    [_delegate pincodeVerified];
                [self closeAction:nil];
                self.isverifyPin = NO;
            }
            else
            {
                [self.navigationItem setTitle:LString(@"SET_NEW_PIN_CODE")];
                [self resetToClear:NO];
                [[ProgressHud shared] hide];
            }
        }
        else
        {
            [UIAlertView alertViewWithMessage:notification];
            [self resetToClear:NO];
            [[ProgressHud shared] hide];
        }
        
        
    }
    else
    {
        
    }
}
- (void)verifyPinManager:(TLVerifyPinManager *)pinManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *) errorMsg
{
    [UIAlertView alertViewWithMessage:errorMsg];
    [[ProgressHud shared] hide];
    [self closeAction:nil];
    self.isverifyPin = NO;
}
- (void)verifyPinManagerFailed:(TLVerifyPinManager *)pinManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
    [self closeAction:nil];
    self.isverifyPin = NO;
}

@end
