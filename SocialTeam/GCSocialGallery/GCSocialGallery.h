//
//  GCSocialGallery.h
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCCloudGallery.h"
#import "GCCommentsView.h"
#import "GCShareView.h"
#import "GetChute.h"

@interface GCSocialGallery : GCCloudGallery

@property (nonatomic, readonly) IBOutlet UIButton *heartedButton;
@property (nonatomic, retain) GCChute *chute;
@property (nonatomic, retain) GCShareView *shareView;
@property (nonatomic, retain) GCCommentsView *commentView;
@property (nonatomic, readonly) IBOutlet UIButton *closeCommentsButton;

-(IBAction)heartButtonClicked:(UIButton*)sender;
-(IBAction)commentsButtonClicked:(UIButton*)sender;
-(IBAction)shareButtonClicked:(UIButton*)sender;
-(IBAction)closeCommentsButtonClicked:(UIButton*)sender;

-(void)hideCommentsView;
-(void)showCommentView;
-(void)showShareView;

@end
