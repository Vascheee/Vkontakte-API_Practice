//
//  VSAccessToken.h
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VSAccessToken : NSObject

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSDate   *expirationDate;
@property (strong, nonatomic) NSString *userID;

@end

