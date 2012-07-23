//
//  CommentListViewController.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Parse/Parse.h>

@interface CommentListViewController : PFQueryTableViewController
@property (nonatomic,strong) PFObject *oggettoCommentato;

@end
