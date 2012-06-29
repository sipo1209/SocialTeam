//
//  GCShareView.h
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetChute.h"
#import <MessageUI/MessageUI.h>


@interface GCShareView : GCUIBaseViewController <MFMailComposeViewControllerDelegate>{
    id sharedItem;
    IBOutlet UIView *choiceView;
    IBOutlet UILabel *shareLabel;
    IBOutlet UIView *shareView;
    IBOutlet UIWebView *shareWebView;
}
@property (nonatomic, retain) id sharedItem;

-(IBAction)WebViewBackClicked:(id)sender;
-(IBAction)closeClicked:(id)sender;
-(IBAction)emailClicked:(id)sender;
-(IBAction)facebookClicked:(id)sender;
-(IBAction)twitterClicked:(id)sender;

-(void)showChoices;
-(void)hideChoices;
-(void)closeView;
-(void)showView;
-(void)showWebView;
-(void)hideWebView;

-(NSString*)linkEmailMessage;
-(NSString*)linkEmailSubject;
-(NSString*)linkFacebookMessage;
-(NSString*)linkTwitterMessage;
-(NSString*)assetEmailMessage;
-(NSString*)assetEmailSubject;
-(NSString*)assetFacebookMessage;
-(NSString*)assetTwitterMessage;
-(NSString*)chuteEmailMessage;
-(NSString*)chuteEmailSubject;
-(NSString*)chuteFacebookMessage;
-(NSString*)chuteTwitterMessage;
-(NSString*)parcelEmailMessage;
-(NSString*)parcelEmailSubject;
-(NSString*)parcelFacebookMessage;
-(NSString*)parcelTwitterMessage;


@end
