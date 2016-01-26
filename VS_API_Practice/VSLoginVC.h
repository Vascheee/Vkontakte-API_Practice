//
//  VSLoginVC.h
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSAccessToken;

typedef void(^VSComplitionBlock)(VSAccessToken *token);

@interface VSLoginVC : UIViewController


- (instancetype)initWithComplitionBlock:(VSComplitionBlock)complition;



@end
