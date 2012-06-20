//
//  CaricaSquadre.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 17/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CaricaSquadre.h"

@implementation CaricaSquadre

//questi metodi devono diventare metodi in background

+(NSArray *)rosaSquadra{
    NSArray *rosaSquadra = [[NSArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Player"];
    [query whereKey:@"rosa" equalTo:@"true"];
    rosaSquadra = [query findObjects];
    return rosaSquadra;
}

+(NSArray *)rosaFantaSquadra{
    NSArray *rosaFantaSquadra = [[NSArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Player"];
    [query whereKey:@"HOF" equalTo:@"Y"];
    rosaFantaSquadra = [query findObjects];
    return rosaFantaSquadra;
}

@end
