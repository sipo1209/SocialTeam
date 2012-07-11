//
//  UserListViewController.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 02/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Parse/Parse.h>


@class AbstractActionSheetPicker;

@interface UserListViewController : PFQueryTableViewController <MBProgressHUDDelegate>{
    NSArray *pickerTitles;
    MBProgressHUD *HUD;
    
    
}

@property (nonatomic, retain) AbstractActionSheetPicker *actionSheetPicker;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)ordinaUtenti:(id)sender;
- (void)texFieldTapped:(UIBarButtonItem *)sender;

@end
