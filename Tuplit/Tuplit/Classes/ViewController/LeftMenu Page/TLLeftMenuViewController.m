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
#import "TLOrderDetailViewController.h"

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
    menuArray = [[NSMutableArray alloc]init];
    
    MenuModel *menuModel1 = [[MenuModel alloc] init];
    [menuModel1 setImage:@"MenuHome"];
    [menuModel1 setTitle:LString(@"HOME")];
    [menuArray addObject:menuModel1];
    
    MenuModel *menuModel2 = [[MenuModel alloc] init];
    [menuModel2 setImage:@"MenuCart"];
    [menuModel2 setTitle:LString(@"CART")];
    [menuArray addObject:menuModel2];
    
    MenuModel *menuModel3 = [[MenuModel alloc] init];
    [menuModel3 setImage:@"MenuFavourites"];
    [menuModel3 setTitle:LString(@"FAVORITES")];
    [menuArray addObject:menuModel3];
    
    MenuModel *menuModel4 = [[MenuModel alloc] init];
    [menuModel4 setImage:@"MenuFriends"];
    [menuModel4 setTitle:LString(@"FRIENDS")];
    [menuArray addObject:menuModel4];
    int i =0;
    for(FriendsModel *order in APP_DELEGATE.friendsRecentOrders)
    {
        if(i==3)
            break;
        [menuArray addObject:order];
        i++;
        
    }
    
    MenuModel *menuModel5 = [[MenuModel alloc] init];
    [menuModel5 setImage:@"MenuSettings"];
    [menuModel5 setTitle:LString(@"SETTINGS")];
    [menuArray addObject:menuModel5];
    
    float tableHeaderWidth = 220;
    
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableHeaderWidth, 100)];
    [tableHeader setBackgroundColor:[UIColor clearColor]];
    
    profileImageView = [[EGOImageView alloc] initWithPlaceholderImage:getImage(@"DefaultUser", NO) imageViewFrame:CGRectMake((tableHeaderWidth - 65)/2, 34, 60, 60)];
    profileImageView.backgroundColor = [UIColor whiteColor];
    profileImageView.layer.cornerRadius = 60/2;
    profileImageView.userInteractionEnabled = YES;
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UITapGestureRecognizer *profileGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMyProfileVc:)];
    [profileImageView addGestureRecognizer:profileGesture];
    profileImageView.clipsToBounds = YES;
    [tableHeader addSubview:profileImageView];
    
    userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,34 + 60 + 3, tableHeaderWidth, 25)];
    userNameLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    userNameLbl.textAlignment = NSTextAlignmentCenter;
    userNameLbl.textColor = [UIColor whiteColor];
    userNameLbl.backgroundColor = [UIColor clearColor];
    userNameLbl.adjustsFontSizeToFitWidth = YES;
    userNameLbl.userInteractionEnabled = YES;
    UITapGestureRecognizer *profileGesture1 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMyProfileVc:)];
    [userNameLbl addGestureRecognizer:profileGesture1];
    
    [tableHeader addSubview:userNameLbl];
    
    creditBalanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(userNameLbl.frame), tableHeaderWidth, 15)];
    creditBalanceLbl.textAlignment = NSTextAlignmentCenter;
    creditBalanceLbl.textColor = [UIColor whiteColor];
    creditBalanceLbl.backgroundColor = [UIColor clearColor];
    creditBalanceLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
    
    [tableHeader addSubview:creditBalanceLbl];
    
    [tableHeader setFrame:CGRectMake(0, 0, tableHeaderWidth, CGRectGetMaxY(creditBalanceLbl.frame) + 20)];
    self.tableView.tableHeaderView = tableHeader;
    
    numberFormatter = [TuplitConstants getCurrencyFormat];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserData) name:kUpdateUserData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFriendsOrder) name:kUpdateRecentOrders object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFriendsActivity) name:kUpdateFriendsActivity object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    
    [self updateUserData];
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
    friendProfileVC = nil;
    merchantVC = nil;
    cartVC = nil;
    favoriteVC = nil;
    friendsVC = nil;
    settingsVC = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - UserDefined methods

