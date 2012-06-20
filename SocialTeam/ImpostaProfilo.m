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


+(QSection *)createFirstSection{
    //prendo i dati dell'utente corrente
    PFUser *currentUser = [PFUser currentUser];

    QSection *section = [[QSection alloc] init];
    section.title = @"Dati Account";
    
    //IMPOSTAZIONE DATI DA USARE NEI FORM
    NSString *nomeUtenteParse = [currentUser objectForKey:@"nome"];
    NSString *cognomeUtenteParse = [currentUser objectForKey:@"cognome"];
    NSString * etaUtenteParse = [currentUser objectForKey:@"eta"];
    NSString *cittaUtente = [currentUser objectForKey:@"citta"];
    NSArray *sex = [[NSArray alloc] initWithObjects:@"M",@"F",@"Other", nil];
    
    //DEFINIZIONE DEGLI ELEMENTI DA MOSTRARE NEL FORM
    //PRENDO IL NOME UTENTE DA PARSE/// NON MODIFICABILE
    QLabelElement *nomeUtente = [[QLabelElement alloc] initWithTitle:@"Username" 
                                                               Value:currentUser.username];
    
    QEntryElement *nome = [[QEntryElement alloc] initWithTitle:@"Nome" 
                                                         Value:nomeUtenteParse
                                                   Placeholder:@"scrivi qui"];
    
    QEntryElement *cognome = [[QEntryElement alloc] initWithTitle:@"Cognome" 
                                                            Value:cognomeUtenteParse
                                                      Placeholder:@"scrivi qui"];
   
    QEntryElement *eta = [[QEntryElement alloc] initWithTitle:@"eta" 
                                                        Value:etaUtenteParse 
                                                  Placeholder:@"scrivi qui"];
    
    QLabelElement *email = [[QLabelElement alloc] initWithTitle:@"Email:" 
                                                          Value:currentUser.email];
    
    QEntryElement *citta = [[QEntryElement alloc] initWithTitle:@"La tua Citta" 
                                                          Value:cittaUtente
                                                    Placeholder:@"scrivi qui"];
    
    QRadioElement *sesso = [[QRadioElement alloc] initWithItems:sex 
                                                       selected:0 
                                                          title:@"Sesso"];
    
    //definizione di valori e azioni
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
    [section addElement:nomeUtente];
    [section addElement:nome];
    [section addElement:cognome];
    [section addElement:email];
    [section addElement:eta];
    [section addElement:sesso];
    [section addElement:citta];
    
    return section;
    
}

+(QSection *)createSecondSection{
    QSection *section = [[QSection alloc] init];
    section.title = @"Impostazioni Privacy";

    QBooleanElement *privacy0 = [[QBooleanElement alloc] initWithTitle:@"Classifiche?" 
                                                             BoolValue:YES];
    
    
    QBooleanElement *privacy1 = [[QBooleanElement alloc] initWithTitle:@"Ricezione mail?" 
                                                             BoolValue:YES];
    privacy0.labelingPolicy = QLabelingPolicyTrimTitle; 
    privacy1.labelingPolicy = QLabelingPolicyTrimTitle;
    privacy0.key = @"booleanPrivacy";
    privacy1.key = @"booleanPrivacy1";
    
    [section addElement:privacy0];
    [section addElement:privacy1];
    return section;

}

+(QRootElement *)inizializzazioneForm{
    //imposto il root, poi ne definisco gli elementi e alla fine ritorno il root
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"Il tuo profilo";
    root.grouped = YES;
    [root addSection:[self createFirstSection]];
    [root addSection:[self createSecondSection]];
    [root addSection:[self squadraSection]];
    [root addSection:[self sectionFantaSquadra]];
    return root;
    
}

