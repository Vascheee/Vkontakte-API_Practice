//
//  VSMessageVC.h
//  VS_API_Practice
//
//  Created by Mac on 18.12.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSUser.h"

@interface VSMessageVC : UIViewController

@property (strong, nonatomic) VSUser *addressee;
@property (strong, nonatomic) VSUser *owner;

@property (strong, nonatomic) NSString *userID;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backButtonAction:(UIButton *)sender;

@end
