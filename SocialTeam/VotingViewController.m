//
//  VotingViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VotingViewController.h"


@interface VotingViewController ()

@end

@implementation VotingViewController




-(void)favoriteFantaPlayer:(QRadioElement *) element{
    //faccio una query sul giocatore che ha quel cognome 
    PFQuery *queryGiocatore = [PFQuery queryWithClassName:@"Player"];
    [queryGiocatore whereKey:@"cognome" 
                     equalTo:element.selectedItem];
    //eseguo la query
    [queryGiocatore getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error){
            //nel caso di successo della query incremento il valore della variabile voti
            [object incrementKey:@"fantavoti"];
            [object save];
        }else {
            //se la query non ha successo genero un errore
            NSLog(@"Error: %@", [error userInfo]);
        }
    }];
    
}

-(void)favoritePlayer:(QRadioElement *) element{
    //faccio una query sul giocatore che ha quel cognome 
    PFQuery *queryGiocatore = [PFQuery queryWithClassName:@"Player"];
    [queryGiocatore whereKey:@"cognome" 
                     equalTo:element.selectedItem];
    //eseguo la query
    [queryGiocatore getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error){
            //nel caso di successo della query incremento il valore della variabile voti
            [object incrementKey:@"voti"];
            [object save];
        }else {
            //se la query non ha successo genero un errore
            NSLog(@"Error: %@", [error userInfo]);
        }
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
