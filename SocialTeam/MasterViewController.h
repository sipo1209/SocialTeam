//
//  MasterViewController.h
//  Prova
//
//  Created by Luca Gianneschi on 24/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@class DetailViewController;

@interface MasterViewController : UITableViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
