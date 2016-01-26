//
//  VSMessage.m
//  VS_API_Practice
//
//  Created by Mac on 29.12.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSMessage.h"
#import "VSServerManager.h"
#import "VSUser.h"

@implementation VSMessage

- (instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    self = [super initWithServerResponse:responseObject];
    if (self) {
        self.text    = responseObject[@"body"];
        NSTimeInterval interval = [responseObject[@"date"] doubleValue];
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"dd-MM-yyyy"];
        self.date = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
        self.ownerID = responseObject[@"from_id"];
    }
    return self;
}

@end
