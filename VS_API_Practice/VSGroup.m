//
//  VSGroup.m
//  VS_API_Practice
//
//  Created by Mac on 02.11.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSGroup.h"

@implementation VSGroup


- (instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    self = [super init];
    if (self) {
        self.descriptionGroup = responseObject[@"description"];
        self.nameGroup        = responseObject[@"name"];
        self.groupID          = responseObject[@"id"];
        self.statusString     = responseObject[@"status"];
        self.membersCount     = responseObject[@"members_count"];
        self.smallPhotoStringUrl = responseObject[@"photo_100"];
        self.bigPhotoStringUrl   = responseObject[@"photo_200"];
    }
    return self;
}


- (instancetype) initWithGroupProfile: (NSDictionary *) profileDictionary {
    self = [super init];
    if (self) {
        self.nameGroup   = profileDictionary[@"name"];
        self.groupID     = profileDictionary[@"id"];
        self.smallPhotoStringUrl = profileDictionary[@"photo_100"];
    }
    return self;
}

@end
