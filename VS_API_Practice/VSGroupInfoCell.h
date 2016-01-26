//
//  VSGroupInfoCell.h
//  VS_API_Practice
//
//  Created by Mac on 17.11.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSGroupInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *membersCountLabel;


- (IBAction)membersGetAction:(UIButton *)sender;

@end
