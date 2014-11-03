//
//  Global.h
//  Tuplit
//
//  Created by ev_mac6 on 19/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface Global : NSObject
@property (nonatomic, retain)NSString *aboutContent;
@property (nonatomic, retain)NSString *privacyContent;
@property (nonatomic, retain)NSString *termsContent;
@property (nonatomic, retain)NSString *legalContent;
@property (nonatomic, retain)NSString *faqUrl;
@property (nonatomic, retain)NSArray *welcomeScreenImages;
@property (nonatomic, retain)NSArray *tutorialScreenImages;
@property (nonatomic, retain)UserModel *user;
@property (nonatomic, retain)NSDictionary *discoutTiers;
+ (Global *)instance;

@end