-(void)updateFriendsOrder
{
    [menuArray removeAllObjects];
    
    MenuModel *menuModel1 = [[MenuModel alloc] init];
    [menuModel1 setImage:@"MenuHome"];
    [menuModel1 setTitle:LString(@"HOME")];
    [menuArray addObject:menuModel1];
    
    MenuModel *menuModel2 = [[MenuModel alloc] init];
    [menuModel2 setImage:@"MenuCart"];
    [menuModel2 setTitle:LString(@"CART")];
    [menuArray addObject:menuModel2];
    
    MenuModel *menuModel3 = [[MenuModel alloc] init];
    [menuModel3 setImage:@"MenuFavourites"];
    [menuModel3 setTitle:LString(@"FAVORITES")];
    [menuArray addObject:menuModel3];
    
    MenuModel *menuModel4 = [[MenuModel alloc] init];
    [menuModel4 setImage:@"MenuFriends"];
    [menuModel4 setTitle:LString(@"FRIENDS")];
    [menuArray addObject:menuModel4];
    int i =0;
    for(FriendsModel *order in APP_DELEGATE.friendsRecentOrders)
    {
        if(i==3)
            break;
        [menuArray addObject:order];
        i++;
        
    }
    
    MenuModel *menuModel5 = [[MenuModel alloc] init];
    [menuModel5 setImage:@"MenuSettings"];
    [menuModel5 setTitle:LString(@"SETTINGS")];
    [menuArray addObject:menuModel5];
    
    [mTableView reloadData];
}

-(void) updateUserData {
    
    if ([TLUserDefaults isGuestUser]) {
        
        profileImageView.imageURL = [NSURL URLWithString:@""];
        profileImageView.userInteractionEnabled = NO;
        
        userNameLbl.text = @"Guest User";
        userNameLbl.userInteractionEnabled = NO;
        
        creditBalanceLbl.text = @"£0.00";
    }
    else
    {
        profileImageView.imageURL = [NSURL URLWithString:[TLUserDefaults getCurrentUser].Photo];
        profileImageView.userInteractionEnabled = YES;
        
        userNameLbl.text = [NSString stringWithFormat:@"%@ %@",[[TLUserDefaults getCurrentUser].FirstName stringWithTitleCase],[[TLUserDefaults getCurrentUser].LastName stringWithTitleCase]];
        userNameLbl.userInteractionEnabled = YES;
        
        creditBalanceLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[[TLUserDefaults getCurrentUser].AvailableBalance doubleValue]]];
    }
}

-(void)openMyProfileVc:(id)sender
{
    
     NETWORK_TEST_PROCEDURE
//    [APP_DELEGATE.slideMenuController hideMenuViewController];
//    if(!myProfileVC)
//    {
//        myProfileVC = [[TLUserProfileViewController alloc] init];
//    }
//    else
//    {
//        [myProfileVC reloadUserprofile];
//    }
//    UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:myProfileVC];
//    [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
    [TuplitConstants openMyProfile];
    
}

-(void) openfriendProfileVC:(UITapGestureRecognizer *)gesture
{
     NETWORK_TEST_PROCEDURE
    
    CGPoint buttonPosition = [(EGOImageView*)gesture.view convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    FriendsModel *order = [menuArray objectAtIndex:indexPath.row];
    
    [APP_DELEGATE.slideMenuController hideMenuViewController];
//    if(!friendProfileVC)
//    {
        friendProfileVC = [[TLOtherUserProfileViewController alloc] init];
//    }
//    else
//    {
//        [friendProfileVC reloadOtherUserprofile];
//    }
    friendProfileVC.userID = order.FriendId;
    friendProfileVC.isLeftMenu = YES;
    UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:friendProfileVC];
    [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
}

-(void)updateFriendsActivity
{
    [self performSelectorInBackground:@selector(callUserdetailService) withObject:nil];
}

-(void)callUserdetailService
{
    TLUserDetailsManager *userDetailsManager = [TLUserDetailsManager new];
    userDetailsManager.delegate = self;
    [userDetailsManager getUserDetailsWithUserID:[TLUserDefaults getCurrentUser].UserId];
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
            
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (MENU_CELL_HEIGHT - 39)/2, 39, 39)];
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
            iconImageView.layer.cornerRadius = 20/2;
            iconImageView.contentMode = UIViewContentModeScaleAspectFill;
            iconImageView.userInteractionEnabled = YES;
            iconImageView.clipsToBounds = YES;
            iconImageView.backgroundColor = [UIColor clearColor];
            UITapGestureRecognizer *otherUserprofileGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openfriendProfileVC:)];
            [iconImageView addGestureRecognizer:otherUserprofileGesture];
            [cell.contentView addSubview:iconImageView];
            
            UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(35 + 10, 0, 150, FRIENDS_CELL_HEIGHT)];
            labelName.tag = 2001;
            labelName.backgroundColor = [UIColor clearColor];
            labelName.textColor = [UIColor whiteColor];
            labelName.numberOfLines = 3;
            labelName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
