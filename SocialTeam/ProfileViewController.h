//
//  ProfileViewController.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickDialogController.h"
#import "PhotoPickerPlus.h"

@interface ProfileViewController : QuickDialogController <QuickDialogEntryElementDelegate, PhotoPickerPlusDelegate, UITableViewDelegate, UIGestureRecognizerDelegate, QuickDialogStyleProvider>




-(void)selezionaGenere:(QRadioElement *) element;
-(void)selezioneAvatar:(QLabelElement *) element;


@end
