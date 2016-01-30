//
//  VSGroupPageVC.m
//  VS_API_Practice
//
//  Created by Mac on 17.11.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSGroupPageVC.h"
#import "VSFriendVC.h"
#import "VSUserPageVC.h"

#import "VSServerManager.h"
#import "MWPhotoBrowser.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#import "VSUser.h"
#import "VSPost.h"
#import "VSGroup.h"
#import "VSPhoto.h"

#import "VSPhotoAlbumsCell.h"
#import "VSUserConnectionsCell.h"
#import "VSPostCell.h"
#import "VSGroupInfoCell.h"
#import "VSCollectionViewCell.h"
#import "VSWallMessageCell.h"


@interface VSGroupPageVC () <UITableViewDelegate, UITableViewDataSource, MWPhotoBrowserDelegate,
UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate> {
    NSMutableArray *photoAlbumsArray;
    NSMutableArray *photoArray;
    NSMutableArray *photoArrayMWFormat;
    NSMutableArray *postArray;
    UIToolbar      *toolBar;
    BOOL           loadingData; }

@property (strong, nonatomic) VSGroup *selectedGroup;
@end

@implementation VSGroupPageVC

static NSInteger postCount = 20;
static NSInteger photoLimitCount = 20;
static NSInteger postTextLabelWidth = 335;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor =
    [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    
    self.tableView.frame = CGRectMake(0, 65, CGRectGetWidth(self.view.bounds),
                                      CGRectGetHeight(self.view.bounds)-65);
/*    self.navigationController.navigationBar.backgroundColor =
    [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    [self.navigationController setToolbarHidden:YES];
    toolBar = self.navigationController.toolbar;
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.0
                                                             green:0.0
                                                              blue:0.0
                                                             alpha:0.2] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [toolBar setBackgroundImage:transparentImage
             forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault]; */

    photoAlbumsArray = [NSMutableArray new];
    photoArray = [NSMutableArray new];
    photoArrayMWFormat = [NSMutableArray new];
    postArray = [NSMutableArray new];
    
    [self getGroup];
    [self getAllUserPhotos];
    [self getWallPosts];
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
    
    UIBarButtonItem *goHomeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(goToHomePageAction)];
    self.navigationController.navigationItem.rightBarButtonItem = goHomeButton;
}



#pragma mark - Server requests
/*=================================================================================================*/



- (void)getGroup {
    [[VSServerManager sharedManager] getGroupByID:self.groupID
                                        onSuccess:^(VSGroup *group) {
                                            self.selectedGroup = group;
                                        } onFailure:^(NSError *error, NSInteger statusCode) {
                                            NSLog(@"%@", error);
                                        }];
}


- (void)getAllUserPhotos {
    [[VSServerManager sharedManager] getAllUserPhotos:self.groupID
                                                limit:photoLimitCount
                                             forGroup:YES
                                           withOffset:photoArray.count
                                            onSuccess:^(NSArray *albumsArray) {
                                                [photoArray addObjectsFromArray:albumsArray];
                                                [self prepareMWPhotoArray];
                                                [self.tableView reloadData];
                                            } onFailure:^(NSError *error, NSInteger statusCode) {
                                                NSLog(@"Error - %@. StatusCode -%ld",
                                                      error, (long)statusCode); }];
}


- (void)getWallPosts {
    [[VSServerManager sharedManager]  getWallPost:self.groupID
                                            limit:postCount
                                       withOffset:postArray.count
                                       withFilter:@"all"
                                          inGroup:YES
                                        onSuccess:^(NSArray *postsArray, NSString *count) {
                                            [postArray addObjectsFromArray:postsArray];
                                            [self.tableView reloadData];
                                            loadingData = NO;
                                        }
                                        onFailure:^(NSError *error, NSInteger statusCode) {
                                            NSLog(@"Error - %@. StatusCode -%ld", error, (long)statusCode);
                                        }];
}


