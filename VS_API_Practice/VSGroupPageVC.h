//
//  VSGroupPageVC.h
//  VS_API_Practice
//
//  Created by Mac on 17.11.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSGroupPageVC : UITableViewController

@property (strong, nonatomic) NSString *groupID;


- (IBAction)jumpToTopOfPageAction:(UIBarButtonItem *)sender;

@end
