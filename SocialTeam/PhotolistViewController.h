//
//  PhotolistViewController.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 14/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PhotoPickerPlus.h"

@interface PhotolistViewController : UIViewController <UINavigationControllerDelegate, MBProgressHUDDelegate, UIAlertViewDelegate, PhotoPickerPlusDelegate,UIScrollViewDelegate>
{
    IBOutlet UIScrollView *photoScrollView;
    IBOutlet UIToolbar *toolBar;
    NSMutableArray *allImages;
    
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
}


- (void)refresh:(id)sender;

@end
