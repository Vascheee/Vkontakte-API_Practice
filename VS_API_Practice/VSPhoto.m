//
//  VSPhoto.m
//  VS_API_Practice
//
//  Created by Mac on 16.11.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSPhoto.h"

@implementation VSPhoto

- (instancetype)initWithServerResponse:(NSDictionary *)responseObject
{
    self = [super initWithServerResponse:responseObject];
    if (self) {
        self.albumID = responseObject[@"album_id"];
        self.ownerID = responseObject[@"owner_id"];
        self.photoID = responseObject[@"id"];
        self.text    = responseObject[@"text"];
        
        self.width   = [responseObject[@"width"]integerValue];
        self.height  = [responseObject[@"height"]integerValue];
        self.likesCount   = [responseObject[@"likes"][@"count"]integerValue];

        self.urlString_photo_1280 = responseObject[@"photo_1280"];
        self.urlString_photo_130  = responseObject[@"photo_130"];
        self.urlString_photo_604  = responseObject[@"photo_604"];
        self.urlString_photo_75   = responseObject[@"photo_75"];
        self.urlString_photo_807  = responseObject[@"photo_807"];
        
    }
    return self;
}


- (instancetype)initWithDictionary:(NSDictionary*)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        
        self.width   = [dict[@"width"]integerValue];
        self.height  = [dict[@"height"]integerValue];
        self.likesCount   = [dict[@"likes"][@"count"]integerValue];
        
        self.ownerID = dict[@"id"];
        self.text    = dict[@"text"];
        
        self.urlString_photo_1280 = dict[@"photo_1280"];
        self.urlString_photo_130  = dict[@"photo_130"];
        self.urlString_photo_604  = dict[@"photo_604"];
        self.urlString_photo_75   = dict[@"photo_75"];
        self.urlString_photo_807  = dict[@"photo_807"];
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"width -%ld, height - %ld, URL - %@",
            (long)self.width, (long)self.height, self.urlString_photo_1280];
}

@end
