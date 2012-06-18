//
//  ImpostaProfilo.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImpostaProfilo.h"
#import "CaricaSquadre.h"

@implementation ImpostaProfilo
@synthesize rosa;

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
    //PRENDO IL NOME UTENTE DA PARSE/// NON MODIFICABILE
    QLabelElement *nomeUtente = [[QLabelElement alloc] initWithTitle:@"Username" 
                                                               Value:currentUser.username];
    
    //PRENDO IL NOME DA PARSE, SE NON ESISTE E' NIL E QUINDI SI MOSTRA IL PLACEHOLDER
    NSString *nomeUtenteParse = [currentUser objectForKey:@"nome"];
    
    
    QEntryElement *nome = [[QEntryElement alloc] initWithTitle:@"Nome" 
                                                         Value:nomeUtenteParse
                                                   Placeholder:@"scrivi qui"];
    
    
     //PRENDO IL COGNOME DA PARSE, SE NON ESISTE E' NIL E QUINDI SI MOSTRA IL PLACEHOLDER
    NSString *cognomeUtenteParse = [currentUser objectForKey:@"cognome"];
    
    
    QEntryElement *cognome = [[QEntryElement alloc] initWithTitle:@"Cognome" 
                                                            Value:cognomeUtenteParse
                                                      Placeholder:@"scrivi qui"];
    NSString * etaUtenteParse = [currentUser objectForKey:@"eta"];


     //PRENDO L'ETA' DA PARSE
    QDecimalElement *eta = [[QDecimalElement alloc] initWithTitle:@"eta" 
                                                            Value:etaUtenteParse 
                                                      Placeholder:@"scrivi qui"];
    
     //PRENDO LA MAIL DA PARSE, NON MODIFICABILE
    QLabelElement *email = [[QLabelElement alloc] initWithTitle:@"Email:" 
                                                          Value:currentUser.email];
    
    //PRENDO IL COGNOME DA PARSE, SE NON ESISTE E' NIL E QUINDI SI MOSTRA IL PLACEHOLDER
    NSString *cittaUtente = [currentUser objectForKey:@"citta"];
    
    QEntryElement *citta = [[QEntryElement alloc] initWithTitle:@"La tua Citta" 
                                                          Value:cittaUtente
                                                    Placeholder:@"scrivi qui"];
    
    NSArray *sex = [[NSArray alloc] initWithObjects:@"M",@"F", nil];
    QRadioElement *sesso = [[QRadioElement alloc] initWithItems:sex 
                                                       selected:0 
                                                          title:@"Sesso"];
    
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

    
    //ESTRAGGO DAI DATI DI PARSE LA ROSA E POI FACCIO SCEGLIERE ALL'UTENTE CHI E' TRA I PREFERITI
    //carico i dati da parse, per il momento non in background
    NSArray *rosaSquadra = [[NSArray alloc] initWithArray:[CaricaSquadre rosaSquadra]];
    //estraggo i cognomi
    NSMutableArray *listaNomiRosa = [[NSMutableArray alloc] init];
    for (int i = 0; i < rosaSquadra.count; i = i +1) {
        [listaNomiRosa addObject:[[rosaSquadra objectAtIndex:i] objectForKey:@"cognome"]];
    }
    
    ////////////////////////////////////sezione 1///////////////////////////////////
    
    QRadioSection *radioSection = [[QRadioSection alloc] initWithItems:listaNomiRosa 
                                   selected:0
                                   title:@"FantaTeam"];
    radioSection.multipleAllowed = YES;
    
    [root addSection:radioSection];

    QSection *section2 = [[QSection alloc] initWithTitle:@"Privacy"];
    section2.title = @"Impostazioni Privacy";
    QBooleanElement *privacy0 = [[QBooleanElement alloc] initWithTitle:@"Classifiche?" 
                                                            BoolValue:YES];
    privacy0.labelingPolicy = QLabelingPolicyTrimTitle;
    
    QBooleanElement *privacy1 = [[QBooleanElement alloc] initWithTitle:@"Ricezione mail?" 
                                                            BoolValue:YES];
    privacy1.labelingPolicy = QLabelingPolicyTrimTitle;
    privacy0.key = @"booleanPrivacy";
    privacy1.key = @"booleanPrivacy1";
    
    [root addSection:section2];
    [section2 addElement:privacy0];
    [section2 addElement:privacy1];

    return root;
}

@end
