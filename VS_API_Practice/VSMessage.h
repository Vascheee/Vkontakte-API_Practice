//
//  VSMessage.h
//  VS_API_Practice
//
//  Created by Mac on 29.12.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSServerObject.h"
@class VSUser;
@interface VSMessage : VSServerObject

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *ownerID;
@property (strong, nonatomic) NSString *date;

- (instancetype) initWithServerResponse:(NSDictionary*) responseObject;

@end
