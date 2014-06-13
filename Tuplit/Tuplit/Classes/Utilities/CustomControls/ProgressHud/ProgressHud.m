
#import "ProgressHud.h"

@interface ProgressHud ()
- (void)setMessage:(NSString *)message;
@end


static ProgressHud *_shared = nil;

@implementation ProgressHud

#define kHUDMaxWidth        280
#define kHUDPadding         20
#define kMessageMaxWidth    kHUDMaxWidth-(2*kHUDPadding)
//#define kMessageMinWidth    150
#define kMessageMinWidth    0
#define KInnerSpace         10

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        UIView *_transparentView = [[UIView alloc] initWithFrame:frame];
        _transparentView.backgroundColor = [UIColor clearColor];
        _transparentView.alpha = 0.2;
        _transparentView.userInteractionEnabled = YES;
        [self addSubview:_transparentView];
        
        _hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kHUDMaxWidth, 100)];
        _hudView.backgroundColor = [UIColor blackColor];
        _hudView.alpha = 0.6;
        _hudView.layer.cornerRadius = 10.0;
        _hudView.layer.borderColor = [[UIColor blackColor] CGColor];
        _hudView.layer.borderWidth = 1.0;
        [self addSubview:_hudView];
        _hudView.center = _transparentView.center;
        
        _hudContentView = [[UIView alloc] initWithFrame:_hudView.frame];
        [self addSubview:_hudContentView];
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.frame = CGRectMake(0, 0, _spinner.frame.size.width, _spinner.frame.size.height);
        _spinner.center = [_hudView convertPoint:_hudView.center fromView:_transparentView];
        CGRect _frame = _spinner.frame;
        _spinner.backgroundColor = [UIColor clearColor];
        _frame.origin.y = kHUDPadding;
        _spinner.frame = _frame;
        [_hudContentView addSubview:_spinner];
        
        _messageLbl = [[UILabel alloc] init];
        _messageLbl.backgroundColor = [UIColor clearColor];
        _messageLbl.numberOfLines = 0;
        _messageLbl.textAlignment = NSTextAlignmentCenter;
        _messageLbl.font = [UIFont fontWithName:@"Sketch Rockwell" size:15];
        _messageLbl.textColor = [UIColor whiteColor];
        [_hudContentView addSubview:_messageLbl];
        
        progressView = [[UIProgressView alloc] initWithProgressViewStyle: UIProgressViewStyleDefault];
        progressView.frame = CGRectMake(10,CGRectGetMaxY(_spinner.frame)+10,120,20);
        progressView.hidden = YES;
        progressView.progress = 0.00;
        
        progressLabel = [[UILabel alloc] initWithFrame:CGRectMake((150-_spinner.frame.size.width)/2,10,_spinner.frame.size.width,_spinner.frame.size.height)];
        progressLabel.backgroundColor = [UIColor clearColor];
        progressLabel.hidden = YES;
        progressLabel.textColor = [UIColor whiteColor];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        progressLabel.adjustsFontSizeToFitWidth = YES;
        progressLabel.font = [UIFont fontWithName:@"Sketch Rockwell" size:14];
        progressLabel.text = @"0\%";
        
        [_hudContentView addSubview:progressView];
        [_hudContentView addSubview:progressLabel];
        
        //        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [cancelBtn setFrame:CGRectMake(40, CGRectGetMaxY(progressView.frame)+15, 60, 30)];
        //        cancelBtn.layer.cornerRadius = 5;
        //        cancelBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        //        cancelBtn.layer.borderWidth = 1;
        //        cancelBtn.backgroundColor = [UIColor darkGrayColor];
        //        [cancelBtn setTitle:nil forState:UIControlStateNormal];
        //        cancelBtn.titleLabel.font = [UIFont fontWithName:@"MuseoSans-700" size:15];
        //        [cancelBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        //        //[cancelBtn addTarget:self action:@selector(cancelButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        //        cancelBtn.hidden = YES;
        //       [_hudContentView addSubview:cancelBtn];
        
    }
    
    return self;
}


#pragma mark User Defined Methods

