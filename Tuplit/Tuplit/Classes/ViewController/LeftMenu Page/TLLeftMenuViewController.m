//
//  TLLeftMenuViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 25/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLLeftMenuViewController.h"
#import "TLWelcomeViewController.h"
#import "TLUserDefaults.h"
#import "UserModel.h"
#import "MenuModel.h"
#import "FriendsModel.h"

#define FRIENDS_CELL_HEIGHT 38
#define MENU_CELL_HEIGHT 55
#define EMPTY_SPACE_HEIGHT 50


@implementation TLLeftMenuViewController


#pragma mark - View life cycle methods.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MenuModel *menuModel1 = [[MenuModel alloc] init];
    [menuModel1 setImage:@"MenuHome"];
    [menuModel1 setTitle:LString(@"HOME")];
    
    MenuModel *menuModel2 = [[MenuModel alloc] init];
    [menuModel2 setImage:@"MenuCart"];
    [menuModel2 setTitle:LString(@"CART")];
    
    MenuModel *menuModel3 = [[MenuModel alloc] init];
    [menuModel3 setImage:@"MenuFriends"];
    [menuModel3 setTitle:LString(@"FRIENDS")];
    
    MenuModel *menuModel4 = [[MenuModel alloc] init];
    [menuModel4 setImage:@"MenuSettings"];
    [menuModel4 setTitle:LString(@"SETTINGS")];
    
    FriendsModel *friendModel1 = [[FriendsModel alloc] init];
    [friendModel1 setImage:@"DefaultUser"];
    [friendModel1 setFirstName:@"John"];
    [friendModel1 setLastName:@"Doe"];
    [friendModel1 setMerchantName:@"Burger King NY"];
    
    FriendsModel *friendModel2 = [[FriendsModel alloc] init];
    [friendModel2 setImage:@"DefaultUser"];
    [friendModel2 setFirstName:@"Amanda"];
    [friendModel2 setLastName:@"Kelly"];
    [friendModel2 setMerchantName:@"Home Depot"];
    
    FriendsModel *friendModel3 = [[FriendsModel alloc] init];
    [friendModel3 setImage:@"DefaultUser"];
    [friendModel3 setFirstName:@"Rom"];
    [friendModel3 setLastName:@"Deezer"];
    [friendModel3 setMerchantName:@"Warner Bros. Shop"];
    
    menuArray = [NSArray arrayWithObjects:menuModel1,menuModel2,menuModel3,friendModel1,friendModel2,friendModel3,@"",menuModel4,nil];
    
    float tableHeaderWidth = 220;
    
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableHeaderWidth, 100)];
    [tableHeader setBackgroundColor:[UIColor clearColor]];
    
    profileImageView = [[EGOImageView alloc] initWithPlaceholderImage:getImage(@"DefaultUser", NO) imageViewFrame:CGRectMake((tableHeaderWidth - 65)/2, 50, 60, 60)];
    profileImageView.backgroundColor = [UIColor whiteColor];
    profileImageView.layer.cornerRadius = 60/2;
    
    profileImageView.clipsToBounds = YES;
    [tableHeader addSubview:profileImageView];
    
    userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,50 + 60 + 3, tableHeaderWidth, 25)];
    userNameLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    userNameLbl.textAlignment = NSTextAlignmentCenter;
    userNameLbl.textColor = [UIColor whiteColor];
    userNameLbl.backgroundColor = [UIColor clearColor];
    userNameLbl.adjustsFontSizeToFitWidth = YES;
    
    [tableHeader addSubview:userNameLbl];
    
    creditBalanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(userNameLbl.frame), tableHeaderWidth, 15)];
    creditBalanceLbl.textAlignment = NSTextAlignmentCenter;
    creditBalanceLbl.textColor = [UIColor whiteColor];
    creditBalanceLbl.backgroundColor = [UIColor clearColor];
    creditBalanceLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
    
    [tableHeader addSubview:creditBalanceLbl];
    
    [tableHeader setFrame:CGRectMake(0, 0, tableHeaderWidth, CGRectGetMaxY(creditBalanceLbl.frame) + 20)];
    self.tableView.tableHeaderView = tableHeader;
    
    numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    
    if ([TLUserDefaults isGuestUser]) {
        
        profileImageView.imageURL = [NSURL URLWithString:@""];
        userNameLbl.text = @"Guest user";
        creditBalanceLbl.text = @"$0.00";
    }
    else
    {
        profileImageView.imageURL = [NSURL URLWithString:[TLUserDefaults getCurrentUser].userImageUrl];
        userNameLbl.text = [NSString stringWithFormat:@"%@ %@",[TLUserDefaults getCurrentUser].FirstName,[TLUserDefaults getCurrentUser].LastName];
        creditBalanceLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[[TLUserDefaults getCurrentUser].AvailableBalance doubleValue]]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

