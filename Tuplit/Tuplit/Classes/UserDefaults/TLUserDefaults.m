//
//  TuplitUserDefaults.m
//  Tuplit
//
//  Created by ev_mac6 on 23/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLUserDefaults.h"
#define UserDefaults   [NSUserDefaults standardUserDefaults]
#define kUser @"User"
#define kGuestUser @"GuestUser"
#define kIsSkipped @"IsSkipped"
#define kIsTutoriakSkipped @"IsTutoriakSkipped"

@implementation TLUserDefaults

+ (void)setCurrentUser:(UserModel*)user_ {
    
    [TLUserDefaults setIsGuestUser:NO];
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:user_];
    [UserDefaults setObject:encodedObject forKey:kUser];
    [UserDefaults synchronize];
}

+ (UserModel*)getCurrentUser {
    NSData *objectToDecode = [UserDefaults valueForKey:kUser];
    UserModel *decodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:objectToDecode];
    return decodedObject;
}

+ (void)setGuestUser:(UserModel*)user_ {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:user_];
    [UserDefaults setObject:encodedObject forKey:kGuestUser];
    [UserDefaults synchronize];
}

+ (UserModel*)getGuestUser {
    NSData *objectToDecode = [UserDefaults valueForKey:kGuestUser];
    UserModel *decodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:objectToDecode];
    return decodedObject;
}

+ (void)setIsGuestUser:(BOOL)isSkipped_ {
    
    [UserDefaults setBool:isSkipped_ forKey:kIsSkipped];
    [UserDefaults synchronize];
}

+ (BOOL)isGuestUser {
    
    return [UserDefaults boolForKey:kIsSkipped];
}

+ (void)setIsTutorialSkipped:(BOOL)isSkipped_ {
    
    [UserDefaults setBool:isSkipped_ forKey:kIsTutoriakSkipped];
    [UserDefaults synchronize];
}

+ (BOOL)isTutorialSkipped {
    
    return [UserDefaults boolForKey:kIsTutoriakSkipped];
}

@end



