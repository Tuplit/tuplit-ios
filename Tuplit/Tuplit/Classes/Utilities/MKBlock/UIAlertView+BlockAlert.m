//
//  UIAlertView+BlockAlert.m
//  Tuplit
//
//  Created by ev_mac6 on 09/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "UIAlertView+BlockAlert.h"

static void const* const kBtB_onTextOk_AssocKey = &kBtB_onTextOk_AssocKey;
static void const* const kBtB_alertView_AssocKey = &kBtB_alertView_AssocKey;

@interface TextAlertViewDelegate : NSObject <UIAlertViewDelegate,UITextFieldDelegate>
@end

@implementation TextAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    OnTextOkBlock ok = objc_getAssociatedObject(alertView, kBtB_onTextOk_AssocKey);
    objc_setAssociatedObject(alertView, kBtB_onTextOk_AssocKey, nil, OBJC_ASSOCIATION_RETAIN);
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    if(textField == nil) {
        return;
    }
    [alertView resignFirstResponder];
    
    if(buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
    if(ok == nil) {
        return;
    }
    ok(textField.text);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIAlertView* alertView = objc_getAssociatedObject(textField, kBtB_alertView_AssocKey);
    objc_setAssociatedObject(textField, kBtB_alertView_AssocKey, nil, OBJC_ASSOCIATION_RETAIN);
    
    [alertView dismissWithClickedButtonIndex:1 animated:YES];
    [alertView.delegate alertView:alertView clickedButtonAtIndex:1];
    
    return YES;
}

@end


@implementation UIAlertView (BlockAlert)

+ (UIAlertView*) textAlertWithTitle:(NSString*) title
                            message:(NSString*) message
                          onDismiss:(void(^)(NSString *tx))ok
{
    static TextAlertViewDelegate* delegate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegate = [TextAlertViewDelegate new];
    });
    UIAlertView *alertView = [[self alloc] initWithTitle:title
                                                 message:message
                                                delegate:nil
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Done", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = delegate;
    objc_setAssociatedObject(alertView, kBtB_onTextOk_AssocKey, ok, OBJC_ASSOCIATION_RETAIN);
    
    UITextField * textField = [alertView textFieldAtIndex:0];
    textField.delegate = delegate;
    objc_setAssociatedObject(textField, kBtB_alertView_AssocKey, alertView, OBJC_ASSOCIATION_RETAIN);
    
    return alertView;
}

@end
