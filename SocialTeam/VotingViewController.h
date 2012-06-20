//
//  VotingViewController.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickDialogController.h"

@interface VotingViewController : QuickDialogController <QuickDialogEntryElementDelegate>

-(void)favoritePlayer:(QRadioElement *) element;
-(void)favoriteFantaPlayer:(QRadioElement *) element;

@end
