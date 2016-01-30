//
//  VSUserPageVC.m
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSServerManager.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "MWPhotoBrowser.h"
#import "MBProgressHUD.h"
#import "VSAccessToken.h"
#import "VSMessageVC.h"

#import "VSUser.h"
#import "VSPost.h"
#import "VSPhoto.h"
#import "VSGroup.h"

#import "VSFriendVC.h"
#import "VSUserPageVC.h"

#import "VSWallMessageCell.h"
#import "VSUserConnectionsCell.h"
#import "VSCollectionViewCell.h"
#import "VSUserInfoCell.h"
#import "VSPostCell.h"


@interface VSUserPageVC () <UITableViewDelegate, UITableViewDataSource, MWPhotoBrowserDelegate,
UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate,
UITextFieldDelegate, VSWallMessageCellProtocol> {
    
    NSMutableArray *photoArray;
    NSMutableArray *photoArrayMWFormat;
    NSMutableArray *postArray;
    UIToolbar      *toolBar;
    UICollectionView *collection;
    NSString     *postsCount;
    MBProgressHUD  *hud;
    NSInteger       counter;
    BOOL           loadingData; }

@property (strong, nonatomic) VSUser *selectedUser;
@end

@implementation VSUserPageVC

static NSInteger postCount = 20;
static NSInteger photoLimitCount = 20;
static NSInteger postTextLabelWidth = 335;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.userID) {
        self.userID =[VSServerManager sharedManager].accessToken.userID;
        if (!self.userID) {
            [[VSServerManager sharedManager] autorizeUser:^(VSUser *user) {
                self.userID = user.userID;
                 self.selectedUser = user;
                [self getAllUserPhotos];
                [self getWallPosts]; }];
        } else {
            [self sendRequests]; }
    } else {
        [self sendRequests];
    }
    self.navigationController.navigationBar.backgroundColor =
    [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    collection.scrollsToTop = NO;

    
    photoArray         = [NSMutableArray new];
    postArray          = [NSMutableArray new];
    photoArrayMWFormat = [NSMutableArray new];
    counter = 0;
    loadingData = YES;
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressAction:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.2f;
    [self.tableView addGestureRecognizer:longPress];
    
    UIRefreshControl *refControl = [[UIRefreshControl alloc] init];
    [refControl addTarget:self action:@selector(refreshWallByPull)
         forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refControl;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}




- (void)sendRequests {
    [self getUser];
    [self getAllUserPhotos];
    [self getWallPosts];
}




#pragma mark - Server requests
/*=================================================================================================*/


- (void)getUser {
    [[VSServerManager sharedManager]  getUser:self.userID
                                    onSuccess:^(VSUser *user) {
                                        self.selectedUser = user;
                                    }
                                    onFailure:^(NSError *error, NSInteger statusCode) {
                                        NSLog(@"%@", error);
                                    }];
}


- (void)getAllUserPhotos {
    [[VSServerManager sharedManager] getAllUserPhotos:self.userID
                                                limit:photoLimitCount
                                             forGroup:NO
                                           withOffset:photoArray.count
                                            onSuccess:^(NSArray *albumsArray) {
                                                [photoArray addObjectsFromArray:albumsArray];
                                                [self prepareMWPhotoArray];
                                                [collection reloadData];
                                            } onFailure:^(NSError *error, NSInteger statusCode) {
                                                NSLog(@"Error - %@. StatusCode -%ld",
                                                      error, (long)statusCode); }];
}


- (void)getWallPosts {
    [[VSServerManager sharedManager]  getWallPost:self.userID
                                            limit:postCount
                                       withOffset:postArray.count
                                       withFilter:@"all"
                                          inGroup:NO
                                        onSuccess:^(NSArray *postsArray, NSString *count) {
                                            [postArray addObjectsFromArray:postsArray];
                                            postsCount = count;
                                            [self.tableView reloadData];
                                            loadingData = NO;
                                        }
                                        onFailure:^(NSError *error, NSInteger statusCode) {
                                            NSLog(@"Error - %@. StatusCode -%ld", error, (long)statusCode);
                                        }];
}


- (void)refreshWallByPull {
    [[VSServerManager sharedManager]  getWallPost:self.userID
                                            limit:MAX(postArray.count, postCount)
                                       withOffset:0
                                       withFilter:@"all"
                                          inGroup:NO
                                        onSuccess:^(NSArray *postsArray, NSString *count) {
                                            [postArray removeAllObjects];
                                            [postArray addObjectsFromArray:postsArray];
                                            [self.tableView reloadData];
                                            [self.refreshControl endRefreshing];
                                            loadingData = NO;
                                        }
                                        onFailure:^(NSError *error, NSInteger statusCode) {
                                            NSLog(@"Error - %@. StatusCode -%ld", error, (long)statusCode);
                                        }];
}


- (void)refreshWallAuto {
    [[VSServerManager sharedManager]  getWallPost:self.userID
                                            limit:MAX(postArray.count, postCount)
                                       withOffset:0
                                       withFilter:@"all"
                                          inGroup:NO
                                        onSuccess:^(NSArray *postsArray, NSString *count) {
                                            [postArray removeAllObjects];
                                            [postArray addObjectsFromArray:postsArray];
                                            [self.tableView reloadData];
                                            loadingData = NO;
                                        }
                                        onFailure:^(NSError *error, NSInteger statusCode) {
                                            NSLog(@"Error - %@. StatusCode -%ld", error, (long)statusCode);
                                        }];
}



     

#pragma mark - UITableViewDataSource
/*=================================================================================================*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return postArray.count+ 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *userIndentifier      = @"VSUserInfoCell";
    static NSString *connectionIdentifier = @"VSUserConnectionsCell";
    static NSString *albumsIdentifier     = @"VSPhotoAlbumsCell";
    static NSString *messageIdentifier    = @"VSWallMessageCell";
    
    if (indexPath.row == 0) {
        VSUserInfoCell *cell    = [tableView dequeueReusableCellWithIdentifier:userIndentifier];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                   self.selectedUser.firstName, self.selectedUser.lastName];
        cell.userCityLabel.text = self.selectedUser.userCity;
        BOOL onlineIndic = (self.selectedUser.userOnlain).integerValue;
        cell.onlineIndicatorLabel.text = onlineIndic ? @"online" : @"";
        [self assineImageToImageView:cell.avatar
                             forCell:cell byString:self.selectedUser.bigImageURLString];
        return cell;
    } else if (indexPath.row == 1) {
        
        VSUserConnectionsCell *cell = [tableView dequeueReusableCellWithIdentifier:connectionIdentifier];
        return cell;
    } else if (indexPath.row == 2) {
        if (photoArray.count > 0) {
            VSPhotoAlbumsCell *cell = [tableView dequeueReusableCellWithIdentifier:albumsIdentifier];
            collection = cell.collectionView;
            cell.collectionView.dataSource = self;
            cell.collectionView.delegate = self;
            cell.collectionView.scrollsToTop = NO;
            return cell;
        } else {
            VSPhotoAlbumsCell *cell = [tableView dequeueReusableCellWithIdentifier:albumsIdentifier];
            return cell;
        }
        return nil;
    } else if (indexPath.row == 3) {
        VSWallMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageIdentifier];
        cell.isGroup = NO;
        cell.ownerID = self.userID;
        cell.postsCountLabel.text = [NSString stringWithFormat:@"Записей на стене:%@", postsCount];
        cell.delegate = self;
        return cell;
    } else {
        VSPost *post = postArray[indexPath.row-4];
        VSPostCell *cell = [tableView dequeueReusableCellWithIdentifier:post.postType];
        [cell configureWithPost:post];
        cell.collectionView.scrollsToTop = NO;
        [cell.collectionView.collectionViewLayout invalidateLayout];

        if (!post.postType) { NSLog(@"PostType = nil. Post - %ld", indexPath.row-4); }
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    
}


#pragma mark - UITableViewDelegate
/*=================================================================================================*/


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: return tableView.frame.size.width *0.35 +20;
        case 1: return 34.f;
        case 2: if (photoArray.count > 0) { return 106.f;} else {return 1;};
        case 3: return 95.f;
    }
    VSPost *post = postArray[indexPath.row- 4];
    CGFloat heightPost;
    CGFloat heightPhoto;
  
    if ([post.postType isEqualToString:@"post_OnlyText"]) {
        heightPost = [VSPostCell heightForCellByText:post.text forWidth:postTextLabelWidth] +110;
        if (post.videoImageURL) {
            return  heightPost +280;
        }
        return heightPost;
    }
    if ([post.postType isEqualToString:@"post_OnlyPhoto"]) {
        return [VSPostCell heightForCellByPhotoArray:post.photoArrayInPost
                                            forWidth:[tableView bounds].size.width];
    }
    if ([post.postType isEqualToString:@"post_PhotoAndText"]) {
        heightPost = [VSPostCell heightForCellByText:post.text forWidth:postTextLabelWidth];
        heightPhoto =  [VSPostCell heightForCellByPhotoArray:post.photoArrayInPost forWidth:[tableView bounds].size.width];
        NSInteger heightAll = heightPost + heightPhoto +50;
        return heightAll;
    }
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView*) scrollView {
    if (scrollView == self.tableView) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Segue
/*=================================================================================================*/


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showFriendsSegue"]) {
        VSFriendVC *controller = segue.destinationViewController;
        controller.userID = self.userID;
        controller.title = [NSString stringWithFormat:@"%@ friends", self.selectedUser.firstName];
        controller.filter = 1;

    } else if ([segue.identifier isEqualToString:@"showGroupsSegue"]) {
        VSFriendVC *controller = segue.destinationViewController;
        controller.userID = self.userID;
        controller.filter = 2;
        controller.title = [NSString stringWithFormat:@"%@ groups", self.selectedUser.firstName];

    } else if ([segue.identifier isEqualToString:@"showFollowersSegue"]) {
        VSFriendVC *controller = segue.destinationViewController;
        controller.userID = self.userID;
        controller.title = [NSString stringWithFormat:@"%@ subscriptions", self.selectedUser.firstName];
        controller.filter = 3;
        
    } else if ([segue.identifier isEqualToString:@"showSubscriptionsSegue"]) {
        VSFriendVC *controller = segue.destinationViewController;
        controller.userID = self.userID;
        controller.title = [NSString stringWithFormat:@"%@ followers", self.selectedUser.firstName];
        controller.filter = 4;
        
    } else if ([segue.identifier isEqualToString:@"messageSegue"]) {
        VSMessageVC *controller = segue.destinationViewController;
        controller.addressee = self.selectedUser;
        controller.owner = [VSServerManager sharedManager].owner;
        controller.userID = self.userID;
        controller.title = @"Dialog";
    }
 }


