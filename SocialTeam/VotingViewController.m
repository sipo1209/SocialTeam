//
//  VotingViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VotingViewController.h"
#import "DemoHintView.h"

@interface VotingViewController ()

@end

@implementation VotingViewController

-(void) hint
{
    __block DemoHintView* hintView = [DemoHintView  warningHintView];
    
    // Overwrites the pages titles
    hintView.title = NSLocalizedString(@"Come si vota?", @"Titolo del suggerimento per come votare");
    
    hintView.hintID = kHintID_Home;
    /*
     
     [hintView addPageWithtitle:@"Page 1" 
     text:@"We'll show you these little helpers throughout the app. However, you can certainly turn them off if you like." buttonText:@"Turn off hints" 
     buttonAction:^{
     
     [DemoHintView enableHints:NO];
     
     [hintView dismiss];
     }];
     */
    
    [hintView addPageWithTitle:@"Dati Utente" 
                          text:NSLocalizedString(@"Primo suggerimento votazione", @"Primo suggerimento votazione")];
    [hintView addPageWithTitle:@"Impostazioni Privacy" 
                          text:NSLocalizedString(@"Secondo suggerimento votazione", @"Secondo suggerimento votazione")];
    [hintView addPageWithTitle:@"Impostazioni Privacy" 
                          text:NSLocalizedString(@"Terzo suggerimento votazione", @"Terzo suggerimento votazione")];
    //[hintView addPageWithTitle:@"Page 3" image:[UIImage imageNamed:@"touchbee_small.png"]];
    
    [hintView showInView:self.view 
             orientation:kHintViewOrientationBottom 
            presentation:kHintViewPresentationBounce];
}


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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info" 
                                                                              style:UIBarButtonItemStylePlain 
                                                                             target:self 
                                                                             action:@selector(hint)];
    
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
