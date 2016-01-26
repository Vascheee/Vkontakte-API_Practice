//
//  VSGroup.h
//  VS_API_Practice
//
//  Created by Mac on 02.11.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSServerObject.h"

@interface VSGroup : VSServerObject

@property (strong,nonatomic) NSString *descriptionGroup;
@property (strong,nonatomic) NSString *groupID;
@property (strong,nonatomic) NSString *statusString;
@property (strong,nonatomic) NSString *smallPhotoStringUrl;
@property (strong,nonatomic) NSString *bigPhotoStringUrl;
@property (strong,nonatomic) NSString *nameGroup;
@property (strong,nonatomic) NSString *membersCount;
@property (strong,nonatomic) NSString *albumsGroup;
@property (strong,nonatomic) NSString *audiosGroup;
@property (strong,nonatomic) NSString *docsGroup;
@property (strong,nonatomic) NSString *photosGroup;
@property (strong,nonatomic) NSString *topicsGroup;
@property (strong,nonatomic) NSString *videosGroup;


- (instancetype) initWithServerResponse:(NSDictionary*) responseObject;
- (instancetype) initWithGroupProfile: (NSDictionary *) profileDictionary;

@end
