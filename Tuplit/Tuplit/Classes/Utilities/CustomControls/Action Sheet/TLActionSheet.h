//
//  TLActionSheet.h
//  Tuplit
//
//  Created by ev_mac11 on 31/10/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLActionSheet;
@protocol TLActionSheetDelegate <NSObject>
@optional
-(void)doneAction;
-(void)cancelAction;
@end

@interface TLActionSheet : UIView

@property (nonatomic,strong)UIDatePicker *datepicker;
@property(nonatomic, unsafe_unretained) id <TLActionSheetDelegate> delegate;

@end
