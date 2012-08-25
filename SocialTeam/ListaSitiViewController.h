//
//  ListaSitiViewController.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 24/08/12.
//
//

#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>

@interface ListaSitiViewController : PFQueryTableViewController <UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

//metodi per invio mail dall'applicazione o attraverso l'applicazione Mail
-(void)inAppMail;
-(void)openMailApp;

@end
