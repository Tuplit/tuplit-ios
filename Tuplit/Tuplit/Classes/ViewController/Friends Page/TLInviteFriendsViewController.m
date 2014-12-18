    //
//  TLInviteFriendsViewController.m
//  Tuplit
//
//  Created by ev_mac11 on 17/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLInviteFriendsViewController.h"
#import "NSArray+BlocksKit.h"

@interface TLInviteFriendsViewController ()
{
    NSString *fbUserId;
    NSMutableArray *fbFriendArray,*fbFriendsIDArray,*contactArray, *checkContactIdArray;
    BOOL isFacebook;
    NSIndexPath *selectedIndex;
    
    UILabel *errorLbl;
    UIView *errorView;
    
    ABAddressBookRef addressBook;
    
    NSArray *_peopleList;
    NSMutableArray *_selectedPeopleList;
    NSMutableArray *_peopleImageList;
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
    [navleftButton backButtonWithTarget:self action:@selector(backToFriends)];
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
    [facebookBtn setTitle:@"Google+" forState:UIControlStateNormal];
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
    [contactsBtn setBackgroundImage:[UIImage imageNamed:@"ButtonLightBg"] forState:UIControlStateNormal];
    
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
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        facebookTable.delaysContentTouches = NO;
    [baseView addSubview:facebookTable];
    
    [self menuButtonAction:facebookBtn];
    
    errorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(menuView.frame)+10, baseViewWidth, CGRectGetHeight(facebookTable.frame))];
//    errorView.hidden = YES;
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
    checkContactIdArray = [[NSMutableArray alloc]init];
        
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
    [self googleSignin];
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
                                      @"GoogleFriends"            : fbFriendsIDArray,
                                      };
        
        TLFacebookIDManager *checkfb = [[TLFacebookIDManager alloc]init];
        checkfb.delegate = self;
        checkfb.isGoolge = YES;
        [checkfb callService:queryParams];
    }
    else
    {
        [[ProgressHud shared] hide];
    }
}

-(void)checkContactFriendsList
{
    if(contactArray.count>0)
    {
        [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
        NSDictionary *queryParams = @{
                                      @"ContactFriends"            : checkContactIdArray,
                                      };
        
        TLFacebookIDManager *checkfb = [[TLFacebookIDManager alloc]init];
        checkfb.delegate = self;
        checkfb.isGoolge = NO;
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
        if(!isFacebook)
        {
            isFacebook = YES;
            [facebookBtn setBackgroundImage:Nil forState:UIControlStateNormal];
            [facebookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            facebookBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
            
            [contactsBtn setBackgroundImage:[UIImage imageNamed:@"ButtonLightBg"] forState:UIControlStateNormal];
            [contactsBtn setTitleColor:UIColorFromRGB(0x00998c) forState:UIControlStateNormal];
            contactsBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
            if(fbFriendArray.count>0)
            {
                errorView.hidden = YES;
            }
            else
            {
                errorView.hidden = NO;
                errorLbl.text = LString(@"NO_FB_FRIEND_FOUND");
                return;
            }
        }
        
    }
    else
    {
        if(isFacebook)
        {
            isFacebook = NO;
            [contactsBtn setBackgroundImage:Nil forState:UIControlStateNormal];
            [contactsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            contactsBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
            
            [facebookBtn setBackgroundImage:[UIImage imageNamed:@"ButtonLightBg"] forState:UIControlStateNormal];
            [facebookBtn setTitleColor:UIColorFromRGB(0x00998c) forState:UIControlStateNormal];
            facebookBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
            
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
                        [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
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
                                
                                if ([firstName stringByTrimmingLeadingWhitespace].length == 0)
                                {
                                    firstName = @"";
                                }
                                if ([lastName stringByTrimmingLeadingWhitespace].length == 0 )
                                {
                                    lastName = @"";
                                }
                                if ([firstName stringByTrimmingLeadingWhitespace].length == 0 && [lastName stringByTrimmingLeadingWhitespace].length == 0 )
                                {
                                    person.name = @"";
                                }
                                else
                                {
                                    person.name = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
                                }
                                
                                if (email.length == 0)
                                    email= @"";
                                
                                person.email = [NSString stringWithFormat:@"%@",email];
                                
                                if(email.length >0 && ![email isEqualToString:[TLUserDefaults getCurrentUser].Email])
                                {
                                    [checkContactIdArray addObject:email];
                                    [contactArray addObject:person];
                                }
                                
                                
                            }
                            CFRelease(addressBook);
                            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
                            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                            NSArray *sortedArray = [contactArray sortedArrayUsingDescriptors:sortDescriptors];
                            contactArray =[NSMutableArray arrayWithArray:sortedArray];
                            
                            [self performSelectorOnMainThread:@selector(reloadTable) withObject:self waitUntilDone:YES];
                            //                        [[ProgressHud shared] hide];
                            
                        }
                        else
                        {
                            errorView.hidden = NO;
                            errorLbl.text = LString(@"NO_CONTACT_FOUND");
                            [[ProgressHud shared] hide];
                        }
                    }
                });
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            }
            
        }
        else
        {
            if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
                ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted )
            {
                // Display an error.
                errorView.hidden = NO;
                errorLbl.text = LString(@"ACCESS_DENIED");
                return;
            }
        }
    }
    [facebookTable reloadData];
}

