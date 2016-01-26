//
//  VSUserPhotoAlbum.m
//  VS_API_Practice
//
//  Created by Mac on 28.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSUserPhotoAlbum.h"

@implementation VSUserPhotoAlbum

- (instancetype)initWithServerResponse:(NSDictionary *)responseObject
{
    self = [super initWithServerResponse:responseObject];
    if (self) {
        self.albumID             = responseObject[@"id"];
        self.ownerID             = responseObject[@"owner_id"];
        self.titlePhotoUrlString = responseObject[@"thumb_src"];
        self.photoCount          = responseObject[@"size"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"albumID - %@, count - %@, titlePhoto String - %@",
            self.albumID, self.photoCount, self.titlePhotoUrlString];
}

@end