+(QSection *)squadraSection{
    QSection *section = [[QSection alloc] init];
    section.title = @"Scegli i tuoi giocatori preferiti";
    //ESTRAGGO DAI DATI DI PARSE LA ROSA E POI FACCIO SCEGLIERE ALL'UTENTE CHI E' TRA I PREFERITI
    //carico i dati da parse, per il momento non in background
    
    NSArray *rosaSquadra = [[NSArray alloc] initWithArray:[CaricaSquadre rosaSquadra]];
    //divido l'array dei giocatori in base al ruolo
    NSMutableArray *portieri = [[NSMutableArray alloc] init];
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
        else if ([[[rosaSquadra objectAtIndex:i] objectForKey:@"ruolo"] isEqualToString:@"attaccante"]){
            [attaccanti addObject:[[rosaSquadra objectAtIndex:i] objectForKey:@"cognome"]];
            [attaccanti sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1 localizedCaseInsensitiveCompare:obj2]) {
                    return [obj1 localizedCaseInsensitiveCompare:obj2];
                }
                return [obj2 localizedCaseInsensitiveCompare:obj1];
            }];
        }
        else {
            [portieri addObject:[[rosaSquadra objectAtIndex:i] objectForKey:@"cognome"]];
            [portieri sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1 localizedCaseInsensitiveCompare:obj2]) {
                    return [obj1 localizedCaseInsensitiveCompare:obj2];
                }
                return [obj2 localizedCaseInsensitiveCompare:obj1];
            }];
        }
    }
    
    //ADESSO SETTO LA SEZIONE
    
    //AGGIUNGI I PORTIERI
    QRadioElement *radioPortieri = [[QRadioElement alloc] initWithItems:portieri 
                                                               selected:0 
                                                                  title:@"Portiere Preferito"];
    radioPortieri.controllerAction = @"favoritePlayer:";
    radioPortieri.key =@"favoriteGoalkeeper";
    
    QRadioElement *radioDifensori = [[QRadioElement alloc]initWithItems:difensori
                                                               selected:0
                                                                  title:@"Difensore Preferito"];
    
    radioDifensori.controllerAction = @"favoritePlayer:";
    radioDifensori.key = @"favoriteDefender";
    
    
    
    QRadioElement *radioCentroCampisti = [[QRadioElement alloc]initWithItems:centrocampisti
                                                                    selected:0
                                                                       title:@"Centrocampista Preferito"];
    
    radioCentroCampisti.controllerAction = @"favoritePlayer:";
    radioCentroCampisti.key = @"favoriteMidfielder";
    
    QRadioElement *radioAttaccanti = [[QRadioElement alloc]initWithItems:attaccanti
                                                                selected:0
                                                                   title:@"Attaccante Preferito"];
    
    radioAttaccanti.controllerAction = @"favoritePlayer:";
    radioAttaccanti.key = @"favoriteStriker";
    
    [section addElement:radioPortieri];
    [section addElement:radioDifensori];
    [section addElement:radioCentroCampisti];
    [section addElement:radioAttaccanti];
    return  section;
}

+(QSection *)sectionFantaSquadra{
    QSection *section = [[QSection alloc] initWithTitle:@"Il tuo Fanta Team"];
    NSArray *rosaFantaSquadra = [[NSArray alloc] initWithArray:[CaricaSquadre rosaFantaSquadra]];
    //divido l'array dei giocatori in base al ruolo
    NSMutableArray *fantaPortieri = [[NSMutableArray alloc] init];
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
        else if([[[rosaFantaSquadra objectAtIndex:i] objectForKey:@"ruolo"] isEqualToString:@"attaccante"]){
            [fantaAttaccanti addObject:[[rosaFantaSquadra objectAtIndex:i] objectForKey:@"cognome"]];
            [fantaAttaccanti sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1 localizedCaseInsensitiveCompare:obj2]) {
                    return [obj1 localizedCaseInsensitiveCompare:obj2];
                }
                return [obj2 localizedCaseInsensitiveCompare:obj1];
            }];
        }else {
            [fantaPortieri addObject:[[rosaFantaSquadra objectAtIndex:i] objectForKey:@"cognome"]];
            [fantaPortieri sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1 localizedCaseInsensitiveCompare:obj2]) {
                    return [obj1 localizedCaseInsensitiveCompare:obj2];
                }
                return [obj2 localizedCaseInsensitiveCompare:obj1];
            }];
        }
    }
    
    //AGGIUNGI I PORTIERI    
    QRadioElement *radioFantaPortieri = [[QRadioElement alloc] initWithItems:fantaPortieri 
                                                                    selected:0 
                                                                       title:@"Portiere Preferito"];
   
    
    
    QRadioElement *radioFantaDifensori = [[QRadioElement alloc]initWithItems:fantaDifensori
                                                                    selected:0
                                                                       title:@"Difensore Preferito"];
    
    
    
    
    QRadioElement *radioFantaCentroCampisti = [[QRadioElement alloc]initWithItems:fantaCentrocampisti
                                                                         selected:0
                                                                            title:@"Centrocampista Preferito"];
    

    
    QRadioElement *radioFantaAttaccanti = [[QRadioElement alloc]initWithItems:fantaAttaccanti
                                                                     selected:0
                                                                        title:@"Attaccante Preferito"];
    radioFantaPortieri.controllerAction = @"favoriteFantaPlayer:";
    radioFantaPortieri.key = @"favoriteFantaGoalKeeper";
    radioFantaCentroCampisti.controllerAction = @"favoriteFantaPlayer:";
    radioFantaCentroCampisti.key = @"favoriteFantaMidfielder";
    radioFantaAttaccanti.controllerAction = @"favoriteFantaPlayer:";
    radioFantaAttaccanti.key = @"favoriteFantaStriker";
    radioFantaDifensori.controllerAction = @"favoriteFantaPlayer:";
    radioFantaDifensori.key = @"favoriteFantaDefender";
    
    [section addElement:radioFantaPortieri];
    [section addElement:radioFantaDifensori];
    [section addElement:radioFantaCentroCampisti];
    [section addElement:radioFantaAttaccanti];
    return section;
}

+(QRootElement *)inizializzazioneSquadre{
    //imposto il root, poi ne definisco gli elementi e alla fine ritorno il root
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"Scegli i tuoi giocatori preferiti";
    root.grouped = YES;
    [root addSection:[self squadraSection]];
    [root addSection:[self sectionFantaSquadra]];
    return root;
}

@end
