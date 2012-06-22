//
//  AvatarViewController.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarViewController : UIViewController
{
    UIImageView *avatarImage;
}
@property (nonatomic,strong) IBOutlet UIImageView *avatarImage;

@end
