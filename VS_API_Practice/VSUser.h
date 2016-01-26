//
//  VSUser.h
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSServerObject.h"

@interface VSUser : VSServerObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userBirthday;
@property (strong, nonatomic) NSString *userCity;
@property (strong, nonatomic) NSString *nameOfSubscription;
@property (assign, nonatomic) NSNumber *userOnlain;

@property (strong, nonatomic) NSString    *bigImageURLString;
@property (strong, nonatomic) NSString    *smallImageURLString;

- (instancetype) initWithServerResponse:(NSDictionary*) responseObject;
- (instancetype) initWithProfile: (NSDictionary *) profileDictionary;

@end
