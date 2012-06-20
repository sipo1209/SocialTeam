//
//  ProfileViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"




@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize avatarView,containerView;


//implemento il metodo per la selezione del genere dell'utente
-(void)selezionaGenere:(QRadioElement *) element{
    //prendo l'utente corrente
    PFUser *currentUser = [PFUser currentUser];
    //in base al sesso scrivo i valori su parse
    switch (element.selected) {
        case 0:
            [currentUser setObject:@"M" forKey:@"genere"];
            [currentUser save];
            break;
        case 1:
            [currentUser setObject:@"F" forKey:@"genere"];
            [currentUser save];
            break;
        case 2:
            [currentUser setObject:@"Other" forKey:@"genere"];
            [currentUser save];
            break;
        default:
            break;
    }
}

/*
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
 */
//metodi chiamati alla pressione delle celle del controller

-(void)QEntryDidEndEditingElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell{
    PFUser *user = [PFUser currentUser];
    if ([element.key isEqualToString:@"textFieldNome"]) {
        [user setObject:element.textValue
                 forKey:@"nome"];
        [user save];
        NSLog(@"%@ ",[user objectForKey:@"nome"]);
        [self.quickDialogTableView reloadCellForElements:element, nil];
    }
    else if ([element.key isEqualToString:@"textFieldCognome"]) {
       [user setObject:element.textValue
                 forKey:@"cognome"];
        [user save];
        NSLog(@"%@ ",[user objectForKey:@"cognome"]);
        [self.quickDialogTableView reloadCellForElements:element, nil];
    }
    else if ([element.key isEqualToString:@"textFieldEta"]) {
        [user setObject:element.textValue
                 forKey:@"eta"];
        [user save];
        NSLog(@"%@ ",[user objectForKey:@"eta"]);
        [self.quickDialogTableView reloadCellForElements:element, nil];
    }
    else if ([element.key isEqualToString:@"textFieldCitta"]) {
        [user setObject:element.textValue
                 forKey:@"citta"];
        [user save];
        NSLog(@"%@ ",[user objectForKey:@"citta"]);
        [self.quickDialogTableView reloadCellForElements:element, nil];
    }
    NSLog(@"FINE SCRITTURA");
    return;
}

-(void)QEntryDidBeginEditingElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell{
    NSLog(@"INIZIO SCRITTURA");
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
    //DEFINIZIONE DEL DELEGATO PER OGNUNO DEGLI ELEMENTI DEL FORM DI INSERIMENTO DATI
    ((QEntryElement *)[self.root elementWithKey:@"textFieldNome"]).delegate = self;
    ((QEntryElement *)[self.root elementWithKey:@"textFieldCognome"]).delegate = self;
    ((QEntryElement *)[self.root elementWithKey:@"textFieldEta"]).delegate = self;
    ((QEntryElement *)[self.root elementWithKey:@"textFieldCitta"]).delegate = self;
    
  
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info" 
                                                                              style:UIBarButtonItemStylePlain 
                                                                             target:self 
                                                                             action:@selector(info)];
}
-(void)info{
    NSLog(@"Info Button Tapped");
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