- (void)refreshWallByPull {
    [[VSServerManager sharedManager]  getWallPost:self.groupID
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


#pragma mark - UITableViewDataSource
/*=================================================================================================*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return postArray.count +3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *groupIndentifier     = @"VSGroupInfoCell";
    static NSString *albumsIdentifier     = @"VSPhotoAlbumsCell";
    static NSString *messageIdentifier    = @"VSWallMessageCell";
  
    if (indexPath.row == 0) {
        VSGroupInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:groupIndentifier];
        
        [self assineImageToImageView:cell.avatar forCell:cell
                            byString:self.selectedGroup.bigPhotoStringUrl];
        cell.groupNameLabel.text = self.selectedGroup.nameGroup;
        cell.statusLabel.text = self.selectedGroup.statusString;
        cell.membersCountLabel.text = [NSString stringWithFormat:@"%@\nчеловек",
                                       self.selectedGroup.membersCount];
        return cell;
        
    } else if (indexPath.row == 1) {
        if (photoArray.count > 0) {
            VSPhotoAlbumsCell *cell = [tableView dequeueReusableCellWithIdentifier:albumsIdentifier];
            cell.collectionView.dataSource = self;
            cell.collectionView.delegate = self;
            return cell;
        } else {
            VSPhotoAlbumsCell *cell = [tableView dequeueReusableCellWithIdentifier:albumsIdentifier];
            return cell;
        }
        return nil;
        
    }  else if (indexPath.row == 2) {
        VSWallMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageIdentifier];
        cell.isGroup = YES;
        cell.ownerID = self.groupID;
        return cell;
        
    }  else {
            VSPost *post = postArray[indexPath.row-3];
            VSPostCell *cell = [tableView dequeueReusableCellWithIdentifier:post.postType];
            [cell configureWithPost:post];
            if (!post.postType) { NSLog(@"PostType = nil. Post - %ld", indexPath.row-4); }
            
            return cell;
    }
    return nil;
}


#pragma mark - UITableViewDelegate
/*=================================================================================================*/


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: return 185.f;
        case 1: if (photoArray.count > 0) { return 105.f;} else {return 1;};
        case 2: return 95.f;
    }        
    VSPost *post = postArray[indexPath.row - 3];
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




#pragma mark - Supports
/*=================================================================================================*/

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

#pragma mark - Actions
/*=================================================================================================*/


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
//        if (scrollView.contentOffset.y > 2000 && self.navigationController.toolbar.hidden) {
//            [self.navigationController setToolbarHidden:NO];  }
    }
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!loadingData) {
            loadingData = YES;
            [self getWallPosts];  }
    }
}


- (void)goToHomePageAction{
    
    UITableViewController *navC = [self.navigationController.viewControllers firstObject];
    [navC.tableView reloadData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)jumpToTopOfPageAction:(UIBarButtonItem *)sender {
//    [self.navigationController setToolbarHidden:YES];
//    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
}



- (void)longPressAction:(UILongPressGestureRecognizer*)longPress {
    
    CGPoint point = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    if (indexPath.row >3 && longPress.state == UIGestureRecognizerStateEnded) {
        VSPostCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        CGPoint point = [longPress locationInView:cell.contentView];
        
        if (CGRectContainsPoint(cell.avatarImage.frame, point)) {
            VSPost *post = postArray[indexPath.row-3];
            VSUser *friend = post.fromUser;
            VSUserPageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VSUserPageVC"];
            vc.userID = friend.userID;
            [self.navigationController pushViewController:vc animated:YES]; }
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
    return [VSCollectionViewCell photoCellSizeByWidth:photo.width andHeight:photo.height];
}



#pragma mark - MWPhotoBrowserDelegate
/*=================================================================================================*/


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photoArray.count;
}


- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < photoArrayMWFormat.count) {
        return [photoArrayMWFormat objectAtIndex:index];
    }
    return nil;
}




@end
