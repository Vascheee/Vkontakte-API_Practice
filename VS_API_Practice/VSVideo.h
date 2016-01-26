//
//  VSVideo.h
//  VS_API_Practice
//
//  Created by Mac on 12.01.16.
//  Copyright © 2016 VascheeeDevelopment. All rights reserved.
//

#import "VSServerObject.h"

@interface VSVideo : VSServerObject

@property (strong, nonatomic) NSString *titleImageURL;
@property (strong, nonatomic) NSString *title;


- (instancetype)initWithServerResponse:(NSDictionary *)responseObject;

@end
