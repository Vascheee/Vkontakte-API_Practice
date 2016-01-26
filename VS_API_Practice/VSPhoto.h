//
//  VSPhoto.h
//  VS_API_Practice
//
//  Created by Mac on 16.11.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VSServerObject.h"

@interface VSPhoto : VSServerObject

@property (strong, nonatomic) NSString *photoID;
@property (strong, nonatomic) NSString *albumID;
@property (strong, nonatomic) NSString *ownerID;
@property (strong, nonatomic) NSString *text;

@property (strong, nonatomic) NSString *urlString_photo_1280;
@property (strong, nonatomic) NSString *urlString_photo_130;
@property (strong, nonatomic) NSString *urlString_photo_604;
@property (strong, nonatomic) NSString *urlString_photo_75;
@property (strong, nonatomic) NSString *urlString_photo_807;

@property (assign, nonatomic) NSInteger likesCount;
@property (assign, nonatomic) NSInteger width;
@property (assign, nonatomic) NSInteger height;

@property (strong, nonatomic) NSDate   *date;


- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