//            labelName.userInteractionEnabled = YES;
//            UITapGestureRecognizer *otherUserprofileGesture1 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openfriendProfileVC:)];
//            [labelName addGestureRecognizer:otherUserprofileGesture1];
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
        
        [iconView setImageURL:[NSURL URLWithString:friendModel.Photo]];
        
        NSString *userName = [[NSString stringWithFormat:@"%@",friendModel.FriendName]stringWithTitleCase];
        NSString *staticText = @"shopped at";
        
        NSString *string = [NSString stringWithFormat:@"%@ %@ %@",userName,staticText,[friendModel.MerchantName stringWithTitleCase]];
        NSMutableAttributedString *aString=[[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10]}];
        [aString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFFFFF) range:NSMakeRange(0, userName.length)];
        [aString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xb8e5e2) range:NSMakeRange(userName.length + 1, staticText.length)];
        [aString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFFFFF) range:NSMakeRange(userName.length + staticText.length + 2, friendModel.MerchantName.length)];
        
        labelName.attributedText = aString;
    }
    
    return cell;
    
}

#pragma mark - Table view delegate source methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if (indexPath.row == 0) {
        
         NETWORK_TEST_PROCEDURE
//        [APP_DELEGATE.slideMenuController hideMenuViewController];
//        if(!merchantVC)
//        {
//            merchantVC = [[TLMerchantsViewController alloc] init];
//        }
//        else
//        {
//            [merchantVC reloadMerchant];
//        }
//        UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:merchantVC];
//        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        [TuplitConstants openMerchantVC];
        
    }
    else if(indexPath.row == 1) {
        
         NETWORK_TEST_PROCEDURE
        
        if ([TLUserDefaults getCurrentUser] == nil) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LString(@"TUPLIT") message:@"You need to register in the app to do the purchase. Would you like to register?" delegate:self cancelButtonTitle:LString(@"NO") otherButtonTitles:@"YES", nil];
            alertView.tag = 9000;
            [alertView show];
        }
        else
        {
            [APP_DELEGATE.slideMenuController hideMenuViewController];
            if(!cartVC)
            {
                cartVC = [[TLCartViewController alloc] init];
            }
            else
            {
//                [cartVC updateCart];
            }
            cartVC.isMerchant = NO;
            UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:cartVC];
            [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        }
    }
    else if(indexPath.row == 2) {
        
         NETWORK_TEST_PROCEDURE
        
        if ([TLUserDefaults getCurrentUser] == nil) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LString(@"TUPLIT") message:@"You need to register in the app to view your favorites. Would you like to register?" delegate:self cancelButtonTitle:LString(@"NO") otherButtonTitles:@"YES", nil];
            alertView.tag = 9000;
            [alertView show];
        }
        else
        {
            [APP_DELEGATE.slideMenuController hideMenuViewController];
            if(!favoriteVC)
            {
                favoriteVC = [[TLFavouriteListViewController alloc] init];
            }
            else
            {
                [favoriteVC reloadfavourites];
            }
            UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:favoriteVC];
            [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        }
    }
    else if(indexPath.row == 3) {
        
         NETWORK_TEST_PROCEDURE
        
        if ([TLUserDefaults getCurrentUser] == nil) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LString(@"TUPLIT") message:@"You need to register in the app to view your friends activities. Would you like to register?" delegate:self cancelButtonTitle:LString(@"NO") otherButtonTitles:@"YES", nil];
            alertView.tag = 9000;
            [alertView show];
        }
        else
        {
            [APP_DELEGATE.slideMenuController hideMenuViewController];
            if(!friendsVC)
            {
                friendsVC = [[TLFriendsViewController alloc] init];
            }
            else
            {
                [friendsVC reloadFriends];
            }
            UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:friendsVC];
            [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        }
    }
    else if(indexPath.row == menuArray.count - 1) {
        
        [APP_DELEGATE.slideMenuController hideMenuViewController];
        if(!settingsVC)
        {
            settingsVC = [[TLSettingsViewController alloc] initWithNibName:@"TLSettingsViewController" bundle:nil];
        }
        UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate Source Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 9000) {
        
        if (buttonIndex == 1) {
            
            [TuplitConstants userLogout];
        }
    }
}

#pragma mark - TLUserDetailsManagerDelegate methods

- (void)userDetailManagerSuccess:(TLUserDetailsManager *)userDetailsManager withUser:(UserModel*)user_ withUserDetail:(UserDetailModel*)userDetail_ {
    
    [TLUserDefaults setCurrentUser:user_];
}

- (void)userDetailsManager:(TLUserDetailsManager *)userDetailsManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    [[ProgressHud shared] hide];
  
}

- (void)userDetailsManagerFailed:(TLUserDetailsManager *)userDetailsManager {
    
    [[ProgressHud shared] hide];
}

@end

