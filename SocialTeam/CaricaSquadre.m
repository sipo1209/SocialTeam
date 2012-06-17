//
//  CaricaSquadre.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 17/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CaricaSquadre.h"

@implementation CaricaSquadre


+(NSArray *)rosaSquadra{
    NSArray *rosaSquadra = [[NSArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Player"];
    [query whereKey:@"rosa" equalTo:@"true"];
    rosaSquadra = [query findObjects];
    return rosaSquadra;
}

+(NSArray *)rosaFantaSquadra{
    NSMutableArray *rosaFantaSquadra = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Player"];
    [query whereKey:@"rosa" equalTo:@"false"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
           // [rosaFantaSquadra addObjectsFromArray:objects];
            NSLog(@"Successfully retrieved %d scores.", objects.count);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    NSLog(@"fantarosa %@",[[rosaFantaSquadra objectAtIndex:0] objectForKey:@"cognome"]);
    return rosaFantaSquadra;
    
}

@end
