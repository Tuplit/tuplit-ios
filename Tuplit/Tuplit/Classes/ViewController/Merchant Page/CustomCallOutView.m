//
//  CustomCallOutViewController.m
//  Tuplit
//
//  Created by ev_mac1 on 20/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "CustomCallOutView.h"
#import "CategoryModel.h"

#define FRAME_HEIGHT 84
#define FRAME_WIDTH 250

@interface CustomCallOutView ()

@end

@implementation CustomCallOutView
@synthesize delegate = _delegate;

-(void)loadView
{
    self.userInteractionEnabled = YES;
    
    self.backgroundColor = [UIColor clearColor];
    callOutImage = getImage(@"CallOut", NO);
    stretchableBackButtonImage = [callOutImage stretchableImageWithLeftCapWidth:0 topCapHeight:10];
    self.image = stretchableBackButtonImage;
    
    annLogoImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"DiscountMap.ong"] imageViewFrame:CGRectMake(5,(FRAME_HEIGHT-40-19)/2,40,40)];
    annLogoImgView.backgroundColor = [UIColor clearColor];
    annLogoImgView.layer.cornerRadius = 40/2;
    annLogoImgView.clipsToBounds = YES;
    [self addSubview:annLogoImgView];
    
    annMerchantNameLbl = [[UILabel alloc ] initWithFrame:CGRectMake(50,5,FRAME_WIDTH-50-3,17)];
    annMerchantNameLbl.textColor = UIColorFromRGB(0x000000);
    annMerchantNameLbl.backgroundColor = [UIColor clearColor];
    annMerchantNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    //    annMerchantNameLbl.userInteractionEnabled = YES;
    annMerchantNameLbl.textAlignment = NSTextAlignmentLeft;
    [self addSubview:annMerchantNameLbl];
    
    annMerchantAddLbl = [[UILabel alloc ] initWithFrame:CGRectMake(50,CGRectGetMaxY(annMerchantNameLbl.frame)+3,110,18)];
    annMerchantAddLbl.textColor = UIColorFromRGB(0x000000);
    annMerchantAddLbl.backgroundColor = [UIColor clearColor];
    annMerchantAddLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    annMerchantAddLbl.numberOfLines=2;
    //    annMerchantNameLbl.userInteractionEnabled = YES;
    //    annMerchantCatgLbl.text = @"category";
    annMerchantAddLbl.textAlignment = NSTextAlignmentLeft;
    [self addSubview:annMerchantAddLbl];

    annMerchantCatgLbl = [[UILabel alloc ] initWithFrame:CGRectMake(50,CGRectGetMaxY(annMerchantNameLbl.frame)+30,130,16)];
    annMerchantCatgLbl.textColor = UIColorFromRGB(0x000000);
    annMerchantCatgLbl.backgroundColor = [UIColor clearColor];
    annMerchantCatgLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    annMerchantCatgLbl.numberOfLines=2;
    //    annMerchantNameLbl.userInteractionEnabled = YES;
    //    annMerchantCatgLbl.text = @"category";
    annMerchantCatgLbl.textAlignment = NSTextAlignmentLeft;
    [self addSubview:annMerchantCatgLbl];
    
    NSLog(@"width = %d",FRAME_WIDTH);
    annDiscountLbl = [[UILabel alloc ] initWithFrame:CGRectMake(FRAME_WIDTH-45,(FRAME_HEIGHT-76)/2,30,20)];
    annDiscountLbl.textColor = UIColorFromRGB(0x000000);
    annDiscountLbl.backgroundColor = [UIColor clearColor];
    //    annDiscountLbl.userInteractionEnabled = YES;
    annDiscountLbl.textAlignment = NSTextAlignmentLeft;
    annDiscountLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    [self addSubview:annDiscountLbl];
    
    UIImage * annDiscountImg = [UIImage imageNamed:@"DiscountMap.png"];
    anndiscountImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(annDiscountLbl.frame)-18,annDiscountLbl.yPosition+2.7,annDiscountImg.size.width, annDiscountImg.size.height)];
    anndiscountImg.backgroundColor = [UIColor clearColor];
    anndiscountImg.image           = annDiscountImg;
    [self addSubview:anndiscountImg];
    
    annDistanceLbl= [[UILabel alloc ] initWithFrame:CGRectMake(178,CGRectGetMaxY(annDiscountLbl.frame),70,20)];
    annDistanceLbl.textColor = UIColorFromRGB(0x000000);
    annDistanceLbl.backgroundColor = [UIColor clearColor];
    //    annDistanceLbl.userInteractionEnabled = YES;
    annDistanceLbl.textAlignment = NSTextAlignmentLeft;
    annDistanceLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    annDistanceLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    annDistanceLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview : annDistanceLbl];
    
    UIImage * customerShoppedImage1 = getImage(@"shop_bag", NO);
    anncustomerShoppedImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(annDiscountLbl.frame)-15,CGRectGetMaxY(annDistanceLbl.frame)+2,customerShoppedImage1.size.width, customerShoppedImage1.size.height)];
    anncustomerShoppedImg.backgroundColor = [UIColor clearColor];
    anncustomerShoppedImg.image           = customerShoppedImage1;
    [self addSubview:anncustomerShoppedImg];
    
    customershoppedLbl = [[UILabel alloc ] initWithFrame:CGRectMake(FRAME_WIDTH-45,CGRectGetMaxY(annDistanceLbl.frame)-3,30,20)];
    customershoppedLbl.textColor = UIColorFromRGB(0x000000);
    customershoppedLbl.backgroundColor = [UIColor clearColor];
    //    annDiscountLbl.userInteractionEnabled = YES;
    customershoppedLbl.textAlignment = NSTextAlignmentLeft;
    customershoppedLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    [self addSubview:customershoppedLbl];
    
    UIImage * annDistanceImg = [UIImage imageNamed:@"MapDistance.png"];
    annDistanceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(annDistanceLbl.frame)-13,CGRectGetMaxY(annDiscountLbl.frame)+5,annDistanceImg.size.width, annDistanceImg.size.height)];
    annDistanceImgView.backgroundColor = [UIColor clearColor];
    annDistanceImgView.image = annDistanceImg;
    [self addSubview:annDistanceImgView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"TutorNextLight.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(calloutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(FRAME_WIDTH-20,(FRAME_HEIGHT-20-15)/2, 20, 20);
    [self  addSubview:button];
}


