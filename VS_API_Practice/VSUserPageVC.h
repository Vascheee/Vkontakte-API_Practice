//
//  VSUserPageVC.h
//  VS_API_Practice
//
//  Created by Mac on 14.10.15.
//  Copyright © 2015 VascheeeDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSPhotoAlbumsCell.h"


@interface VSUserPageVC : UITableViewController

@property (strong, nonatomic) NSString *userID;

- (IBAction)goToHomePageAction:(UIBarButtonItem *)sender;
- (IBAction)jumpToTopOfPageAction:(UIBarButtonItem *)sender;

@end
