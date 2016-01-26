//
//  VSCollectionViewCell.m
//  VS_API_Practice
//
//  Created by Mac on 30.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSCollectionViewCell.h"

@implementation VSCollectionViewCell


+ (CGSize)photoCellSizeByWidth:(CGFloat)width andHeight:(CGFloat)height {
    CGFloat proportion = width / height;
    if (!width || !height) {
        proportion = 1;
    }
    return CGSizeMake(95 *proportion, 95);
}



+ (CGSize)photoCellSizeForWallByPhotoWidth:(CGFloat)photoWidth andPhotoHeight:(CGFloat)photoHeight {
    CGFloat proportion = photoHeight / photoWidth;
    if (!photoHeight || !photoWidth) {
        proportion = 1;
    }
    
    return CGSizeMake(335, 335 *proportion);
}

-(void)prepareForReuse {
    [super prepareForReuse];
    //self.albumCoverCell.image = nil;
}

@end
