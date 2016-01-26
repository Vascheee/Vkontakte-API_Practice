//
//  VSFriendVC.m
//  VS_API_Practice
//
//  Created by Mac on 22.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSFriendVC.h"
#import "VSGroupPageVC.h"
#import "VSUserPageVC.h"

#import "VSServerManager.h"
#import "UIKit+AFNetworking.h"
#import "VSAccessToken.h"

#import "VSUser.h"
#import "VSGroup.h"


@interface VSFriendVC () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *friendsArray;
@property (strong, nonatomic) NSMutableArray *groupsArray;
@property (strong, nonatomic) NSArray        *reserveArray;

@property (strong, nonatomic) UITableView    *tableView;
@property (strong, nonatomic) UISearchBar    *searchBar;
@property (nonatomic, strong) NSString       *value;

@property (assign, nonatomic) BOOL           isFirstAutorize;
@property (assign, nonatomic) BOOL           loadingData;
@property (assign, nonatomic) BOOL           isGroups;

@end

@implementation VSFriendVC

static NSInteger requestCount = 20;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar *sb = [[UISearchBar alloc]
                       initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 46)];
    sb.placeholder = @"Поиск друга";
    sb.showsCancelButton = YES;
    sb.delegate = self;
    sb.keyboardType = UIKeyboardTypeDefault;
    self.searchBar = sb;
    [self.view addSubview:sb];
    
    CGRect rect = CGRectMake(0, 110, CGRectGetWidth(self.view.bounds),
                             CGRectGetHeight(self.view.bounds)-110);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithRed:0.771 green:0.771 blue:0.771 alpha:1.0];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    self.isGroups = NO;
    self.friendsArray = [NSMutableArray array];
    self.groupsArray  = [NSMutableArray array];

    switch (self.filter) {
        case 1 : [self getFriendsFromServer];      break;
        case 2 : [self getGroupsFromServer]; self.isGroups = YES; break;
        case 3 : [self getSubsriptionsFromServer];    break;
        case 4 : [self getFollowersFromServer]; break;  }
}



#pragma mark - API
//================================================================================================:


- (void)getFriendsFromServer {
    [[VSServerManager sharedManager] getFriendsForUser:self.userID
                                                 limit:MAXFLOAT
                                            withOffset:(self.friendsArray).count
                                             onSuccess:^(NSArray *friendsArray) {
                                                 
                                                 NSArray *array = [friendsArray subarrayWithRange:NSMakeRange(0, requestCount)];
                                                 self.friendsArray = [NSMutableArray arrayWithArray:array];
                                                 self.reserveArray = [NSArray arrayWithArray:friendsArray];
                                                 [self.tableView reloadData];
                                                 self.loadingData = NO;
                                             }
                                             onFailure:^(NSError *error, NSInteger statusCode) {
                                                 NSLog(@"Error - %@. StatusCode -%ld", error, (long)statusCode);
                                             }];
}


- (void)getGroupsFromServer {
    [[VSServerManager sharedManager] getGroupsForUser:self.userID
                                                 limit:requestCount
                                            withOffset:(self.groupsArray).count
                                             onSuccess:^(NSArray *groupsArray) {
                                                 if (groupsArray.count < requestCount) {
                                                     self.groupsArray = [NSMutableArray arrayWithArray:groupsArray];
                                                 } else {
                                                 NSArray *array = [groupsArray subarrayWithRange:NSMakeRange(0, requestCount)];
                                                 self.groupsArray = [NSMutableArray arrayWithArray:array];
                                                     self.reserveArray = [NSArray arrayWithArray:groupsArray];}
                                                 [self.tableView reloadData];
                                                 self.loadingData = NO;
                                             }
                                             onFailure:^(NSError *error, NSInteger statusCode) {
                                                 NSLog(@"Error - %@. StatusCode -%ld", error, (long)statusCode);
                                             }];
}


- (void)getFollowersFromServer {
    [[VSServerManager sharedManager] getFollowersOfUser:self.userID
                                                  limit:requestCount
                                             withOffset:(self.friendsArray).count
                                              onSuccess:^(NSArray *friendsArray) {
                                                  [self.friendsArray addObjectsFromArray:friendsArray];
                                                  [self.tableView reloadData];
                                                  self.loadingData = NO;
                                              } onFailure:^(NSError *error, NSInteger statusCode) {
                                                  NSLog(@"Error - %@. StatusCode -%ld", error, (long)statusCode);
                                              }];
}


- (void)getSubsriptionsFromServer {
    [[VSServerManager sharedManager] getSubscriptionsForUser:self.userID
                                                       limit:requestCount
                                                  withOffset:(self.friendsArray).count
                                                   onSuccess:^(NSArray *friendsArray) {
                                                       [self.friendsArray addObjectsFromArray:friendsArray];
                                                       [self.tableView reloadData];
                                                       self.loadingData = NO;
                                                   } onFailure:^(NSError *error, NSInteger statusCode) {
                                                       NSLog(@"Error - %@. StatusCode -%ld", error, (long)statusCode);
                                                   }];
}



