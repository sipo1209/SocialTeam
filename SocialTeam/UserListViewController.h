//
//  UserListViewController.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 02/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Parse/Parse.h>

@interface UserListViewController : PFQueryTableViewController  <UIPickerViewDelegate, UIPickerViewDataSource>{
    UIPickerView *picker;
    NSArray *pickerTitles;
}
  

@end
