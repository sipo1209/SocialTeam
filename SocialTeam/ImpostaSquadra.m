//
//  ImpostaSquadra.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImpostaSquadra.h"
#import "CaricaSquadre.h"

@implementation ImpostaSquadra

+(QRootElement *)inizializzazioneSquadre{
    //imposto il root, poi ne definisco gli elementi e alla fine ritorno il root
    QRootElement *root = [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"FantaTeam", @"FantaTeam, titolo sezione");
    root.grouped = YES;
    [root addSection:[self squadraSection]];
    [root addSection:[self sectionFantaSquadra]];
    return root;
}

+(QSection *)squadraSection{
    QSection *section = [[QSection alloc] init];
    section.title = NSLocalizedString(@"Scegli i tuoi giocatori preferiti", @"Scegli i tuoi giocatori preferiti, titolo sezione");
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
                                                                  title:NSLocalizedString(@"Portiere Preferito", @"Portiere Preferito, titolo tabella")];
    radioPortieri.controllerAction = @"favoritePlayer:";
    radioPortieri.key =@"favoriteGoalkeeper";
    
    QRadioElement *radioDifensori = [[QRadioElement alloc]initWithItems:difensori
                                                               selected:0
                                                                  title:NSLocalizedString(@"Difensore Preferito", @"Difensore Preferito, titolo tabella")];
    
    radioDifensori.controllerAction = @"favoritePlayer:";
    radioDifensori.key = @"favoriteDefender";
    
    
    
    QRadioElement *radioCentroCampisti = [[QRadioElement alloc]initWithItems:centrocampisti
                                                                    selected:0
                                                                       title:NSLocalizedString(@"Centrocampista Preferito", @"Centrocampista  Preferito, titolo tabella")];
    
    radioCentroCampisti.controllerAction = @"favoritePlayer:";
    radioCentroCampisti.key = @"favoriteMidfielder";
    
    QRadioElement *radioAttaccanti = [[QRadioElement alloc]initWithItems:attaccanti
                                                                selected:0
                                                                   title:NSLocalizedString(@"Attaccante Preferito", @"Attaccante  Preferito, titolo tabella")];
    
    radioAttaccanti.controllerAction = @"favoritePlayer:";
    radioAttaccanti.key = @"favoriteStriker";
    
    [section addElement:radioPortieri];
    [section addElement:radioDifensori];
    [section addElement:radioCentroCampisti];
    [section addElement:radioAttaccanti];
    return  section;
}

+(QSection *)sectionFantaSquadra{
    QSection *section = [[QSection alloc] initWithTitle:NSLocalizedString(@"Scegli il tuo FantaTeam", @"Scegli il tuo FantaTeam, titolo tabella")];
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
                                                                       title:NSLocalizedString(@"Portiere Preferito", @"Portiere Preferito, titolo tabella FANTATEAM")];
    
    
    
    QRadioElement *radioFantaDifensori = [[QRadioElement alloc]initWithItems:fantaDifensori
                                                                    selected:0
                                                                       title:NSLocalizedString(@"Difensore Preferito", @"Difensore Preferito, titolo tabella FANTATEAM")];
    
    
    
    
    QRadioElement *radioFantaCentroCampisti = [[QRadioElement alloc]initWithItems:fantaCentrocampisti
                                                                         selected:0
                                                                            title:NSLocalizedString(@"Centrocampista Preferito", @"Centrocampista Preferito, titolo tabella FANTATEAM")];
    
    
    
    QRadioElement *radioFantaAttaccanti = [[QRadioElement alloc]initWithItems:fantaAttaccanti
                                                                     selected:0
                                                                        title:NSLocalizedString(@"Attaccante Preferito", @"Attaccante Preferito, titolo tabella FANTATEAM")];
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


@end
