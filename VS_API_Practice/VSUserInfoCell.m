//
//  VSUserInfoCell.m
//  VS_API_Practice
//
//  Created by Mac on 15.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSUserInfoCell.h"

@implementation VSUserInfoCell




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)writeMessageToUserAction:(UIButton *)sender {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatar.layer.cornerRadius = CGRectGetWidth(self.avatar.frame)/10;
    self.avatar.layer.borderWidth = 1.f;
    self.avatar.layer.borderColor =
    [UIColor colorWithRed:0.5842 green:0.5814 blue:0.5899 alpha:1.0].CGColor;
}


@end