#pragma mark - Supports
/*=================================================================================================*/


- (void)prepareMWPhotoArray {
    MWPhoto *photoMW;
    for (VSPhoto *photo in photoArray) {
        if (!photo.urlString_photo_1280) {
            photoMW = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:photo.urlString_photo_604]];
        } else {
            photoMW = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:photo.urlString_photo_1280]]; }
        photoMW.caption = photo.text;
        [photoArrayMWFormat addObject:photoMW];
    }
}


- (void)assineImageToImageView:(UIImageView*)cellImageView
                       forCell:(UITableViewCell*)cell byString:(NSString*)urlString {
    
    __weak UIImageView *imView = cellImageView;
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:urlString]];
    
    [imView setImageWithURLRequest:request
                  placeholderImage:nil
                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                               imView.image = image;
                               [cell layoutSubviews];
                           } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                           }];
}


#pragma mark - Actions
/*=================================================================================================*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            if (!loadingData) {
                loadingData = YES;
                [self getWallPosts];  }
        }
    } else {
        if ((scrollView.contentOffset.x + scrollView.frame.size.width) >= scrollView.contentSize.width) {
            [self getAllUserPhotos]; }
    }
}


- (IBAction)goToHomePageAction:(UIBarButtonItem *)sender {
    
    VSUserPageVC *navC = [self.navigationController.viewControllers firstObject];
    [self.navigationController popToRootViewControllerAnimated:YES];

    [navC refreshWallAuto];
}


- (void)longPressAction:(UILongPressGestureRecognizer*)longPress {
    
    CGPoint point = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    if (indexPath.row >2 && longPress.state == UIGestureRecognizerStateEnded) {
        VSPostCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        CGPoint point = [longPress locationInView:cell.contentView];
   
        if (CGRectContainsPoint(cell.avatarImage.frame, point)) {
            VSPost *post = postArray[indexPath.row-4];
            VSUser *friend = post.fromUser;
            VSUserPageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VSUserPageVC"];
            vc.userID = friend.userID;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (CGRectContainsPoint(cell.repostOwnerImage.frame, point)) {
            VSPost *post = postArray[indexPath.row-4];
            VSUser *friend = post.repostFromUser;
            VSUserPageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VSUserPageVC"];
            vc.userID = friend.userID;
            [self.navigationController pushViewController:vc animated:YES];  }
    }
}



#pragma mark - UICollectionViewDataSource
/*=================================================================================================*/



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return photoArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    VSCollectionViewCell *albumCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell"                                                           forIndexPath:indexPath];
    
    VSPhoto *photo = photoArray[indexPath.row];
    __weak UIImageView *imView = albumCell.albumCoverCell;
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:photo.urlString_photo_130]];
    
    [imView setImageWithURLRequest:request
                  placeholderImage:nil
                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                               imView.image = image;
                               [albumCell layoutSubviews];
                           } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                           }];
    return albumCell;
}


#pragma mark - UICollectionViewDelegate
/*=================================================================================================*/


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    browser.displayActionButton     = YES;
    browser.displayNavArrows        = YES;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill        = YES;
    browser.alwaysShowControls      = YES;
    browser.enableGrid              = YES;
    browser.startOnGrid             = NO;
    [browser showNextPhotoAnimated:    YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:indexPath.row];

    [self.navigationController pushViewController:browser animated:YES];
}



- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VSPhoto *photo = photoArray[indexPath.row];
    CGSize size = [VSCollectionViewCell photoCellSizeByWidth:photo.width andHeight:photo.height];
    if (size.height <= 0) {
    }
    return size;
}



#pragma mark - MWPhotoBrowserDelegate
/*=================================================================================================*/


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photoArrayMWFormat.count;
}


- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < photoArrayMWFormat.count) {
        return [photoArrayMWFormat objectAtIndex:index]; }
    return nil;
}
#pragma mark - VSWallMessageCellProtocol
/*=================================================================================================*/


- (void) showNewWallPost {
    [self refreshWallAuto];
}

@end
