//
//  VSServerObject.h
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VSServerObject : NSObject

- (instancetype) initWithServerResponse:(NSDictionary*) responseObject;
- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
