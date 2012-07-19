//
//  PAWWallPostCreateViewController.h
//  AnyWall
//
//  Created by Christopher Bowns on 1/31/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAWWallPostCreateViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UILabel *characterCount;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *postButton;
@property (nonatomic,assign) BOOL comment;
@property (nonatomic,strong) IBOutlet UINavigationBar *bar;
@property (nonatomic,strong) PFObject *oggettoCommentato;


- (IBAction)cancelPost:(id)sender;
- (IBAction)postPost:(id)sender;

@end
