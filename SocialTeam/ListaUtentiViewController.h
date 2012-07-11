//
//  ListaUtentiViewController.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Parse/Parse.h>

@interface ListaUtentiViewController : PFQueryTableViewController {
    NSArray *tableData;
}

@property(nonatomic,copy,readwrite) NSArray *tableData;

@end