#pragma mark - Table view data source methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [menuArray objectAtIndex:indexPath.row];
    
    if ([object isKindOfClass:[FriendsModel class]])
    {
        return FRIENDS_CELL_HEIGHT;
    }
    else if ([object isKindOfClass:[FriendsModel class]])
    {
        return MENU_CELL_HEIGHT;
    }
    else
    {
        return EMPTY_SPACE_HEIGHT;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return menuArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier[] = {@"Menu",@"Friends",@"EMPTY_SPACE"};
    
    id object = [menuArray objectAtIndex:indexPath.row];
    
    int cellId = 0;
    
    if([object isKindOfClass:[MenuModel class]])
        cellId = 0;
    else if([object isKindOfClass:[FriendsModel class]])
        cellId = 1;
    else
        cellId = 2;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier[cellId]];
    
    if (cellId == 0) {
        
        if(cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier[cellId]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-44/2, (MENU_CELL_HEIGHT - 44)/2, 44, 44)];
            iconImageView.tag = 1000;
            iconImageView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:iconImageView];
            
            UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 15,  (MENU_CELL_HEIGHT - 44)/2, 150, 44)];
            labelName.tag = 1001;
            labelName.backgroundColor = [UIColor clearColor];
            labelName.textColor = [UIColor whiteColor];
            labelName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
            [cell.contentView addSubview:labelName];
        }
        
    }
    else if (cellId == 1) {
        
        if(cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier[cellId]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            EGOImageView *iconImageView = [[EGOImageView alloc] initWithPlaceholderImage:getImage(@"DefaultUser",NO) imageViewFrame:CGRectMake(15,(FRIENDS_CELL_HEIGHT - 20)/2, 20, 20)];
            iconImageView.tag = 2000;
            iconImageView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:iconImageView];
            
            UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(35 + 10, 0, 150, FRIENDS_CELL_HEIGHT)];
            labelName.tag = 2001;
            labelName.backgroundColor = [UIColor clearColor];
            labelName.textColor = [UIColor whiteColor];
            labelName.numberOfLines = 3;
            labelName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
            [cell.contentView addSubview:labelName];
        }
    }
    
    else if (cellId == 2) {
        
        if(cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier[cellId]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
    }
    
    if (cellId == 0) {
        
        MenuModel *menuModel = (MenuModel*) object;
        
        UIImageView *iconView = (UIImageView*)[cell.contentView viewWithTag:1000];
        UILabel *labelName = (UILabel*)[cell.contentView viewWithTag:1001];
        
        iconView.image = getImage(menuModel.image, NO);
        labelName.text = menuModel.title;
    }
    else if (cellId == 1)
    {
        FriendsModel *friendModel = (FriendsModel*)object;
        
        EGOImageView *iconView = (EGOImageView*)[cell.contentView viewWithTag:2000];
        UILabel *labelName = (UILabel*)[cell.contentView viewWithTag:2001];
        
        [iconView setImageURL:[NSURL URLWithString:friendModel.image]];
    
        NSString *userName = [NSString stringWithFormat:@"%@ %@",friendModel.firstName,friendModel.lastName];
        NSString *staticText = @"shopped at";
        
        NSString *string = [NSString stringWithFormat:@"%@ %@ %@",userName,staticText,friendModel.merchantName];
        NSMutableAttributedString *aString=[[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10]}];
        [aString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFFFFF) range:NSMakeRange(0, userName.length)];
        [aString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xb8e5e2) range:NSMakeRange(userName.length + 1, staticText.length)];
        [aString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFFFFF) range:NSMakeRange(userName.length + staticText.length + 2, friendModel.merchantName.length)];
    
        labelName.attributedText = aString;
    }
    
    return cell;
    
}

#pragma mark - Table view delegate source methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
     
        TLMerchantsViewController *merchantVC = [[TLMerchantsViewController alloc] init];
        UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:merchantVC];
        [slideNavigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
        [slideNavigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        
    }
    else if(indexPath.row == 1) {
        
        TLCartViewController *cartVC = [[TLCartViewController alloc] initWithNibName:@"TLCartViewController" bundle:nil];
        UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:cartVC];
        [slideNavigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
        [slideNavigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        
    }
    else if(indexPath.row == 2) {
        
        TLFriendsViewController *friendsVC = [[TLFriendsViewController alloc] initWithNibName:@"TLFriendsViewController" bundle:nil];
        UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:friendsVC];
        [slideNavigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
        [slideNavigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        
    }
    else if(indexPath.row == menuArray.count - 1) {
        
        TLSettingsViewController *settingsVC = [[TLSettingsViewController alloc] initWithNibName:@"TLSettingsViewController" bundle:nil];
        UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
        [slideNavigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
        [slideNavigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
    }
    
    [APP_DELEGATE.slideMenuController hideMenuViewController];
}

@end

