//
//  ImpostaProfilo.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImpostaProfilo.h"

@implementation ImpostaProfilo

+ (QRootElement *)impostaRoot{
    //prendo i dati dell'utente corrente
    PFUser *currentUser = [PFUser currentUser];
    
    //imposto il root, poi ne definisco gli elementi e alla fine ritorno il root
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"Il tuo profilo";
    root.grouped = YES;
    
    
    ////////////////////////////////////sezione 0///////////////////////////////////
    ///assegnare una chiave ad ogni element//////////
    QSection *section = [[QSection alloc] init];
    section.title = @"Dati Account";
    
    QLabelElement *nomeUtente = [[QLabelElement alloc] initWithTitle:@"Username" 
                                                               Value:currentUser.username];
    
    QLabelElement *email = [[QLabelElement alloc] initWithTitle:@"Email:" 
                                                          Value:currentUser.email];
    
    
    QEntryElement *citta = [[QEntryElement alloc] initWithTitle:@"La tua Citta" 
                                                          Value:nil 
                                                    Placeholder:nil];
    citta.textValue = nil;
    
    citta.autocorrectionType = UITextAutocorrectionTypeNo;
    citta.key = @"entryElement";
    
    NSArray *sex = [[NSArray alloc] initWithObjects:@"M",@"F", nil];
    QRadioElement *sesso = [[QRadioElement alloc] initWithItems:sex 
                                                       selected:0 
                                                          title:@"Sesso"];

       
    [root addSection:section];
    [section addElement:nomeUtente];
    [section addElement:email];
    [section addElement:sesso];
    [section addElement:citta];
    

    ////////////////////////////////////sezione 1///////////////////////////////////
    ///assegnare una chiave ad ogni element//////////

    QSection *section1 = [[QSection alloc] init];
    section1.title = @"La tua Squadra";
    QEntryElement *giocatorePreferito = [[QEntryElement alloc] initWithTitle:@"Giocatore Preferito" 
                                                                       Value:nil 
                                                                 Placeholder:@"scrivilo qui"];
    QEntryElement *allenatorePreferito = [[QEntryElement alloc] initWithTitle:@"Allenatore Preferito" 
                                                                        Value:nil 
                                                                  Placeholder:@"scrivilo qui"];
    
    [root addSection:section1];
    [section1 addElement:giocatorePreferito];
    [section1 addElement:allenatorePreferito];

    return root;
}

@end