-(void)reloadTable
{
//    [facebookTable reloadData];
    
    if(contactArray.count == 0)
    {
        errorView.hidden = NO;
        errorLbl.text = LString(@"NO_CONTACT_FOUND");
    }
    else
    {
        errorView.hidden = YES;
        [self checkContactFriendsList];
    }
}

-(void) callInviteFriendsService : (UIButton*) sender
{
    if(isFacebook)
    {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:facebookTable];
        NSIndexPath *indexPath = [facebookTable indexPathForRowAtPoint:buttonPosition];
        CheckUserModel *gplusUser = [fbFriendArray objectAtIndex:indexPath.row];
        selectedIndex = indexPath;
        fbUserId = gplusUser.Id;
        NSLog(@"gplusUserID = %@",gplusUser.Id);
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        [GPPShare sharedInstance].delegate = self;
        
        NSString *messageBody = [NSString stringWithFormat:@"%@ \n iTunes link: %@", [[TLUserDefaults inviteMsg]stringByStrippingHTML], [TLUserDefaults getItunesURL]];
        // Set any prefilled text that you might want to suggest
        [shareBuilder setPrefillText:messageBody];
        
//        [shareBuilder setURLToShare:[NSURL URLWithString:[TLUserDefaults getItunesURL]]];
        
        [shareBuilder setPreselectedPeopleIDs:[NSArray arrayWithObject:gplusUser.Id]];
        
        [shareBuilder open];
        
    }
    else
    {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:facebookTable];
        NSIndexPath *indexPath = [facebookTable indexPathForRowAtPoint:buttonPosition];
        selectedIndex = indexPath;
        if (indexPath != nil)
        {
            Person *contactuser = [contactArray objectAtIndex:indexPath.row];
                        
            if([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
                controller.mailComposeDelegate = self;
                controller.navigationBar.barStyle = UIBarStyleDefault;
                [[controller navigationBar] setTintColor:UIColorFromRGB(0XFFFFFF)];
                
                [controller setSubject:LString(@"INVITE_SUBJECT")];
                [controller setToRecipients:[NSArray arrayWithObject:contactuser.email]];
                
                fbUserId = contactuser.email;
                
//                UIImage *image = [UIImage imageNamed:@"Icon"];
//                //include your app icon here
//                [controller addAttachmentData:UIImageJPEGRepresentation(image, 1) mimeType:@"image/jpg" fileName:@"icon.jpg"];
                // your message and link
//                NSString *defaultBody = [TLUserDefaults inviteMsg];
                
                NSString *messageBody = [NSString stringWithFormat:LString(@"INVITE_MESSAGE"), [TLUserDefaults inviteMsg], [TLUserDefaults getItunesURL]];
                
                [controller setMessageBody:messageBody isHTML:YES];
                
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                    
                    [controller.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
                }
                else
                {
                    [controller.navigationBar setTintColor:[UIColor blackColor]];
                }
                
                [self presentViewController:controller animated:YES completion:nil];
            }
            else
            {
                [UIAlertView alertViewWithMessage:LString(@"EMAIL_ACCOUNT_SETUP")];
            }
            

    }
}
}

//   facebook

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
        profileImgView.clipsToBounds=YES;
        profileImgView.contentMode = UIViewContentModeScaleAspectFill;
        profileImgView.tag=1000;
        [cell.contentView addSubview:profileImgView];
        
        UILabel *profileNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(profileImgView.frame) + 70 ,8, 180,INVITE_CELL_HEIGHT/2 - 5)];
        profileNameLbl.textColor=UIColorFromRGB(0x333333);
        profileNameLbl.tag=1001;
        profileNameLbl.textAlignment=NSTextAlignmentLeft;
        profileNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
        profileNameLbl.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:profileNameLbl];
        
        UILabel *mailIDLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(profileImgView.frame) + 70 ,CGRectGetMaxY(profileNameLbl.frame), 180,INVITE_CELL_HEIGHT/2 - 7)];
        mailIDLbl.textColor=UIColorFromRGB(0x333333);
        mailIDLbl.tag=1002;
        mailIDLbl.textAlignment=NSTextAlignmentLeft;
        mailIDLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
        mailIDLbl.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:mailIDLbl];
        
        UIButton *inviteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        inviteBtn.frame=CGRectMake(CGRectGetMaxX(profileNameLbl.frame),10,60, 30);
        inviteBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
