//
//  VSUserPhotoAlbum.h
//  VS_API_Practice
//
//  Created by Mac on 28.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSServerObject.h"

@interface VSUserPhotoAlbum : VSServerObject

@property (strong, nonatomic) NSString *albumID;
@property (strong, nonatomic) NSString *ownerID;
@property (strong, nonatomic) NSString *titlePhotoUrlString;
@property (nonatomic, assign) NSNumber *photoCount;

@end
