//
//  TLInviteFriendsViewController.m
//  Tuplit
//
//  Created by ev_mac11 on 17/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLInviteFriendsViewController.h"

@interface TLInviteFriendsViewController ()
{
     NSString *fbUserId;
    NSMutableArray *fbFriendArray,*fbFriendsIDArray,*contactArray;
    BOOL isFacebook;
    int selectedIndex;
    
    UILabel *errorLbl;
    UIView *errorView;
    
    ABAddressBookRef addressBook;
}

@end

@implementation TLInviteFriendsViewController

#pragma mark - View Life Cycle Methods.

-(void) loadView
{
    [super loadView];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setTitle:LString(@"INVITE_FRIENDS")];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
    [navleftButton buttonWithIcon:getImage(@"back", NO) target:self action:@selector(backToFriends) isLeft:NO];
    [self.navigationItem setLeftBarButtonItem:navleftButton];
    
    baseViewWidth=self.view.frame.size.width;
    baseViewHeight=self.view.frame.size.height;
    
    baseView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    baseView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:baseView];
    
    menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, baseView.frame.size.width, 34)];
    [menuView setBackgroundColor:[UIColor clearColor]];
    [menuView setUserInteractionEnabled:YES];
    [baseView addSubview:menuView];
    
    UIButton *facebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    facebookBtn.tag = 201;
    [facebookBtn addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchDown];
    [facebookBtn setTitle:@"Facebook" forState:UIControlStateNormal];
    facebookBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    facebookBtn.frame=CGRectMake(0, 0, menuView.frame.size.width/2, 34);
    facebookBtn.backgroundColor = UIColorFromRGB(0X01b3a5);
    [facebookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [menuView addSubview:facebookBtn];
    
    UIButton *contactsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactsBtn.tag = 202;
    [contactsBtn addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchDown];
    [contactsBtn setTitle:@"Contacts" forState:UIControlStateNormal];
    contactsBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    contactsBtn.frame = CGRectMake(CGRectGetMaxX(facebookBtn.frame), 0, menuView.frame.size.width/2, 34);
    contactsBtn.backgroundColor = UIColorFromRGB(0X01b3a5);
    [contactsBtn setTitleColor:UIColorFromRGB(0x00998c) forState:UIControlStateNormal];
    [contactsBtn setBackgroundImage:[UIImage imageNamed:@"ButtonLightBg.png"] forState:UIControlStateNormal];
    
    [menuView addSubview:contactsBtn];
    
    int adjustHeight;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        adjustHeight = 64;
    }
    else
    {
        adjustHeight = 44;
    }

    
    facebookTable=[[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(menuView.frame)+10,baseViewWidth,baseViewHeight-CGRectGetMaxY(menuView.frame)-10-adjustHeight) style:UITableViewStylePlain];
    facebookTable.delegate=self;
    facebookTable.dataSource=self;
    facebookTable.tag=101;
    facebookTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [baseView addSubview:facebookTable];
    
    [self menuButtonAction:facebookBtn];
    
    errorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(menuView.frame)+10, baseViewWidth, CGRectGetHeight(facebookTable.frame))];
    errorView.hidden = YES;
    [errorView setBackgroundColor:[UIColor whiteColor]];
    [baseView addSubview:errorView];
    
    errorLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, (errorView.frame.size.height - 100)/2, errorView.frame.size.width - 20, 100)];
    [errorLbl setTextAlignment:NSTextAlignmentCenter];
    [errorLbl setTextColor:[UIColor lightGrayColor]];
    errorLbl.numberOfLines = 0;
    [errorView addSubview:errorLbl];
    
    fbFriendArray = [[NSMutableArray alloc] init];
    fbFriendsIDArray = [[NSMutableArray alloc] init];
    contactArray = [[NSMutableArray alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self facebookFriendAction];  
//     [self promptUserWithAccountNameForStatusUpdate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User Defined Methods.

-(void)callSendFriendsWebservice
{
    if(fbFriendArray.count>0)
    {
    NSDictionary *queryParams = @{
                                   @"FacebookFriends"            : fbFriendsIDArray,
                                  };
        
        TLFacebookIDManager *checkfb = [[TLFacebookIDManager alloc]init];
        checkfb.delegate = self;
        [checkfb callService:queryParams];
    }
    else
    {
        [[ProgressHud shared] hide];
    }
}

-(void) backToFriends
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) menuButtonAction :(UIButton*) button
{
    UIButton *facebookBtn = (UIButton*)[baseView viewWithTag:201];
    UIButton *contactsBtn = (UIButton*)[baseView viewWithTag:202];
    
    if (button.tag == 201)
    {
        isFacebook = YES;
        [contactsBtn setBackgroundImage:[UIImage imageNamed:@"ButtonLightBg.png"] forState:UIControlStateNormal];
        [contactsBtn setTitleColor:UIColorFromRGB(0x00998c) forState:UIControlStateNormal];
        contactsBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
        
        [facebookBtn setBackgroundImage:Nil forState:UIControlStateNormal];
        [facebookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        facebookBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
        
        [facebookBtn setUserInteractionEnabled:NO];
        [contactsBtn setUserInteractionEnabled:YES];
        [facebookTable reloadData];
        
        if(fbFriendArray.count==0)
        {
            errorView.hidden = NO;
            errorLbl.text =LString(@"NO_FB_FRIEND_FOUND");
        }
        else
        {
            errorView.hidden = YES;
        }

        
    }
    else
    {
        isFacebook = NO;
        [contactsBtn setBackgroundImage:Nil forState:UIControlStateNormal];
        [contactsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        contactsBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
        
        [facebookBtn setBackgroundImage:[UIImage imageNamed:@"ButtonLightBg.png"] forState:UIControlStateNormal];
        [facebookBtn setTitleColor:UIColorFromRGB(0x00998c) forState:UIControlStateNormal];
        facebookBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
        
        [facebookBtn setUserInteractionEnabled:YES];
        [contactsBtn setUserInteractionEnabled:NO];
        
        __block BOOL userDidGrantAddressBookAccess;
        CFErrorRef addressBookError = NULL;
        [contactArray removeAllObjects];
        
        if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined ||
            ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized )
        {
            addressBook = ABAddressBookCreateWithOptions(NULL, &addressBookError);
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
                userDidGrantAddressBookAccess = granted;
                dispatch_semaphore_signal(sema);
                
                if(userDidGrantAddressBookAccess)
                {
                     addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                    if (addressBook!=nil)
                    {
                        NSArray *allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
                        
                        NSUInteger i = 0;
                        for (i = 0; i<[allContacts count]; i++)
                        {
                            Person *person = [[Person alloc] init];
                            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
                            NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
                            NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
                            ABMultiValueRef multi = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
                            NSString *email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multi, 0);
                        
                            
                            if (ABPersonHasImageData(contactPerson)) {
                                NSData *imgData = (__bridge NSData*)ABPersonCopyImageDataWithFormat(contactPerson, kABPersonImageFormatOriginalSize);
                                UIImage *img = [UIImage imageWithData: imgData];
                                person.contactImage = img;
                            }
                            else
                            {
                                person.contactImage = nil;
                            }
                            if(!lastName)
                                lastName = @"";
                            NSLog(@"email = %@",email);
                            person.name = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
                            person.email = [NSString stringWithFormat:@"%@",email];
                            
                            if(email)
                              [contactArray addObject:person];
                            
                        }
                        CFRelease(addressBook);
                        [self performSelectorOnMainThread:@selector(reloadTable) withObject:self waitUntilDone:YES];
                        
                    }
                    else
                    {
                        NSLog(@"Error");
                        errorView.hidden = NO;
                        errorLbl.text = LString(@"NO_CONTACT_FOUND");
                    }
                }
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        else
        {
            if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
                ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted )
            {
                // Display an error.
                errorView.hidden = NO;
                errorLbl.text = LString(@"ACCESS_DENIED");
            }
        }
    }
     [facebookTable reloadData];
}