//        [inviteBtn setTitle:@"Invite" forState:UIControlStateNormal];
        inviteBtn.tag = 1003;
//        [inviteBtn setBackgroundImage:getImage(@"invite", NO) forState:UIControlStateNormal];
//        [inviteBtn addTarget:self action:@selector(callInviteFriendsService:) forControlEvents:UIControlEventTouchUpInside];
        inviteBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
        inviteBtn.titleLabel.textColor=UIColorFromRGB(0xffffff);
        [cell.contentView addSubview:inviteBtn];
        
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(70, INVITE_CELL_HEIGHT-1, baseViewWidth - 70, 1)];
        lineView.backgroundColor=UIColorFromRGB(0xCCCCCC);
        [cell.contentView addSubview:lineView];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            for (id obj in cell.subviews)
            {
                if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
                {
                    UIScrollView *scroll = (UIScrollView *) obj;
                    scroll.delaysContentTouches = NO;
                    break;
                }
            }
        }
    }
    if(isFacebook)
    {
        if([fbFriendArray count]>0)
        {
            CheckUserModel *gplusUser = [fbFriendArray objectAtIndex:indexPath.row];
            
            EGOImageView *profileImgView=(EGOImageView *)[cell.contentView viewWithTag:1000];
            UILabel *profileNameLbl=(UILabel *)[cell.contentView viewWithTag:1001];
            UILabel *mailIDLbl=(UILabel *)[cell.contentView viewWithTag:1002];
            UIButton *inviteBtn = (UIButton *)[cell.contentView viewWithTag:1003];
            profileNameLbl.height = INVITE_CELL_HEIGHT-16;
            
            profileNameLbl.text = gplusUser.name;
            profileImgView.imageURL = [NSURL URLWithString:gplusUser.picture];
            mailIDLbl.text=@"";
            if(gplusUser.AlreadyInvited.intValue==0)
            {
                [inviteBtn setTitle:@"Invite" forState:UIControlStateNormal];
                [inviteBtn setBackgroundImage:getImage(@"invite", NO) forState:UIControlStateNormal];
                [inviteBtn addTarget:self action:@selector(callInviteFriendsService:) forControlEvents:UIControlEventTouchUpInside];
                inviteBtn.enabled = YES;
            }
            else
            {
                [inviteBtn setTitle:@"Invited" forState:UIControlStateNormal];
                [inviteBtn setBackgroundImage:getImage(@"invite_grey", NO) forState:UIControlStateNormal];
                [inviteBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
                inviteBtn.enabled = NO;
            }
        }
    }
    else
    {
        Person *contactuser = [contactArray objectAtIndex:indexPath.row];
        
        EGOImageView *profileImgView=(EGOImageView *)[cell.contentView viewWithTag:1000];
        UILabel *profileNameLbl=(UILabel *)[cell.contentView viewWithTag:1001];
        UILabel *mailIDLbl=(UILabel *)[cell.contentView viewWithTag:1002];
        UIButton *inviteBtn = (UIButton *)[cell.contentView viewWithTag:1003];
        profileNameLbl.height = INVITE_CELL_HEIGHT/2 - 5;

        if(contactuser.contactImage)
            profileImgView.image = contactuser.contactImage;
        else
            profileImgView.image = getImage(@"UserPlaceHolder", NO);
        
        if ([contactuser.name stringByTrimmingLeadingWhitespace] == (id)[NSNull null] || [contactuser.name stringByTrimmingLeadingWhitespace].length == 0 )
        {
            profileNameLbl.text=@"";
            [mailIDLbl positionAtY:15];
        }
        else
        {
            profileNameLbl.text=[contactuser.name stringWithTitleCase];
            [mailIDLbl positionAtY:CGRectGetMaxY(profileNameLbl.frame)];
        }
        
        mailIDLbl.text=contactuser.email;
        
        if(contactuser.AlreadyInvited.intValue==0)
        {
            [inviteBtn setTitle:@"Invite" forState:UIControlStateNormal];
            [inviteBtn setBackgroundImage:getImage(@"invite", NO) forState:UIControlStateNormal];
            [inviteBtn addTarget:self action:@selector(callInviteFriendsService:) forControlEvents:UIControlEventTouchUpInside];
            inviteBtn.enabled = YES;
        }
        else
        {
            [inviteBtn setTitle:@"Invited" forState:UIControlStateNormal];
            [inviteBtn setBackgroundImage:getImage(@"invite_grey", NO) forState:UIControlStateNormal];
            [inviteBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
            inviteBtn.enabled = NO;
        }
    }
    
    return cell;
    
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
        
        NETWORK_TEST_PROCEDURE
        [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
        
        NSDictionary *queryParams = @{
                                      @"Email"            :  NSNonNilString(fbUserId),
                                      };
        
        TLFriendsInviteManager *inviteFriend = [[TLFriendsInviteManager alloc]init];
        inviteFriend.delegate = self;
        [inviteFriend callService:queryParams];
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self.navigationController  dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Helper methods

-(void)googleSignin
{
    NETWORK_TEST_PROCEDURE;
    
    APP_DELEGATE.isSocialhandeled = YES;
    GPPSignIn *signIn = [GPPSignIn sharedInstance];

//        [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
        signIn.shouldFetchGooglePlusUser = YES;
        signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
        signIn.clientID = GOOGLE_CLIENT_ID;
        
        // Uncomment one of these two statements for the scope you chose in the previous step
        signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
        // signIn.scopes = @[ @"profile" ];            // "profile" scope
        
        // Optional: declare signIn.actions, see "app activities"
        signIn.delegate = self;
        [GPPDeepLink readDeepLinkAfterInstall];
        if(![signIn trySilentAuthentication])
            [signIn authenticate];
}

- (void)listPeople:(NSString *)collection {
    
    _peopleList = nil;
    _peopleImageList = nil;

    
    // 1. Create a |GTLQuery| object to list people that are visible to this
    // sample app.
    GTLQueryPlus *query =
    [GTLQueryPlus queryForPeopleListWithUserId:@"me"
                                    collection:collection];
    
    // 2. Execute the query.
    [[[GPPSignIn sharedInstance] plusService] executeQuery:query
                                         completionHandler:^(GTLServiceTicket *ticket,
                                                             GTLPlusPeopleFeed *peopleFeed,
                                                             NSError *error)
     {
         if (error)
         {
             GTMLoggerError(@"Error: %@", error);
             errorLbl.text = [NSString stringWithFormat:@"Error: %@", error];
             [facebookTable reloadData];
         }
         else
         {
             // Get an array of people from |GTLPlusPeopleFeed| and reload
             // the table view.
             
             [fbFriendsIDArray removeAllObjects];
             [fbFriendArray removeAllObjects];
             
             for (GTLPlusPerson *person in peopleFeed.items) {
                 
                 [fbFriendsIDArray addObject:person.identifier];
                 
                 CheckUserModel *usermodel = [[CheckUserModel alloc]init];
                 usermodel.Id =person.identifier;
                 usermodel.name = person.displayName;
                 usermodel.picture = person.image.url;
                 
                 [fbFriendArray addObject:usermodel];
             }
             
             if(fbFriendsIDArray.count>0)
             {
                 errorView.hidden = NO;
                 [self performSelectorOnMainThread:@selector(callSendFriendsWebservice) withObject:nil waitUntilDone:NO];
             }
             else
             {
                 errorView.hidden = NO;
                 errorLbl.text =LString(@"NO_FB_FRIEND_FOUND");
                 [[ProgressHud shared] hide];
             }
             
         }
     }];
}

#pragma mark - GooglePlus methods

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error {
    
    // NSLog(@"Received error %@ and auth object %@",error, auth);
    
    if(error) {
//        [[ProgressHud shared] hide];
        [UIAlertView alertViewWithMessage:LString(@"GOOGLE_ERROR")];
        
    } else {
        
        [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];

        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        [self listPeople:kGTLPlusCollectionVisible];
        
    }
}

- (void)finishedSharingWithError:(NSError *)error
{
    if(!error)
    {
        NETWORK_TEST_PROCEDURE
        [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
        
        NSDictionary *queryParams = @{
                                      @"GoogleId"            :  NSNonNilString(fbUserId),
                                      };
        
        TLFriendsInviteManager *inviteFriend = [[TLFriendsInviteManager alloc]init];
        inviteFriend.delegate = self;
        [inviteFriend callService:queryParams];
    }
    else
        if(error.code!=-401)
            [UIAlertView alertViewWithMessage:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
}
- (void)finishedSharing:(BOOL)shared
{
    
}

#pragma  mark - TLFacebookIDManager Delegate Methods

- (void)fbIDManagerSuccess:(TLFacebookIDManager *)fbIDManager withFriendsListingManager:(NSArray*)_fbfriendsList
{
    
//    NSArray *serverTrackResult = [_fbfriendsList bk_select:^BOOL(id obj) {
//        
//        CheckUserModel *checkfriend = obj;
//        if(checkfriend.AlreadyInvited.intValue==0)
//            return YES;
//        else
//            return NO;
//    }];
    
    if(fbIDManager.isGoolge)
    {
        for (CheckUserModel *usermodel in _fbfriendsList) {
            
            [[NSArray arrayWithArray:fbFriendArray] enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
                CheckUserModel *persondetail = (CheckUserModel*)object;
                    if([persondetail.Id isEqualToString:usermodel.Id])
                    {
                        persondetail.AlreadyInvited = usermodel.AlreadyInvited;
                        [fbFriendArray replaceObjectAtIndex:idx withObject:persondetail];
                    }
            }];
            
            //        i++;
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
    }
    else
    {
        for (CheckUserModel *usermodel in _fbfriendsList)  {
            [[NSArray arrayWithArray:contactArray] enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
                Person *persondetail = (Person*)object;
                if(persondetail.email.length>0)
                {
                    if([persondetail.email isEqualToString:usermodel.Id])
                    {
                        persondetail.AlreadyInvited = usermodel.AlreadyInvited;
                        [contactArray replaceObjectAtIndex:idx withObject:persondetail];
                    }
                }
            }];
            
            //        i++;
        }
        
        if(contactArray.count==0)
        {
            errorView.hidden = NO;
            errorLbl.text =LString(@"NO_CONTACT_FOUND");
        }
        else
        {
            errorView.hidden = YES;
        }
    }
    [facebookTable reloadData];
     [[ProgressHud shared] hide];
}

- (void)fbIDManager:(TLFacebookIDManager *)fbIDManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    errorView.hidden = NO;
    errorLbl.text = errorMsg;
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
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

    if(isFacebook)
    {
        CheckUserModel *usermodel = [fbFriendArray objectAtIndex:selectedIndex.row];
        usermodel.AlreadyInvited = @"1";
        [fbFriendArray replaceObjectAtIndex:selectedIndex.row withObject:usermodel];
        [facebookTable reloadRowsAtIndexPaths:@[selectedIndex] withRowAnimation:UITableViewRowAnimationFade];
        
        if(fbFriendArray.count == 0)
        {
            errorView.hidden = NO;
            errorLbl.text =LString(@"NO_FB_FRIEND_FOUND");
            
        }
    }
    else
    {
        Person *usermodel = [contactArray objectAtIndex:selectedIndex.row];
        usermodel.AlreadyInvited = @"1";
        [contactArray replaceObjectAtIndex:selectedIndex.row withObject:usermodel];
        [facebookTable reloadRowsAtIndexPaths:@[selectedIndex] withRowAnimation:UITableViewRowAnimationFade];
        
        if(contactArray.count == 0)
        {
            errorView.hidden = NO;
            errorLbl.text =LString(@"NO_CONTACT_FOUND");
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateFriendsActivity object:nil];
    APP_DELEGATE.isFriendInvited = YES;
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:invitemessage];
    
}
- (void)inviteManager:(TLFriendsInviteManager *)inviteManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
//    2255 2256
    if([errorCode isEqualToString:@"2255"] ||[errorCode isEqualToString:@"2256"] )
    {
        if(isFacebook)
        {
            CheckUserModel *usermodel = [fbFriendArray objectAtIndex:selectedIndex.row];
            usermodel.AlreadyInvited = @"1";
            [fbFriendArray replaceObjectAtIndex:selectedIndex.row withObject:usermodel];
            [facebookTable reloadRowsAtIndexPaths:@[selectedIndex] withRowAnimation:UITableViewRowAnimationFade];
            
            if(fbFriendArray.count == 0)
            {
                errorView.hidden = NO;
                errorLbl.text =LString(@"NO_FB_FRIEND_FOUND");
                
            }
        }
        else
        {
            Person *usermodel = [contactArray objectAtIndex:selectedIndex.row];
            usermodel.AlreadyInvited = @"1";
            [contactArray replaceObjectAtIndex:selectedIndex.row withObject:usermodel];
            [facebookTable reloadRowsAtIndexPaths:@[selectedIndex] withRowAnimation:UITableViewRowAnimationFade];
            if(contactArray.count == 0)
            {
                errorView.hidden = NO;
                errorLbl.text =LString(@"NO_CONTACT_FOUND");
            }
        }
    }
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
    
}
- (void)inviteManagerFailed:(TLFriendsInviteManager *)inviteManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}
@end