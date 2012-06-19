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
    QEntryElement *eta = [[QEntryElement alloc] initWithTitle:@"eta" 
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
    
    NSArray *sex = [[NSArray alloc] initWithObjects:@"M",@"F",@"Other", nil];
    QRadioElement *sesso = [[QRadioElement alloc] initWithItems:sex 
                                                       selected:0 
                                                          title:@"Sesso"];
    sesso.controllerAction = @"selezionaGenere:";
    sesso.value = @"M";
    
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
    
    //divido l'array dei giocatori in base al ruolo
    NSMutableArray *difensori = [[NSMutableArray alloc] init];
    NSMutableArray *centrocampisti = [[NSMutableArray alloc] init];
    NSMutableArray *attaccanti = [[NSMutableArray alloc] init];
    
   //ottengo i cognomi per inizializzare i radio e ordino alfabeticamente gli atleti 
    for (int i = 0; i < rosaSquadra.count; i = i +1) {
        if ([[[rosaSquadra objectAtIndex:i] objectForKey:@"ruolo"] isEqualToString:@"difensore"]) {
            [difensori addObject:[[rosaSquadra objectAtIndex:i] objectForKey:@"cognome"]];
            [difensori sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1 localizedCaseInsensitiveCompare:obj2]) {
                    return [obj1 localizedCaseInsensitiveCompare:obj2];
                }
                return [obj2 localizedCaseInsensitiveCompare:obj1];
            }];
        }
    else if ([[[rosaSquadra objectAtIndex:i] objectForKey:@"ruolo"] isEqualToString:@"centrocampista"]) {
        [centrocampisti addObject:[[rosaSquadra objectAtIndex:i] objectForKey:@"cognome"]];
        [centrocampisti sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([obj1 localizedCaseInsensitiveCompare:obj2]) {
                return [obj1 localizedCaseInsensitiveCompare:obj2];
            }
            return [obj2 localizedCaseInsensitiveCompare:obj1];
        }];
    }
    else {
        [attaccanti addObject:[[rosaSquadra objectAtIndex:i] objectForKey:@"cognome"]];
        [attaccanti sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([obj1 localizedCaseInsensitiveCompare:obj2]) {
                return [obj1 localizedCaseInsensitiveCompare:obj2];
            }
            return [obj2 localizedCaseInsensitiveCompare:obj1];
        }];
    }
    }
    

    ////////////////////////////////////sezione 1///////////////////////////////////
    
    QRadioElement *radioDifensori = [[QRadioElement alloc]initWithItems:difensori
                                                          selected:0
                                                             title:@"Difensore Preferito"];
    
    radioDifensori.controllerAction = @"favoritePlayer:";
    radioDifensori.key = @"favoritePlayer";
   
    
    
    QRadioElement *radioCentroCampisti = [[QRadioElement alloc]initWithItems:centrocampisti
                                                               selected:0
                                                                  title:@"Centrocampista Preferito"];
    
    radioCentroCampisti.controllerAction = @"favoritePlayer:";
    radioCentroCampisti.key = @"favoritePlayer";
    
    QRadioElement *radioAttaccanti = [[QRadioElement alloc]initWithItems:attaccanti
                                                               selected:0
                                                                  title:@"Attaccante Preferito"];
    
    radioAttaccanti.controllerAction = @"favoritePlayer:";
    radioAttaccanti.key = @"favoritePlayer";
    
    
    QSection *section1 = [[QSection alloc] initWithTitle:@"Il tuo FantaTeam"];
   
    [section1 addElement:radioDifensori];
    [section1 addElement:radioCentroCampisti];
    [section1 addElement:radioAttaccanti];
    [root addSection:section1];
    
    ////////////////////////////////////sezione 4///////////////////////////////////
    
    QSection *section2 = [[QSection alloc] initWithTitle:@"Il tuo Fanta Team"];
    NSArray *rosaFantaSquadra = [[NSArray alloc] initWithArray:[CaricaSquadre rosaFantaSquadra]];
    //divido l'array dei giocatori in base al ruolo
    NSMutableArray *fantaDifensori = [[NSMutableArray alloc] init];
    NSMutableArray *fantaCentrocampisti = [[NSMutableArray alloc] init];
    NSMutableArray *fantaAttaccanti = [[NSMutableArray alloc] init];
    
    
    //ottengo i cognomi per inizializzare i radio e ordino alfabeticamente gli atleti 
    for (int i = 0; i < rosaFantaSquadra.count; i = i +1) {
        if ([[[rosaFantaSquadra objectAtIndex:i] objectForKey:@"ruolo"] isEqualToString:@"difensore"]) {
            [fantaDifensori addObject:[[rosaFantaSquadra objectAtIndex:i] objectForKey:@"cognome"]];
            [fantaDifensori sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1 localizedCaseInsensitiveCompare:obj2]) {
                    return [obj1 localizedCaseInsensitiveCompare:obj2];
                }
                return [obj2 localizedCaseInsensitiveCompare:obj1];
            }];
        }
        else if ([[[rosaFantaSquadra objectAtIndex:i] objectForKey:@"ruolo"] isEqualToString:@"centrocampista"]) {
            [fantaCentrocampisti addObject:[[rosaFantaSquadra objectAtIndex:i] objectForKey:@"cognome"]];
            [fantaCentrocampisti sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1 localizedCaseInsensitiveCompare:obj2]) {
                    return [obj1 localizedCaseInsensitiveCompare:obj2];
                }
                return [obj2 localizedCaseInsensitiveCompare:obj1];
            }];
        }
        else {
            [fantaAttaccanti addObject:[[rosaFantaSquadra objectAtIndex:i] objectForKey:@"cognome"]];
            [fantaAttaccanti sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1 localizedCaseInsensitiveCompare:obj2]) {
                    return [obj1 localizedCaseInsensitiveCompare:obj2];
                }
                return [obj2 localizedCaseInsensitiveCompare:obj1];
            }];
        }
    }
    
    
    QRadioElement *radioFantaDifensori = [[QRadioElement alloc]initWithItems:fantaDifensori
                                                               selected:0
                                                                  title:@"Difensore Preferito"];
    
    radioFantaDifensori.controllerAction = @"favoriteFantaPlayer:";
    radioFantaDifensori.key = @"favoritePlayer";
    
    
    QRadioElement *radioFantaCentroCampisti = [[QRadioElement alloc]initWithItems:fantaCentrocampisti
                                                                    selected:0
                                                                       title:@"Centrocampista Preferito"];
    
    radioFantaCentroCampisti.controllerAction = @"favoriteFantaPlayer:";
    radioFantaCentroCampisti.key = @"favoritePlayer";
    
    QRadioElement *radioFantaAttaccanti = [[QRadioElement alloc]initWithItems:fantaAttaccanti
                                                                selected:0
                                                                   title:@"Attaccante Preferito"];
    
    radioFantaAttaccanti.controllerAction = @"favoriteFantaPlayer:";
    radioFantaAttaccanti.key = @"favoriteFantaPlayer";
    

    [section2 addElement:radioFantaDifensori];
    [section2 addElement:radioFantaCentroCampisti];
    [section2 addElement:radioFantaAttaccanti];
    
    [root addSection:section2];


    ////////////////////////////////////sezione 3///////////////////////////////////

    QSection *section3 = [[QSection alloc] initWithTitle:@"Privacy"];
    section3.title = @"Impostazioni Privacy";
    QBooleanElement *privacy0 = [[QBooleanElement alloc] initWithTitle:@"Classifiche?" 
                                                            BoolValue:YES];
    privacy0.labelingPolicy = QLabelingPolicyTrimTitle;
    
    QBooleanElement *privacy1 = [[QBooleanElement alloc] initWithTitle:@"Ricezione mail?" 
                                                            BoolValue:YES];
    privacy1.labelingPolicy = QLabelingPolicyTrimTitle;
    privacy0.key = @"booleanPrivacy";
    privacy1.key = @"booleanPrivacy1";
    
    [root addSection:section3];
    [section3 addElement:privacy0];
    [section3 addElement:privacy1];

    return root;
}

@end
