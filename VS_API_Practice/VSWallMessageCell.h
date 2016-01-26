//
//  VSWallMessageCell.h
//  VS_API_Practice
//
//  Created by Mac on 24.11.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VSWallMessageCellProtocol <NSObject>

- (void) showNewWallPost;

@end

@interface VSWallMessageCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic  ) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic  ) IBOutlet UILabel     *postsCountLabel;
@property (strong, nonatomic) NSString    *ownerID;
@property (assign, nonatomic) BOOL        isGroup;
@property (weak, nonatomic) id<VSWallMessageCellProtocol> delegate;


- (IBAction)sendMessageAction:(UIButton *)sender;

@end
