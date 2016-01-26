//
//  VSVideo.m
//  VS_API_Practice
//
//  Created by Mac on 12.01.16.
//  Copyright © 2016 VascheeeDevelopment. All rights reserved.
//

#import "VSVideo.h"

@implementation VSVideo

- (instancetype)initWithServerResponse:(NSDictionary *)responseObject
{
    self = [super initWithServerResponse:responseObject];
    if (self) {
        self.titleImageURL  = responseObject[@"photo_604"];
        self.title    = responseObject[@"title"];

    }
    return self;
}

@end
