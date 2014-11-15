//
//  datUser.h
//  Tuplit
//
//  Created by ev_mac6 on 28/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject


@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *FirstName;
@property (nonatomic, copy) NSString *LastName;
@property (nonatomic, copy) NSString *Gender;
@property (nonatomic, copy) NSString *DOB;
@property (nonatomic, copy) NSString *Email;
@property (nonatomic, copy) NSString *FBId;
@property (nonatomic, copy) NSString *Photo;
@property (nonatomic, copy) NSString *Platform;
@property (nonatomic, copy) NSString *PushNotification;
@property (nonatomic, copy) NSString *RecieveCredit;
@property (nonatomic, copy) NSString *SendCredit;
@property (nonatomic, copy) NSString *BuySomething;
@property (nonatomic, copy) NSString *DealsOffers;
@property (nonatomic, copy) NSString *Sounds;
@property (nonatomic, copy) NSString *Passcode;
@property (nonatomic, copy) NSString *PaymentPreference;
@property (nonatomic, copy) NSString *RememberMe;

@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *ZipCode;
@property (nonatomic, copy) NSString *Country;

@property (nonatomic, copy) NSString *Password;
@property (nonatomic, copy) NSString *PinCode;
@property (nonatomic, copy) NSString *CellNumber;
@property (nonatomic, copy) NSString *AvailableBalance;
@property (nonatomic, copy) NSString *Location;
@property (nonatomic, copy) NSString *GooglePlusId;
@property (nonatomic, copy) NSData  *userImageData;
@property (nonatomic, copy) UIImage *userImage;
@property (nonatomic, copy) NSString *AccessToken;
@property (nonatomic, copy) NSString *IsFriend;

@end
