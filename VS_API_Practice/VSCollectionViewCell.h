//
//  VSCollectionViewCell.h
//  VS_API_Practice
//
//  Created by Mac on 30.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSCollectionViewCell : UICollectionViewCell <UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *albumCoverCell;


+ (CGSize)photoCellSizeByWidth:(CGFloat)width andHeight:(CGFloat)height;
+ (CGSize)photoCellSizeForWallByPhotoWidth:(CGFloat)photoWidth andPhotoHeight:(CGFloat)photoHeight;

@end
