//
//  ImpostaProfilo.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImpostaProfilo.h"
#import "CaricaSquadre.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileViewController.h"

@implementation ImpostaProfilo



+(QRootElement *)inizializzazioneForm{
    //imposto il root, poi ne definisco gli elementi e alla fine ritorno il root
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"Il tuo profilo";
    root.grouped = YES;
    [root addSection:[self createFirstSection]];
    [root addSection:[self createSecondSection]];
    return root;
}


+(QSection *)createFirstSection{
    //prendo i dati dell'utente corrente
    PFUser *currentUser = [PFUser currentUser];

    QSection *section = [[QSection alloc] init];
    section.title = @"Dati Account";
    
    // qui devi impostare l'avatar
    CGRect frame= CGRectMake(110, 20, 110, 110);
    UIImageView *avatarContainer = [[UIImageView alloc] initWithFrame:frame];
    
     //arrotondo gli spigoli e metto un bordino all'avatar                               
    CALayer *l =[avatarContainer layer];
    l.masksToBounds = YES;
    l.cornerRadius = 5;
    l.borderWidth = 1.5;
    l.borderColor = [[UIColor blackColor] CGColor];
    //imposto la view dell'header della sezione
    section.headerView  = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,150)];


    //se l'utente ha caricato un avatar imposto quello come avatar
    if (![currentUser objectForKey:@"avatar"]) {
        NSLog(@"CARICO PLACEHOLDER");
        avatarContainer.image = [UIImage imageNamed:@"avatarPlaceHolder.png"];
        [section.headerView addSubview:avatarContainer];
        [section.headerView setUserInteractionEnabled:YES];
        [section.headerView bringSubviewToFront:avatarContainer];
    
    }else {
        NSLog(@"CARICO AVATAR");
        //DA FARE
        avatarContainer.image = [UIImage imageNamed:@"avatarPlaceHolder.png"];
        [section.headerView addSubview:avatarContainer];
        [section.headerView setUserInteractionEnabled:YES];
        [section.headerView bringSubviewToFront:avatarContainer];
    }
    //se l'utente non ha caricato l'avatar metti un placeholer

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


@end
