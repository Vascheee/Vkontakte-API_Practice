//
//  VSCustomPostCell.m
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSUser.h"
#import "VSGroup.h"
#import "VSPost.h"
#import "VSPhoto.h"
#import "VSPostCell.h"
#import "MWPhotoBrowser.h"
#import "VSCollectionViewCell.h"
#import "UIKit+AFNetworking.h"


@interface VSPostCell () < UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation VSPostCell





+ (CGFloat)heightForCellByText:(NSString*)text forWidth:(NSInteger)width {
     
    UIFont *font = [UIFont systemFontOfSize:14];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentNatural;
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSDictionary *attr = @{NSFontAttributeName           : font,
                           NSParagraphStyleAttributeName : style,
                           NSShadowAttributeName         : shadow};
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                  attributes:attr
                                     context:nil];
    return CGRectGetHeight(rect);
}


+ (CGFloat)heightForCellByPhotoArray:(NSArray*)array forWidth:(NSInteger)width {
    CGFloat heightImage = 0.0;
    CGFloat height = 0.0;
    if (array.count > 1) {
        for (VSPhoto *photo in array) {
        CGFloat proportion = (float)photo.height / (float)photo.width;
        heightImage = width *proportion;
        height = height + (NSInteger)heightImage; }
        } else {
            VSPhoto *photo = [array firstObject];
            CGFloat proportion = (float)photo.height / (float)photo.width;
            height = width *proportion;
        }
    return height;
}


-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImage.layer.cornerRadius = CGRectGetWidth(self.avatarImage.frame)/10;
    self.avatarImage.layer.borderWidth  = 1.f;
    self.avatarImage.layer.borderColor  =
    [UIColor colorWithRed:0.5842 green:0.5814 blue:0.5899 alpha:1.0].CGColor;
    
    self.repostOwnerImage.layer.cornerRadius = CGRectGetWidth(self.avatarImage.frame)/10;
    self.repostOwnerImage.layer.borderWidth  = 1.f;
    self.repostOwnerImage.layer.borderColor  =
    [UIColor colorWithRed:0.5842 green:0.5814 blue:0.5899 alpha:1.0].CGColor;

}



- (void)configureWithPost:(VSPost*)post {
    self.videoImView.hidden = YES;
    self.videoNameLabel.hidden = YES;
    self.videoInfoLabel.hidden = YES;

    if (post.photoArrayInPost.count > 0) {
        self.arrayPhotosInPost = post.photoArrayInPost;
        [self.collectionView reloadData];
    }
    if (post.isRepostingRecord) {
        [self.repostOwnerImage setHidden:NO];
        [self.repostOwnerNameLabel setHidden:NO];
        [self assineImageToImageView:self.repostOwnerImage
                            byString:post.repostOwnerImageString];
        
        if (post.repostFromUser) {
            self.repostOwnerNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                              post.repostFromUser.firstName,
                                              post.repostFromUser.lastName];
        } else {
            self.repostOwnerNameLabel.text = [NSString stringWithFormat:@"%@",
                                              post.repostFromGroup.nameGroup]; }
    } else {
        [self.repostOwnerImage setHidden:YES];
        [self.repostOwnerNameLabel setHidden:YES];
    }
    self.postTextLabel.text      = post.text;
    self.dateLabel.text          = post.date;
    self.commentsCountLabel.text = [NSString stringWithFormat:@"%ld", (long)post.commentCount];
    self.likesCountLabel.text    = [NSString stringWithFormat:@"%ld", (long)post.likeCount];
    self.ownerNameLabel.text     = [NSString stringWithFormat:@"%@ %@",
                                    post.fromUser.firstName, post.fromUser.lastName];
    [self assineImageToImageView:self.avatarImage byString:post.fromUser.smallImageURLString];
    if ([self.ownerNameLabel.text isEqualToString:@"(null) (null)"]) {
        self.ownerNameLabel.text     = [NSString stringWithFormat:@"%@",
                                        post.fromGroup.nameGroup];
        [self assineImageToImageView:self.avatarImage byString:post.fromGroup.smallPhotoStringUrl];
    }
    if (post.videoImageURL) {
        self.videoInfoLabel.hidden = NO;
        self.videoImView.hidden = NO;
        self.videoNameLabel.hidden = NO;
        self.videoNameLabel.text = post.videofileName;
        [self assineImageToImageView:self.videoImView byString:post.videoImageURL];
    }
}



- (void)assineImageToImageView:(UIImageView*)imageView
                      byString:(NSString*)urlString {
    
    __weak UIImageView *imView = imageView;
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:urlString]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [imView setImageWithURLRequest:request
                      placeholderImage:nil
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                   imView.image = image;
                               } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                               }];
    });
}




#pragma mark - UICollectionViewDataSource
/*=================================================================================================*/


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayPhotosInPost.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VSCollectionViewCell *albumCell = (VSCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell"                                                           forIndexPath:indexPath];
    
    VSPhoto *photo = self.arrayPhotosInPost[indexPath.row];
    [self assineImageToImageView:albumCell.albumCoverCell byString:photo.urlString_photo_604];
    return albumCell;
}



#pragma mark - UICollectionViewDelegate
/*=================================================================================================*/


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VSPhoto *photo = self.arrayPhotosInPost[indexPath.row];
  
    CGSize size = [VSCollectionViewCell photoCellSizeForWallByPhotoWidth:photo.width andPhotoHeight:photo.height];
    return size;
}



@end


