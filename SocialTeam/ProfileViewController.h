//
//  ProfileViewController.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickDialogController.h"

@interface ProfileViewController : QuickDialogController <QuickDialogEntryElementDelegate,UIAlertViewDelegate>{
    
    UIView *avatarView;
    UIView *containerView;
    
}
@property (nonatomic,strong) IBOutlet UIView *avatarView;

@property (nonatomic,strong) IBOutlet UIView *containerView;

-(void)favoritePlayer:(QRadioElement *) element;
-(void)favoriteFantaPlayer:(QRadioElement *) element;
-(void)selezionaGenere:(QRadioElement *) element;

@end
