//
//  VSDialogCell.m
//  VS_API_Practice
//
//  Created by Mac on 26.12.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSDialogCell.h"

@implementation VSDialogCell

- (void)awakeFromNib {
    self.avatarImage.layer.cornerRadius = 25;
    self.messageTextLabel.layer.cornerRadius = 10;
    self.messageTextLabel.clipsToBounds = YES;
    self.avatarImage.clipsToBounds = YES;
    
    float width = [self expectedWidthByText:self.messageTextLabel.text];
    CGRect newFrame = [self frame];
    newFrame.size.width = width;
    [self.messageTextLabel setFrame:newFrame];

}

- (CGFloat)expectedWidthByText:(NSString*)text {
    UIFont *font = [UIFont systemFontOfSize:13];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentNatural;
    
    NSDictionary *attr = @{NSFontAttributeName           : font,
                           NSParagraphStyleAttributeName : style};
    
    CGSize expectedLabelSize =  [text sizeWithAttributes:attr];
    return expectedLabelSize.width;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)heightForCellByText:(NSString*)text forWidth:(NSInteger)width {
    
    UIFont *font = [UIFont systemFontOfSize:13];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentNatural;
    
    NSDictionary *attr = @{NSFontAttributeName           : font,
                           NSParagraphStyleAttributeName : style};
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                  attributes:attr
                                     context:nil];
    return MAX(68, CGRectGetHeight(rect)+23);
}

@end