-(void)reloadTable
{
    [facebookTable reloadData];
    
    if(contactArray.count == 0)
    {
        errorView.hidden = NO;
        errorLbl.text = LString(@"NO_CONTACT_FOUND");
    }
    else
        errorView.hidden = YES;
}

-(void) callInviteFriendsService : (UIButton*) sender
{
    NSLog(@"invite friends");
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:facebookTable];
    NSIndexPath *indexPath = [facebookTable indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        if(isFacebook)
        {
            selectedIndex = indexPath.row;
            CheckUserModel *friend = [fbFriendArray objectAtIndex:indexPath.row];
            NSDictionary *queryParams = @{
                                          @"FBId"            :  NSNonNilString(friend.Id),
                                          };
            
            NETWORK_TEST_PROCEDURE
            [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
            
            TLFriendsInviteManager *inviteFriend = [[TLFriendsInviteManager alloc]init];
            inviteFriend.delegate = self;
            [inviteFriend callService:queryParams];
        }
        
    }
}

//   facebook

-(void)facebookFriendAction{

    
   
    //    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    
    if (FBSession.activeSession.isOpen) {
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 fbUserId = user.objectID;
                 [self promptUserWithAccountNameForStatusUpdate];
             }
             else
             {
                 [[ProgressHud shared] hide];
                 UIAlertView *tmp = [[UIAlertView alloc]
                                     initWithTitle:LString(@"FAILURE")
                                     message:LString(@"CANNOT_CONNECT")
                                     delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:LString(@"OK"), nil];
                 [tmp show];
             }
         }];
        
    } else {
        
          NSArray *permissions = [NSArray arrayWithObjects:@"publish_stream",@"read_friendlists",@"user_birthday",nil];
        [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES  completionHandler:^(FBSession *session, FBSessionState state, NSError *error){
            
            if (error) {
                [[ProgressHud shared] hide];
                UIAlertView *tmp = [[UIAlertView alloc]
                                    initWithTitle:LString(@"FAILURE")
                                    message:LString(@"CANNOT_CONNECT")
                                    delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:LString(@"OK"), nil];
                [tmp show];
                
            } else if (FB_ISSESSIONOPENWITHSTATE(state)) {
                
                [[FBRequest requestForMe] startWithCompletionHandler:
                 ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                     if (!error) {
                         fbUserId = user.objectID;
                         [self promptUserWithAccountNameForStatusUpdate];
                     }
                     else
                     {
                         [[ProgressHud shared] hide];
                         UIAlertView *tmp = [[UIAlertView alloc]
                                             initWithTitle:LString(@"FAILURE")
                                             message:LString(@"CANNOT_CONNECT")
                                             delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:LString(@"OK"), nil];
                         [tmp show];
                     }
                 }];
            }
        }];
    }
}

