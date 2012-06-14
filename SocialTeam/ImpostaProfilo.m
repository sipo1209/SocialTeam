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
    
    
    //DEFINIZIONE DEGLI ELEMENTI DA MOSTRARE NEL FORM
    QLabelElement *nomeUtente = [[QLabelElement alloc] initWithTitle:@"Username" 
                                                               Value:currentUser.username];
    
    QEntryElement *nome = [[QEntryElement alloc] initWithTitle:@"Nome" 
                                                         Value:nil 
                                                   Placeholder:@"scrivi qui"];
    
    QEntryElement *cognome = [[QEntryElement alloc] initWithTitle:@"Cognome" 
                                                            Value:nil 
                                                      Placeholder:@"scrivi qui"];
    
    QDecimalElement *eta = [[QDecimalElement alloc] initWithTitle:@"eta" 
                                                            Value:0 
                                                      Placeholder:@"scrivi qui"];
    
    QLabelElement *email = [[QLabelElement alloc] initWithTitle:@"Email:" 
                                                          Value:currentUser.email];
    
    
    QEntryElement *citta = [[QEntryElement alloc] initWithTitle:@"La tua Citta" 
                                                          Value:nil 
                                                    Placeholder:@"scrivi qui"];
    
    NSArray *sex = [[NSArray alloc] initWithObjects:@"M",@"F", nil];
    QRadioElement *sesso = [[QRadioElement alloc] initWithItems:sex 
                                                       selected:0 
                                                          title:@"Sesso"];
    
    //DEFINIZIONE DEI VALORI INIZIALI DEL TESTO
    citta.textValue = nil;
    nome.textValue = nil;
    cognome.textValue = nil;
    
    //DEFINIZIONE DEL COMPORTAMENTO DELLA TASTIERA
    citta.autocorrectionType = UITextAutocorrectionTypeNo;
    nome.autocorrectionType = UITextAutocorrectionTypeNo;
    cognome.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //DEFINIZIONE DELLE CHIAVI PER GLI ELEMENTI EDITABILI DEL FORM
    nome.key = @"textFieldNome";
    cognome.key = @"textFieldCognome";
    eta.key = @"textFieldEta";
    citta.key = @"textFieldCitta";
    sesso.key = @"radioGenere";
    
    //DEFINIZIONE DELLA SEZIONE   
    [root addSection:section];
    [section addElement:nomeUtente];
    [section addElement:nome];
    [section addElement:cognome];
    [section addElement:email];
    [section addElement:eta];
    [section addElement:sesso];
    [section addElement:citta];
    

    ////////////////////////////////////sezione 1///////////////////////////////////

    QSection *section1 = [[QSection alloc] init];
    section1.title = @"La tua Squadra";
    //DEFINIZIONE DEGLI ELEMENTI DA MOSTRARE NEL FORM
    QEntryElement *giocatorePreferito = [[QEntryElement alloc] initWithTitle:@"Giocatore Preferito" 
                                                                       Value:nil 
                                                                 Placeholder:@"scrivilo qui"];
    
    QEntryElement *allenatorePreferito = [[QEntryElement alloc] initWithTitle:@"Allenatore Preferito" 
                                                                        Value:nil 
                                                                  Placeholder:@"scrivilo qui"];
    //DEFINIZIONE DEI VALORI INIZIALI DEL TESTO
    giocatorePreferito.textValue = nil;
    allenatorePreferito.textValue = nil;
    
    //DEFINIZIONE DEL COMPORTAMENTO DELLA TASTIERA
    giocatorePreferito.autocorrectionType = UITextAutocorrectionTypeNo;
    allenatorePreferito.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //DEFINIZIONE DELLE CHIAVI PER GLI ELEMENTI EDITABILI DEL FORM
    giocatorePreferito.key = @"textFieldGiocatore";
    allenatorePreferito.key = @"textFieldAllenatore";
    
    
    [root addSection:section1];
    [section1 addElement:giocatorePreferito];
    [section1 addElement:allenatorePreferito];
    
    QSection *section2 = [[QSection alloc] initWithTitle:@"Privacy"];
    QBooleanElement *privacy = [[QBooleanElement alloc] initWithTitle:@"Vuoi comparire nelle classifiche" 
                                                            BoolValue:YES];
    privacy.key = @"booleanPrivacy";
    [root addSection:section2];
    [section2 addElement:privacy];

    return root;
}

@end
