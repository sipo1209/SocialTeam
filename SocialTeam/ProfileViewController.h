//
//  ProfileViewController.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 07/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UITableViewController <UIAlertViewDelegate>{
    NSArray *dati;
    NSArray *labelDati;
    NSString *editDato;
}

@property (nonatomic,strong) NSArray *dati;
@property (nonatomic,strong) NSArray *labelDati;



@end
