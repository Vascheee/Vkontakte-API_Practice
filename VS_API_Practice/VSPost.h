//
//  VSPost.h
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//


#import "VSServerObject.h"

typedef NS_ENUM(unsigned int, PostContentType) {
    PostContentType_OnlyText,
    PostContentType_OnlyPhoto,
    PostContentType_TextWithFotos,
    
    PostContentTypeRepost_OnlyText,
    PostContentTypeRepost_OnlyPhoto,
    PostContentTypeRepost_TextWithFotos,
};

@class VSUser;
@class VSGroup;
@class VSPhoto;

@interface VSPost : VSServerObject

@property (strong, nonatomic) VSUser    *fromUser;
@property (strong, nonatomic) VSGroup   *fromGroup;
@property (strong, nonatomic) VSUser    *repostFromUser;
@property (strong, nonatomic) VSGroup   *repostFromGroup;
@property (strong, nonatomic) VSPhoto   *imageInPost;


@property (strong, nonatomic) NSString  *text;
@property (strong, nonatomic) NSString  *date;
@property (strong, nonatomic) NSString  *postImageURL;
@property (strong, nonatomic) NSString  *videoImageURL;
@property (strong, nonatomic) NSString  *videofileName;

@property (strong, nonatomic) NSString  *repostOwnerImageString;
@property (strong, nonatomic) NSString  *repostOwnerID;
@property (strong, nonatomic) NSString  *fromUserID;
@property (strong, nonatomic) NSString  *postID;
@property (strong, nonatomic) NSString  *ownerID;

@property (nonatomic, assign) NSString *postType;
@property (strong, nonatomic) NSMutableArray *photoArrayInPost;

@property (assign, nonatomic) NSInteger  likeCount;
@property (assign, nonatomic) NSInteger  commentCount;

@property (assign, nonatomic) NSInteger postImageHeight;
@property (assign, nonatomic) NSInteger postImageWidth;

@property (assign, nonatomic) BOOL      likeAllow;
@property (assign, nonatomic) BOOL      isRepostingRecord;




@end
