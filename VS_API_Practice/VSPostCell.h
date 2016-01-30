//
//  VSCustomPostCell.h
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSPost;

@interface VSPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *repostOwnerNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *videoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoInfoLabel;

@property (weak, nonatomic) IBOutlet UIImageView * videoImView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIImageView *repostOwnerImage;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *arrayPhotosInPost;

+ (CGFloat)heightForCellByPhotoArray:(NSArray*)array forWidth:(NSInteger)width;
+ (CGFloat)heightForCellByText:(NSString*)text forWidth:(NSInteger)width;
- (void)configureWithPost:(VSPost*)post;


@end
