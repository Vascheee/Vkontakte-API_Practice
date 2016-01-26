//
//  VSMessageVC.m
//  VS_API_Practice
//
//  Created by Mac on 18.12.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import "VSMessageVC.h"
#import "VSDialogCell.h"
#import "VSServerManager.h"
#import "VSMessage.h"
#import "UIKit+AFNetworking.h"
#import "VSUser.h"


@interface VSMessageVC () <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *messageArray;
}

@end

@implementation VSMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageTextView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    messageArray = [NSMutableArray array];
    self.messageTextView.layer.cornerRadius = 6;
    self.messageTextView.layer.borderWidth = 1.f;
    self.messageTextView.layer.borderColor =
    [[UIColor colorWithRed:0.0 green:0.0001 blue:0.3785 alpha:0.61]CGColor];
    [self getChat];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.messageTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)getChat {
    [[VSServerManager sharedManager] getHistoryOfMessagesByUser:self.userID
                                                          limit:50
                                                      onSuccess:^(NSArray *messagesArray) {
                                                          [messageArray addObjectsFromArray:messagesArray];
                                                          [self.tableView reloadData];
                                                          NSLog(@"%ld", (unsigned long)messageArray.count);
                                                      } onFailure:^(NSError *error, NSInteger statusCode) {
                                                      } ];
}

- (void)updateChat {
    [[VSServerManager sharedManager] getHistoryOfMessagesByUser:self.userID
                                                          limit:50
                                                      onSuccess:^(NSArray *messagesArray) {
                                                          [messageArray removeAllObjects];
                                                          [messageArray addObjectsFromArray:messagesArray];
                                                          VSMessage *mess = [messageArray firstObject];
                                                          NSLog(@"%@", mess.text);
                                                          [self.tableView reloadData];
                                                          NSLog(@"%ld", (unsigned long)messageArray.count);
                                                      } onFailure:^(NSError *error, NSInteger statusCode) {
                                                      } ];
}

#pragma mark - UITableViewDataSource
/*=================================================================================================*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"dialogCell";
    
    VSDialogCell *cell = (VSDialogCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    VSMessage *message = messageArray[indexPath.row];
    
    cell.messageTextLabel.text = [NSString stringWithFormat:@"  %@",  message.text];
    cell.messageDateLabel.text = message.date;
    NSString *ownStr = [NSString stringWithFormat:@"%@", message.ownerID];
    NSString *ownID =  [NSString stringWithFormat:@"%@", self.owner.userID];
    if ([ownID isEqualToString:ownStr]) {
        [cell.avatarImage setImageWithURL:[NSURL URLWithString:self.owner.smallImageURLString]];
    } else {
        [cell.avatarImage setImageWithURL:[NSURL URLWithString:self.addressee.smallImageURLString]];

    }
    return cell;
}



#pragma mark - UITableViewDelegate
/*=================================================================================================*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VSMessage *message = messageArray[indexPath.row];
    
    return [VSDialogCell heightForCellByText:message.text forWidth:tableView.frame.size.width - 120];
}


#pragma mark - UITextViewDelegate
/*=================================================================================================*/


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [[VSServerManager sharedManager] sendMessage:textView.text
                                              toUser:self.addressee.userID
                                           onFailure:^(NSError *error, NSInteger statusCode) {
                                               NSLog(@"%@", error);
                                           }];
        textView.text = @"";
        [textView resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateChat];
        });
        return NO;
    }
    
    return YES;
}

- (IBAction)backButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
