//
//  VSDialogCell.h
//  VS_API_Practice
//
//  Created by Mac on 26.12.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSDialogCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageDateLabel;


+ (CGFloat)heightForCellByText:(NSString*)text forWidth:(NSInteger)width;

@end
