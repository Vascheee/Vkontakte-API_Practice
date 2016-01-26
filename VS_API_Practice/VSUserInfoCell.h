//
//  VSUserInfoCell.h
//  VS_API_Practice
//
//  Created by Mac on 15.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSUserInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineIndicatorLabel;



- (IBAction)writeMessageToUserAction:(UIButton *)sender;

@end
