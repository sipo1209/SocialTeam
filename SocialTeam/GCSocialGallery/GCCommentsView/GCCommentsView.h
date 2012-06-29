//
//  GCCommentsView.h
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetChute.h"

@interface GCCommentsView : GCUIBaseViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) GCAsset *asset;
@property (nonatomic, retain) GCChute *chute;
@property (nonatomic, retain) NSArray *comments;
@property (nonatomic, readonly) IBOutlet UITableView *commentTable;
@property (nonatomic, readonly) IBOutlet UITextField *addCommentField;
@property (nonatomic, readonly) IBOutlet UIView *commentArea;

-(void)reloadComments;
-(IBAction)postComment;
-(UIView*)viewForCommentAtIndexPath:(NSIndexPath*)indexPath;

@end