- (void)setMerchant:(MerchantModel *)merchant
{
    NSArray* priceComponent = [merchant.Category componentsSeparatedByString: @","];
    int i=0;
    
    anndiscountImg.hidden = NO;
    if ([merchant.TagType intValue] == 1) {
        [anndiscountImg setImage:[UIImage imageNamed:@"DiscountMap"]];
    }
    else if([merchant.TagType intValue] == 2)
    {
        [anndiscountImg setImage:[UIImage imageNamed:@"red_tag"]];
    }
    else if([merchant.TagType intValue] == 3)
    {
        [anndiscountImg setImage:[UIImage imageNamed:@"specialIcon"]];
    }
    else
    {
        anndiscountImg.hidden = YES;
    }
    
    annLogoImgView.imageURL = [NSURL URLWithString:merchant.Icon];
    annMerchantNameLbl.text = [merchant.CompanyName stringWithTitleCase];
    annDiscountLbl.text = merchant.DiscountTier;
    annDistanceLbl.text = [TuplitConstants getDistance:[merchant.distance doubleValue]];
    customershoppedLbl.text = merchant.TotalUsersShopped;
    if(customershoppedLbl.text.length==0)
        anncustomerShoppedImg.hidden = YES;
    
    customershoppedLbl.width = [customershoppedLbl.text widthWithFont:customershoppedLbl.font]+1;
    [customershoppedLbl positionAtX:FRAME_WIDTH - customershoppedLbl.size.width - 22];
    [anncustomerShoppedImg positionAtX:FRAME_WIDTH - customershoppedLbl.size.width -anncustomerShoppedImg.frame.size.width- 24];
    
    if (annDistanceLbl.text.length > 0) {
        
        CGRect distanceFrame = annDistanceLbl.frame;
        distanceFrame.size.width = [annDistanceLbl.text widthWithFont:annDistanceLbl.font];
        distanceFrame.origin.x = FRAME_WIDTH - distanceFrame.size.width - 22;
        [annDistanceLbl setFrame:distanceFrame];
        
        CGRect distanceImageViewFrame = annDistanceImgView.frame;
        distanceImageViewFrame.origin.x = CGRectGetMinX(annDistanceLbl.frame) - annDistanceImgView.frame.size.width;
        [annDistanceImgView setFrame:distanceImageViewFrame];
        
        CGRect descriptionFrame = annMerchantNameLbl.frame;
        descriptionFrame.size.width = anndiscountImg.frame.origin.x - 50;
        annMerchantNameLbl.frame = descriptionFrame;
        
        annDistanceLbl.hidden = NO;
        annDistanceImgView.hidden = NO;
    }
    else
    {
        annDistanceLbl.hidden = YES;
        annDistanceImgView.hidden = YES;
    }
    
    annMerchantAddLbl.text = merchant.Address;
    annMerchantAddLbl.width = FRAME_WIDTH-annMerchantAddLbl.xPosition-annDistanceLbl.width- 22-annDistanceImgView.width;
    
    if(priceComponent.count>0&&APP_DELEGATE.catgDict.count>0)
    {
        NSMutableString *categorynames = [NSMutableString new];
        for (NSString *key in priceComponent)
        {
            CategoryModel *catgModel = [APP_DELEGATE.catgDict valueForKey:key];
            if(NSNonNilString(catgModel.CategoryName).length>0)
            {
                //            if(i==0)
                //                [categorynames appendString:NSNonNilString([NSString stringWithFormat:@"%@",catgModel.CategoryName])];
                //            else
                if(categorynames.length>0)
                    [categorynames appendString:@", "];
                [categorynames appendString:NSNonNilString([NSString stringWithFormat:@"%@",catgModel.CategoryName])];
                i++;
            }
        }
        
        annMerchantCatgLbl.width = FRAME_WIDTH-annMerchantCatgLbl.xPosition-annDistanceLbl.width- 22 -annDistanceImgView.width;
        [annMerchantCatgLbl positionAtY:CGRectGetMaxY(annMerchantAddLbl.frame)];
        annMerchantCatgLbl.text = categorynames;
    }
    
}

#pragma mark - User Defined Methods


- (void)calloutButtonClicked
{
    CalloutAnnotation *annotation = self.annotation;
    [_delegate calloutButtonClicked:(NSString *)annotation.title];
}

@end