-(void)promptUserWithAccountNameForStatusUpdate {
    
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:[FBSession activeSession]
     message:@"FBinviteMessage"
     title:nil
     parameters:nil
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         NSLog(@"result = %u",result);
         
         NSLog(@"error = %@",error);
         
         NSLog(@"resultURL = %@",resultURL);
         
     }
     ];
    
//    [fbFriendArray removeAllObjects];
//    [fbFriendsIDArray removeAllObjects];
//    
//    [FBRequestConnection startWithGraphPath:@"/me/taggable_friends?fields=name,id,picture"
//                                 parameters:nil
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(
//                                              FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error
//                                              ) {
//                              /* handle the result */
//                              NSLog(@"result%@",result);
//                              NSArray* friends = [result objectForKey:@"data"];
//                              
//                              for (NSDictionary<FBGraphUser>* friend in friends) {
//                                  [fbFriendsIDArray addObject:friend.id];
//
//                                  CheckUserModel *usermodel = [[CheckUserModel alloc]init];
//                                  usermodel.Id = friend.id;
//                                  usermodel.name = friend.name;
//                                  usermodel.picture = [[[friend objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"];
//                                  [fbFriendArray addObject:usermodel];
//                              }
//                              if(fbFriendsIDArray.count>0)
//                                  [self performSelectorOnMainThread:@selector(callSendFriendsWebservice) withObject:nil waitUntilDone:NO];
//                              else
//                              {
//                                  errorView.hidden = NO;
//                                  errorLbl.text =LString(@"NO_FB_FRIEND_FOUND");
//                              }
//                          }];
    
}

