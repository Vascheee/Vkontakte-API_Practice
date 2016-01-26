//
//  VSAccessToken.m
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSAccessToken.h"

@implementation VSAccessToken

- (NSString *)description
{
    return [NSString stringWithFormat:@"Token - %@, date - %@", self.token, self.expirationDate];
}

@end
