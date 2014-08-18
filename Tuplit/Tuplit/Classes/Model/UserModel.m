//
//  datUser.m
//  Tuplit
//
//  Created by ev_mac6 on 28/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)encodeWithCoder:(NSCoder *)encoder {
	
    [encoder encodeObject:self.UserId forKey:@"UserId"];
    [encoder encodeObject:self.UserName forKey:@"UserName"];
    [encoder encodeObject:self.FirstName forKey:@"FirstName"];
    [encoder encodeObject:self.LastName forKey:@"LastName"];
	[encoder encodeObject:self.Email forKey:@"Email"];
	[encoder encodeObject:self.Photo forKey:@"userImageUrl"];
    [encoder encodeObject:self.FBId forKey:@"FBId"];
    [encoder encodeObject:self.userImage forKey:@"userImage"];
    [encoder encodeObject:self.userImageData forKey:@"userImageData"];
    [encoder encodeObject:self.ZipCode forKey:@"ZipCode"];
    [encoder encodeObject:self.Country forKey:@"Country"];
    [encoder encodeObject:self.Platform forKey:@"Platform"];
    [encoder encodeObject:self.PushNotification forKey:@"PushNotification"];
    [encoder encodeObject:self.SendCredit forKey:@"SendCredit"];
    [encoder encodeObject:self.RecieveCredit forKey:@"RecieveCredit"];
    [encoder encodeObject:self.BuySomething forKey:@"BuySomething"];
    [encoder encodeObject:self.DealsOffers forKey:@"DealsOffers"];
    [encoder encodeObject:self.Password forKey:@"Password"];
    [encoder encodeObject:self.GooglePlusId forKey:@"GooglePlusId"];
    [encoder encodeObject:self.PinCode forKey:@"PinCode"];
    [encoder encodeObject:self.CellNumber forKey:@"CellNumber"];
    [encoder encodeObject:self.Location forKey:@"Location"];
    [encoder encodeObject:self.AvailableBalance forKey:@"AvailableBalance"];
    [encoder encodeObject:self.Passcode forKey:@"Passcode"];
    [encoder encodeObject:self.PaymentPreference forKey:@"PaymentPreference"];
    [encoder encodeObject:self.RememberMe forKey:@"RememberMe"];
    [encoder encodeObject:self.Sounds forKey:@"Sounds"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
	
    if ((self = [super init])) {
        self.UserId = [decoder decodeObjectForKey:@"UserId"];
        self.UserName = [decoder decodeObjectForKey:@"UserName"];
        self.FirstName = [decoder decodeObjectForKey:@"FirstName"];
        self.LastName = [decoder decodeObjectForKey:@"LastName"];
		self.Email = [decoder decodeObjectForKey:@"Email"];
        self.Photo = [decoder decodeObjectForKey:@"userImageUrl"];
		self.FBId = [decoder decodeObjectForKey:@"FBId"];
        self.userImage = [decoder decodeObjectForKey:@"userImage"];
        self.userImageData = [decoder decodeObjectForKey:@"userImageData"];
        self.ZipCode = [decoder decodeObjectForKey:@"ZipCode"];
        self.Country = [decoder decodeObjectForKey:@"Country"];
        self.Platform = [decoder decodeObjectForKey:@"Platform"];
        self.PushNotification = [decoder decodeObjectForKey:@"PushNotification"];
        self.SendCredit = [decoder decodeObjectForKey:@"SendCredit"];
        self.RecieveCredit = [decoder decodeObjectForKey:@"RecieveCredit"];
        self.BuySomething = [decoder decodeObjectForKey:@"BuySomething"];
        self.DealsOffers = [decoder decodeObjectForKey:@"DealsOffers"];
        self.Password = [decoder decodeObjectForKey:@"Password"];
        self.GooglePlusId = [decoder decodeObjectForKey:@"GooglePlusId"];
        self.PinCode = [decoder decodeObjectForKey:@"PinCode"];
        self.CellNumber = [decoder decodeObjectForKey:@"CellNumber"];
        self.Location = [decoder decodeObjectForKey:@"Location"];
        self.AvailableBalance = [decoder decodeObjectForKey:@"AvailableBalance"];
        self.Passcode = [decoder decodeObjectForKey:@"Passcode"];
        self.PaymentPreference = [decoder decodeObjectForKey:@"PaymentPreference"];
        self.RememberMe = [decoder decodeObjectForKey:@"RememberMe"];
        self.Sounds = [decoder decodeObjectForKey:@"Sounds"];
        
    }
    return self;
}

@end
