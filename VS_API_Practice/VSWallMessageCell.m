//
//  VSWallMessageCell.m
//  VS_API_Practice
//
//  Created by Mac on 24.11.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSWallMessageCell.h"
#import "VSServerManager.h"
#import "VSUserPageVC.h"

@implementation VSWallMessageCell



#pragma mark - UITextFieldDelegate
/*=================================================================================================*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - Actions
/*=================================================================================================*/

- (IBAction)sendMessageAction:(UIButton *)sender {
    
 
    [[VSServerManager sharedManager]postTextOnWall:self.messageTextField.text
                                       wallOwnerID:self.ownerID
                                           inGroup:self.isGroup
                                         onFailure:^(NSError *error, NSInteger statusCode) {
                                             NSLog(@"Error - %@. StatusCode -%ld", error, (long)statusCode);
                                         }];
    self.messageTextField.text = @"";
    
    if ([self.delegate respondsToSelector:@selector(showNewWallPost)]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate showNewWallPost];
        });
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
