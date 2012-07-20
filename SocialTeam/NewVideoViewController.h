//
//  NewVideoViewController.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 20/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PullToRefreshTableViewController.h"
#import <UIKit/UIKit.h>

@interface NewVideoViewController : PullToRefreshTableViewController{
    NSMutableArray *objects;
    NSArray *titoli;
    NSArray *sottotitoli;
}

@property (nonatomic,strong) NSMutableArray *objects;
@property (nonatomic,strong) NSArray *titoli;
@property (nonatomic,strong) NSArray *sottotitoli;

@end
