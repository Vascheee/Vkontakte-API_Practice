//
//  VSUserConnectionsCell.h
//  VS_API_Practice
//
//  Created by Mac on 21.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSUserConnectionsCell : UITableViewCell


- (IBAction)getFriendsAction:(UIButton *)sender;
- (IBAction)getGroupsAction:(UIButton *)sender;
- (IBAction)getSubscriptionsAction:(UIButton *)sender;
- (IBAction)getFollowersAction:(UIButton *)sender;

@end
