//
//  AddCommentViewController.m
//  Tuplit
//
//  Created by ev_mac8 on 21/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLAddCommentViewController.h"

@interface TLAddCommentViewController ()
{
    UITextView *messageTxtView;
}

@end

@implementation TLAddCommentViewController
@synthesize merchantID;

#pragma mark - View Life Cycle Methods.

-(void) loadView
{
    [super loadView];
    
    [self.navigationItem setTitle:LString(@"ADD_COMMENT")];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
    [navleftButton buttonWithIcon:getImage(@"BackArrow", NO) target:self action:@selector(backToUserProfile) isLeft:NO];
    [self.navigationItem setLeftBarButtonItem:navleftButton];
    
    baseViewWidth = self.view.frame.size.width;
    baseViewHeight=self.view.frame.size.height;
    
    UIView *baseView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    baseView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:baseView]; 
    
    messageTxtView=[[UITextView alloc] initWithFrame:CGRectMake(15,20,290,140)];
    messageTxtView.text=LString(@"MESSAGE_OPTIONAL");
    messageTxtView.font=[UIFont fontWithName:@"HelveticaNeue" size:16.0];
    messageTxtView.textColor=UIColorFromRGB(0xc0c0c0);
    messageTxtView.textAlignment=NSTextAlignmentLeft;
    messageTxtView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"commentsBg.png"]];
    messageTxtView.delegate=self;
    [baseView addSubview:messageTxtView];
    
    facebookSwitch=[[CustomSwitch alloc] initWithFrame:CGRectMake(35,CGRectGetMaxY(messageTxtView.frame) + 20,102, 35)];
    [facebookSwitch addTarget:self action:@selector(switchToFacebook:) forControlEvents:UIControlEventValueChanged];
    facebookSwitch.isRounded=NO;
    facebookSwitch.onImage=getImage(@"facebookOn", NO);
    facebookSwitch.offImage=getImage(@"facebookOff", NO);
    facebookSwitch.onColor=[UIColor colorWithPatternImage:getImage(@"facebookOn", NO)];
    facebookSwitch.offColor=[UIColor colorWithPatternImage:getImage(@"facebookOff", NO)];
    facebookSwitch.backgroundColor=[UIColor clearColor];
    [baseView addSubview:facebookSwitch];
    
    twitterSwitch=[[CustomSwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(facebookSwitch.frame) + 45,CGRectGetMaxY(messageTxtView.frame) + 20,102, 35)];
    [twitterSwitch addTarget:self action:@selector(switchToTwitter:) forControlEvents:UIControlEventValueChanged];
    twitterSwitch.isRounded=NO;
    twitterSwitch.onImage=getImage(@"twitterOn", NO);
    twitterSwitch.offImage=getImage(@"twitterOff", NO);
    twitterSwitch.onColor=[UIColor colorWithPatternImage:getImage(@"twitterOn", NO)];
    twitterSwitch.offColor=[UIColor colorWithPatternImage:getImage(@"twitterOff", NO)];
    twitterSwitch.backgroundColor=[UIColor clearColor];
    [baseView addSubview:twitterSwitch];

    UIButton *addCommentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addCommentBtn.frame=CGRectMake(15, CGRectGetMaxY(facebookSwitch.frame) + 20,290,45);
    [addCommentBtn setTitle:LString(@"ADD_COMMENT") forState:UIControlStateNormal];
    [addCommentBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [addCommentBtn setBackgroundImage:[UIImage imageNamed:@"buttonBg.png"] forState:UIControlStateNormal];
    [addCommentBtn setBackgroundColor:[UIColor clearColor]];
    addCommentBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    [addCommentBtn addTarget:self action:@selector(addCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:addCommentBtn];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User Defined Methods.

-(void) backToUserProfile
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchToFacebook:(CustomSwitch *)sender 
{
    NSLog(@"Changed value to: %@", sender.on ? @"ON" : @"OFF");
}

- (void)switchToTwitter:(CustomSwitch *)sender 
{
    NSLog(@"Changed value to: %@", sender.on ? @"ON" : @"OFF");
}
-(void) addCommentAction :(id) sender
{
    NSLog(@"message = %@",messageTxtView.text);
    
    NSDictionary *queryParams = @{
                                  @"MerchantId": NSNonNilString(merchantID),
                                  @"CommentText": NSNonNilString(messageTxtView.text),
                                  };
    NETWORK_TEST_PROCEDURE
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
   
    TLAddCommentManager *addCommentManager = [[TLAddCommentManager alloc]init];
    addCommentManager.delegate = self;
    [addCommentManager addComment:queryParams];
}

#pragma mark - Text View Delegates

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:LString(@"MESSAGE_OPTIONAL")])
    {
        textView.text = @"";
        textView.textColor = UIColorFromRGB(0x000000);
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text =LString(@"MESSAGE_OPTIONAL");
        textView.textColor = UIColorFromRGB(0xc0c0c0);
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text 
{    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }    
    return YES;
}

#pragma mark - commentAddManager Delegates
- (void)commentAddManagerSuccess:(TLAddCommentManager *)loginManager
{
     [self backToUserProfile];
     [[ProgressHud shared] hide];
}
- (void)commentAddManager:(TLAddCommentManager *)loginManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [self backToUserProfile];
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)commentAddManagerFailed:(TLAddCommentManager *)loginManager
{
    [self backToUserProfile];
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
   
}
@end
