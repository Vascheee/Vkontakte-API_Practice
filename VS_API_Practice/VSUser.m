//
//  VSUser.m
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSUser.h"

@implementation VSUser



- (instancetype) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super initWithServerResponse:responseObject];
    if (self) {
        self.firstName    = responseObject[@"first_name"];
        self.lastName     = responseObject[@"last_name"];
        self.userID       = responseObject[@"user_id"];
        self.nameOfSubscription = responseObject[@"name"];
        if (!self.userID) {
            self.userID   = responseObject[@"uid"];
        }
        if (!self.userID) {
            self.userID   = responseObject[@"id"];
        }
        self.userBirthday = responseObject[@"bdate"];
        self.userOnlain   = responseObject[@"online"];
        self.userCity     = responseObject[@"city"][@"title"];
        
        self.smallImageURLString  = responseObject[@"photo_100"];
        self.bigImageURLString    = responseObject[@"photo_200"];
    }
    return self;
}


-(instancetype) initWithProfile: (NSDictionary *) profileDictionary
{
    self = [super init];
    if (self) {
        self.userID        = profileDictionary[@"id"];
        self.firstName     = profileDictionary[@"first_name"];
        self.lastName      = profileDictionary[@"last_name"];
        self.userOnlain    = profileDictionary[@"online"];
        self.smallImageURLString = profileDictionary[@"photo_100"];
    }
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@. Town - %@. IsOnline - %@.",
            self.firstName, self.lastName, self.userCity, self.userOnlain];
}
@end