+ (id)shared {
    
    float height = [[UIScreen mainScreen] bounds].size.height;
    if (!_shared) _shared = [[ProgressHud alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    return _shared;
}

- (void)cancelButtonEvent {
    
    progressView.progress = 0;
    
    progressLabel.text = @"0\%";
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kCancelUploadNotification object:nil];
}

- (void)showWithMessage:(NSString *)message inTarget:(UIView *)target {
    
    cancelBtn.hidden = YES;
    progressView.hidden = YES;
    progressLabel.hidden = YES;
    _messageLbl.hidden = NO;
    
    
    self.userInteractionEnabled = YES;
    _hudView.userInteractionEnabled = YES;
    _hudContentView.userInteractionEnabled = YES;
    
    [self setMessage:message];
    [target addSubview:self];
    targetView = target;
    
    //    targetView.userInteractionEnabled = NO;
}

- (void)showWithProgressInTarget:(UIView *)target {
    
    [_spinner stopAnimating];
    progressView.progress = 0;
    progressLabel.text = @"0\%";
    progressView.hidden = NO;
    progressLabel.hidden = NO;
    cancelBtn.enabled = YES;
    cancelBtn.alpha = 1;
    cancelBtn.hidden = NO;
    
    self.userInteractionEnabled = YES;
    _hudView.userInteractionEnabled = YES;
    _hudContentView.userInteractionEnabled = YES;
    
    CGRect _hudFrame = _hudView.frame;
    float _lblWidth = 100;
	float _width = _lblWidth + (2*kHUDPadding);
    _hudFrame.size.width = _width;
    _hudFrame.size.height = _spinner.frame.size.height+30+20+10+40;
    _hudView.frame = _hudFrame;
    _hudView.center = CGPointMake(self.center.x, self.center.y-10);
	[_hudView positionAtY:_hudView.yPosition - 20];
    _hudContentView.frame = _hudView.frame;
    
    _spinner.center = [_hudView convertPoint:_hudView.center fromView:self];
    CGRect _frame = _spinner.frame;
    _frame.origin.y = kHUDPadding;
    _spinner.frame = _frame;
    
    [_hudView positionAtX:_hudView.frame.origin.x withHeight:_hudView.frame.size.height - 40];
    
    self.frame = target.frame;
    [target addSubview:self];
    targetView = target;
    targetView.userInteractionEnabled = YES;
    _messageLbl.hidden = YES;
    
}

- (void)updateLabelAndProgress:(NSString *)percentage {
    
    NSLog(@"%f",(float)[percentage intValue]/(float)100);
    
    progressView.progress = (float)[percentage intValue]/(float)100;
    
    progressLabel.text = [[NSString stringWithFormat:@"%.0f",[percentage doubleValue]] stringByAppendingString:@"\%"];
    
    if([percentage intValue] == 100) {
        
        progressLabel.hidden = YES;
        cancelBtn.enabled = NO;
        cancelBtn.alpha = 0.5;
        [_spinner startAnimating];
    }
    else
    {
        progressLabel.hidden = NO;
        [_spinner stopAnimating];
    }
    
}

- (void)setMessage:(NSString *)message {
    
    CGSize _size = [message sizeWithFont:_messageLbl.font constrainedToSize:CGSizeMake(kMessageMaxWidth, 1000) lineBreakMode:_messageLbl.lineBreakMode];
    _messageLbl.text = message;
    CGRect _hudFrame = _hudView.frame;
    float _lblWidth = (_size.width < kMessageMinWidth)? kMessageMinWidth : _size.width;
	float _width = _lblWidth + (2*kHUDPadding);
	if (_width < 70 || message.length == 0) _width = 70;
    _hudFrame.size.width = _width;
	float _height = kHUDPadding + _spinner.frame.size.height + KInnerSpace + _size.height + kHUDPadding;
	if (_height < 70 || message.length == 0) _height = 70;
    _hudFrame.size.height = _height;
    _hudView.frame = _hudFrame;
    _hudView.center = self.center;
	[_hudView positionAtY:_hudView.yPosition - 20];
    _hudContentView.frame = _hudView.frame;
    
    _spinner.center = [_hudView convertPoint:_hudView.center fromView:self];
    CGRect _frame = _spinner.frame;
    _frame.origin.y = kHUDPadding;
    _spinner.frame = _frame;
	
	if (message.length == 0) {
		_spinner.center = [_hudView convertPoint:_hudView.center fromView:self];
	}
    
    _messageLbl.frame = CGRectMake(kHUDPadding, CGRectGetMaxY(_spinner.frame) + KInnerSpace, _lblWidth, _size.height);
    
    [_spinner startAnimating];
}

- (void)hide 
{
    targetView.userInteractionEnabled = YES;
    
    [self removeFromSuperview];
}


@end
