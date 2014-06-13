

#import <UIKit/UIKit.h>

@interface ProgressHud : UIView {
    
    UIView *_hudView;
    UILabel *_messageLbl;
    UIView *_hudContentView;
    UIActivityIndicatorView *_spinner;
    BOOL _showing;
    UIView *targetView;
    UIProgressView *progressView;
    UILabel *progressLabel;
    UIButton *cancelBtn;
}

+ (id)shared;
- (void)showWithMessage:(NSString *)message inTarget:(UIView *)target;
- (void)showWithProgressInTarget:(UIView *)target;
- (void)updateLabelAndProgress:(NSString *)percentage;
- (void)hide;

@end