#pragma mark - Table View Delegates.

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isFacebook)
        return [fbFriendArray count];
    else
    {
        NSLog(@"%d",[contactArray count]);
        return [contactArray count];
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return INVITE_CELL_HEIGHT;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *cellIdentifier=@"CellFacebook";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            EGOImageView *profileImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""] imageViewFrame:CGRectMake(16,(INVITE_CELL_HEIGHT-40)/2, 40, 40 )];
            profileImgView.backgroundColor = [UIColor whiteColor];
            profileImgView.layer.cornerRadius=40/2;
            profileImgView.userInteractionEnabled=YES;
            profileImgView.clipsToBounds=YES;
            profileImgView.tag=1000;
            [cell.contentView addSubview:profileImgView];
            
            UILabel *profileNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(profileImgView.frame) + 70 ,8, 180,INVITE_CELL_HEIGHT/2 - 5)];
            profileNameLbl.textColor=UIColorFromRGB(0x333333);
            //            profileNameLbl.numberOfLines=0;
            profileNameLbl.tag=1001;
            profileNameLbl.textAlignment=NSTextAlignmentLeft;
            profileNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
            profileNameLbl.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:profileNameLbl];
            
            UILabel *mailIDLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(profileImgView.frame) + 70 ,CGRectGetMaxY(profileNameLbl.frame), 180,INVITE_CELL_HEIGHT/2 - 7)];
            mailIDLbl.textColor=UIColorFromRGB(0x333333);
            //            mailIDLbl.numberOfLines=0;
            mailIDLbl.tag=1002;
            mailIDLbl.textAlignment=NSTextAlignmentLeft;
            mailIDLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
            mailIDLbl.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:mailIDLbl];
            
            UIButton *inviteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            inviteBtn.frame=CGRectMake(CGRectGetMaxX(profileNameLbl.frame),10,60, 30);
            inviteBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
            [inviteBtn setTitle:@"Invite" forState:UIControlStateNormal];
            inviteBtn.tag = 1003;
            inviteBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
            inviteBtn.titleLabel.textColor=UIColorFromRGB(0xffffff);
            [inviteBtn setBackgroundImage:getImage(@"invite", NO) forState:UIControlStateNormal];
            [inviteBtn addTarget:self action:@selector(callInviteFriendsService:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:inviteBtn];
            
            UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(70, cell.frame.size.height + 6, baseViewWidth - 70, 1)];
            lineView.backgroundColor=UIColorFromRGB(0xCCCCCC);
            [cell.contentView addSubview:lineView];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    if(isFacebook)
    {
        CheckUserModel *fbuser = [fbFriendArray objectAtIndex:indexPath.row];
        
        EGOImageView *profileImgView=(EGOImageView *)[cell.contentView viewWithTag:1000];
        UILabel *profileNameLbl=(UILabel *)[cell.contentView viewWithTag:1001];
        UILabel *mailIDLbl=(UILabel *)[cell.contentView viewWithTag:1002];
        
        NSLog(@"picture url = %@",fbuser.picture);
        profileImgView.imageURL = [NSURL URLWithString:fbuser.picture];
        profileNameLbl.text=fbuser.name;
        mailIDLbl.text=@"sample@mail.com";
    }
    else
    {
        Person *contactuser = [contactArray objectAtIndex:indexPath.row];
        
        EGOImageView *profileImgView=(EGOImageView *)[cell.contentView viewWithTag:1000];
        UILabel *profileNameLbl=(UILabel *)[cell.contentView viewWithTag:1001];
        UILabel *mailIDLbl=(UILabel *)[cell.contentView viewWithTag:1002];
        
        NSLog(@"%@ %@",contactuser.name,contactuser.email);
        if(contactuser.contactImage)
            profileImgView.image = contactuser.contactImage;
        else
            profileImgView.image = getImage(@"UserPlaceHolder", NO);
        profileNameLbl.text=contactuser.name;
        mailIDLbl.text=contactuser.email;
    }
    
        return cell;
   
}