#pragma mark - UITableViewDelegate
//================================================================================================:



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
     if (self.friendsArray.count > self.groupsArray.count) {
        id obj = (self.friendsArray)[indexPath.row];
        
        if ([obj isKindOfClass:[VSUser class]]) {
            VSUser *friend = (self.friendsArray)[indexPath.row];
            VSUserPageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VSUserPageVC"];
            vc.userID = friend.userID;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        if ([obj isKindOfClass:[VSGroup class]]) {
            VSGroup *group = self.friendsArray[indexPath.row];
            VSGroupPageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VSGroupPageVC"];
            vc.groupID = group.groupID;
            [self.navigationController pushViewController:vc animated:YES]; }
        } else {
            VSGroup *group = self.groupsArray[indexPath.row];
            VSGroupPageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VSGroupPageVC"];
            vc.groupID = group.groupID;
            [self.navigationController pushViewController:vc animated:YES];
        }
}


#pragma mark - UITableViewDataSource
//================================================================================================:


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isGroups) {
        return self.groupsArray.count;
    }
    return self.friendsArray.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"friend";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier]; }

    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}


-(void)configureCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {
    UILabel *isOnlainIndicatorLabel;

    isOnlainIndicatorLabel = [[UILabel alloc] initWithFrame:
                              CGRectMake(325, -3, 20, 30)];
    isOnlainIndicatorLabel.contentMode = UIViewContentModeCenter;
    isOnlainIndicatorLabel.font = [UIFont boldSystemFontOfSize:40];
    isOnlainIndicatorLabel.textColor = [UIColor colorWithRed:0.5104 green:0.5323 blue:0.5615 alpha:1.0];
    [cell.contentView addSubview:isOnlainIndicatorLabel];
    
    NSURL *imageURL;
    if (self.isGroups) {
        VSGroup *group = (self.groupsArray)[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", group.nameGroup];
        imageURL = [NSURL URLWithString: group.smallPhotoStringUrl];
    } else {
        id obj = (self.friendsArray)[indexPath.row];
        if ([obj isKindOfClass:[VSGroup class]]) {
            VSGroup *group = (self.friendsArray)[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", group.nameGroup];
            imageURL = [NSURL URLWithString: group.smallPhotoStringUrl];
        } else {
            VSUser *friend = (self.friendsArray)[indexPath.row];
            if (!friend.nameOfSubscription) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
            } else {
                cell.textLabel.text = friend.nameOfSubscription;
            }
            if ((friend.userOnlain).integerValue == 1) {
                isOnlainIndicatorLabel.text =  @".";
            }
            imageURL = [NSURL URLWithString:friend.smallImageURLString]; }
    }
    cell.textLabel.textColor = [UIColor brownColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.imageView.clipsToBounds = YES;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_back"]];
    
    __weak UITableViewCell *weakCell = cell;
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakCell.imageView.image = image;
                                       [weakCell layoutSubviews];
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {                     }];
}

#pragma mark - ScrollView
/*=================================================================================================*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            if (!self.loadingData && !self.isGroups) {
                self.loadingData = YES;
                [self getMoreFriends];
            } else if (!self.loadingData && self.isGroups) {
                self.loadingData = YES;
                [self getMoreGroups]; }
    }
}




#pragma mark - UISearchBarDelegate
/*=================================================================================================*/



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
 
    if ([searchText length] == 0) {
        if (self.isGroups) {
            self.groupsArray = [NSMutableArray arrayWithArray:self.reserveArray];
            [self.tableView reloadData];
        } else {
            self.friendsArray = [NSMutableArray arrayWithArray:self.reserveArray];
            [self.tableView reloadData]; }
    }
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (self.isGroups) {
        self.groupsArray = [NSMutableArray arrayWithArray:self.reserveArray];
        [self.tableView reloadData];
    } else {
        self.friendsArray = [NSMutableArray arrayWithArray:self.reserveArray];
        [self.tableView reloadData];
    }
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newString;
    if ([text isEqualToString:@""]) {
        newString = [searchBar.text substringToIndex:[searchBar.text length] - 1];
        if (self.isGroups) {
            self.groupsArray = [self createArrayObjectsByString:newString inArray:self.reserveArray];
            [self.tableView reloadData];
        } else {
            self.friendsArray = [self createArrayObjectsByString:newString inArray:self.reserveArray];
            [self.tableView reloadData]; }
    } else {
        newString = [searchBar.text stringByAppendingString:text];
        if (self.isGroups) {
            self.groupsArray = [self createArrayObjectsByString:newString inArray:self.reserveArray];
            [self.tableView reloadData];
        } else {
            self.friendsArray = [self createArrayObjectsByString:newString inArray:self.reserveArray];
            [self.tableView reloadData]; }
    }
    return YES;
}


#pragma mark - Support
/*=================================================================================================*/

- (void)getMoreFriends {
    
    NSArray *array = [self.reserveArray subarrayWithRange:NSMakeRange(self.friendsArray.count, requestCount)];
    [self.friendsArray addObjectsFromArray:array];
    [self.tableView reloadData];
    self.loadingData = NO;
}

- (void)getMoreGroups {
    
    NSArray *array = [self.reserveArray subarrayWithRange:NSMakeRange(self.groupsArray.count, requestCount)];
    [self.groupsArray addObjectsFromArray:array];
    [self.tableView reloadData];
    self.loadingData = NO;
}


- (NSMutableArray*)createArrayObjectsByString:(NSString*)string inArray:(NSArray*)array {
    NSMutableArray *newArray = [NSMutableArray new];
    if (self.isGroups) {
        for (VSGroup *group in array) {
            if ([group.nameGroup containsString:string]) {
                [newArray addObject:group]; }
        }
    } else {
        for (VSUser *friend in array) {
            if ([friend.firstName containsString:string] || [friend.lastName containsString:string]) {
                [newArray addObject:friend]; }
        }
    }
    return newArray;
}




@end