#pragma  mark - TLFacebookIDManager Delegate Methods

- (void)fbIDManagerSuccess:(TLFacebookIDManager *)fbIDManager withFriendsListingManager:(NSArray*)_fbfriendsList
{
    
    [[ProgressHud shared] hide];
    NSLog(@"_fbfriendsList = %@",_fbfriendsList);
    
    NSMutableArray *invitableFriends = [[NSMutableArray alloc]init];
    int i = 0;
    for(CheckUserModel *checkfriend in _fbfriendsList)
    {
        CheckUserModel *invitableFriend = [fbFriendArray objectAtIndex:i];
        invitableFriend.AlreadyInvited = checkfriend.AlreadyInvited;
        [invitableFriends addObject:invitableFriend];
        i++;
    }
    [fbFriendArray removeAllObjects];
    i = 0;
    NSLog(@"[fbFriendArray count] = %d",[fbFriendArray count]);
    for(int j =0;j<[invitableFriends count];j++)
    {
        CheckUserModel *checkfriend = [invitableFriends objectAtIndex:j];
        NSLog(@"AlreadyInvited = %d",checkfriend.AlreadyInvited.intValue);
        if(!checkfriend.AlreadyInvited.intValue)
        {
            [fbFriendArray addObject:checkfriend];
        }
    }
    if(fbFriendArray.count==0)
    {
        errorView.hidden = NO;
        errorLbl.text =LString(@"NO_FB_FRIEND_FOUND");
    }
    else
    {
        errorView.hidden = YES;
    }
   
    [facebookTable reloadData];
}
- (void)fbIDManager:(TLFacebookIDManager *)fbIDManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    errorView.hidden = NO;
    errorLbl.text = errorMsg;
    
    [UIAlertView alertViewWithMessage:errorMsg];
    [[ProgressHud shared] hide];
}
- (void)fbIDManagerFailed:(TLFacebookIDManager *)fbIDManager
{
    errorView.hidden = NO;
    errorLbl.text = LString(@"SERVER_CONNECTION_ERROR");  
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

#pragma  mark - TLFriendsInviteManager Delegate Methods

- (void)inviteManagerSuccess:(TLFriendsInviteManager *)inviteManager withinviteStatus:(NSString*)invitemessage
{
    FriendsListModel *friend = [fbFriendArray objectAtIndex:selectedIndex];
//    
//    NSMutableDictionary *parmaDic = [NSMutableDictionary dictionaryWithCapacity:4];
//    [parmaDic setObject:[NSString stringWithFormat:@"hello world"] forKey:@"message"]; // if you want send message
//    [parmaDic setObject:@"http://icon.png" forKey:@"picture"];  // if you want send picture
//    [parmaDic setObject:@"Create post" forKey:@"name"];         // if you want send name
//    [parmaDic setObject:@"Write description." forKey:@"description"]; // if you want  description
//    
//    [FBRequestConnection requestWithGraphPath:[NSString stringWithFormat:@"/%@/feed",friend.Id]
//                          andParams:parmaDic
//                      andHttpMethod:@"POST"
//                        andDelegate:self];
    
    
    [fbFriendArray removeObjectAtIndex:selectedIndex];
    [facebookTable reloadData];
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:invitemessage];
    
    
}
- (void)inviteManager:(TLFriendsInviteManager *)inviteManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];

}
- (void)inviteManagerFailed:(TLFriendsInviteManager *)inviteManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];

}
@end