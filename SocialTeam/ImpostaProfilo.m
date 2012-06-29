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


@implementation ImpostaProfilo



+(QRootElement *)inizializzazioneForm{
    NSLog(@"inizializza form");
    //imposto il root, poi ne definisco gli elementi e alla fine ritorno il root
    QRootElement *root = [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"Il tuo Profilo", @"Titolo Pagina Profilo");
    root.grouped = YES;
    [root addSection:[self createFirstSection]];
    //metto prima la sezione dedicata alle attivita' nell'APP
    [root addSection:[self createThirSection]];
    [root addSection:[self createSecondSection]];
    return root;
}


+(QSection *)createFirstSection{
    //prendo i dati dell'utente corrente
    PFUser *currentUser = [PFUser currentUser];

    QSection *section = [[QSection alloc] init];
    section.title = NSLocalizedString(@"Dati Account", @"Dati Account, Pagina Profilo");
    
    // qui devi impostare l'avatar
    CGRect frame = CGRectMake(10, 20, 110, 110);
    UIImageView *avatarContainer = [[UIImageView alloc] initWithFrame:frame];
    
    
     //arrotondo gli spigoli e metto un bordino all'avatar                               
    CALayer *l =[avatarContainer layer];
    l.masksToBounds = YES;
    l.cornerRadius = 5;
    l.borderWidth = 1.5;
    l.borderColor = [[UIColor blackColor] CGColor];
    
    //imposto la view dell'header della sezione
    section.headerView  = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,150)];
    [section.headerView setUserInteractionEnabled:YES];
    [section.headerView bringSubviewToFront:avatarContainer];

    //se l'utente ha caricato un avatar imposto quello come avatar
    if (![currentUser objectForKey:@"avatar"]) {
        NSLog(@"CARICO PLACEHOLDER");
         //se l'utente non ha caricato l'avatar metti un placeholer
        avatarContainer.image = [UIImage imageNamed:@"avatarPlaceHolder.png"];
    }else {
        NSLog(@"CARICO AVATAR");
        //prendo l'immagine da PARSE la metto in un file, ne estraggo i dati e poi la imposto nella View
        PFFile *imageFile = [currentUser objectForKey:@"avatar"];
        NSData *immagine = [imageFile getData];
        avatarContainer.image = [UIImage imageWithData:immagine];
    }
    
    [section.headerView addSubview:avatarContainer];
    
    //imposto un pulsante di edit avatar
    
    UIButton *bottone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bottone.frame = CGRectMake(160, 20, 120, 40);
    [section.headerView addSubview:bottone];
    [section.headerView bringSubviewToFront:bottone]; 
   

    //IMPOSTAZIONE DATI DA USARE NEI FORM
    NSString *nomeUtenteParse = [currentUser objectForKey:@"nome"];
    NSString *cognomeUtenteParse = [currentUser objectForKey:@"cognome"];
    NSString *etaUtenteParse = [currentUser objectForKey:@"eta"];
    NSString *cittaUtente = [currentUser objectForKey:@"citta"];
    NSArray *sex = [[NSArray alloc] initWithObjects:@"M",@"F",@"Other", nil];
    NSString *username = currentUser.username;
    NSString *emailUser = currentUser.email;
    
    //DEFINIZIONE DEGLI ELEMENTI DA MOSTRARE NEL FORM
    //PRENDO IL NOME UTENTE DA PARSE/// NON MODIFICABILE
    
    NSString *placeHolder = [[NSString alloc] init];
    placeHolder = NSLocalizedString(@"Scrivi", @"Placeholder per Form");
        
    QEntryElement *nomeUtente = [[QEntryElement alloc] initWithTitle:@"Username" 
                                                               Value:username
                                                         Placeholder:placeHolder];
    
    QEntryElement *nome = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"Nome", @"Nome Tabella Profilo") 
                                                         Value:nomeUtenteParse
                                                   Placeholder:placeHolder];
    
    QEntryElement *cognome = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"Cognome", @"Cognome Tabella Profilo") 
                                                            Value:cognomeUtenteParse
                                                      Placeholder:placeHolder];
    
   
    QEntryElement *eta = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"Eta'", @"Eta' Tabella Profilo")
                                                        Value:etaUtenteParse 
                                                  Placeholder:placeHolder];
    
    QEntryElement *email = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"Email", @"Email Tabella Profilo") 
                                                          Value:emailUser
                                                    Placeholder:placeHolder];
    
    QEntryElement *citta = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"Citta'", @"Citta' Tabella Profilo") 
                                                          Value:cittaUtente
                                                    Placeholder:placeHolder];
    
    
    
    QRadioElement *sesso = [[QRadioElement alloc] initWithItems:sex 
                                                       selected:0 
                                                          title:NSLocalizedString(@"Genere", @"Genere, Tabella Profilo Utente")];
    
    
    //allineamento celle
    

   // QTableViewCell *cellaNome = (QTableViewCell *)nome;
   // cellaNome.detailTextLabel.textAlignment = UITextAlignmentRight;

    //QTableViewCell *cellaCognome = (QTableViewCell *)cognome;
    //cellaCognome.textLabel.textAlignment = UITextAlignmentRight;
    //QTableViewCell *cellaEta = (QTableViewCell *)eta;
    //cellaEta.textLabel.textAlignment = UITextAlignmentRight;
    //QTableViewCell *cellaCitta = (QTableViewCell *)citta;
    //cellaCitta.textLabel.textAlignment = UITextAlignmentRight;
    
    
    //definizione di valori e azioni
    sesso.controllerAction = @"selezionaGenere:";
    sesso.value = [currentUser objectForKey:@"genere"];
    
    //DEFINIZIONE DEL COMPORTAMENTO DELLA TASTIERA
    citta.autocorrectionType = UITextAutocorrectionTypeNo;
    nome.autocorrectionType = UITextAutocorrectionTypeNo;
    cognome.autocorrectionType = UITextAutocorrectionTypeNo;
    
   
    //DEFINIZIONE DELLE CHIAVI PER GLI ELEMENTI EDITABILI DEL FORM
    nomeUtente.key = @"textFieldNomeutente";
    nome.key = @"textFieldNome";
    cognome.key = @"textFieldCognome";
    eta.key = @"textFieldEta";
    citta.key = @"textFieldCitta";
    sesso.key = @"radioGenere";
    email.key = @"textFielEmail";
    
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
    section.title = NSLocalizedString(@"Impostazione Privacy", @"Impostazione Privacy, titolo sezione");

    QBooleanElement *privacy0 = [[QBooleanElement alloc] initWithTitle:NSLocalizedString(@"Classifiche ?", @"Autorizzazione Classifiche") 
                                                             BoolValue:YES];
    
    QBooleanElement *privacy1 = [[QBooleanElement alloc] initWithTitle:NSLocalizedString(@"Ricezione Mail ?", @"Autorizzazione Ricezione Mail")  
                                                             BoolValue:YES];
    privacy0.labelingPolicy = QLabelingPolicyTrimTitle; 
    privacy1.labelingPolicy = QLabelingPolicyTrimTitle;
    privacy0.key = @"booleanPrivacy";
    privacy1.key = @"booleanPrivacy1";
    
    [section addElement:privacy0];
    [section addElement:privacy1];
    return section;

}

+(QSection *)createThirSection{
    QSection *section = [[QSection alloc] init];
    section.title = NSLocalizedString(@"Social Team Activity", @"Attivita' dell'utente nell'app, titolo sezione");
    
    QLabelElement *postLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"I tuoi Post", @"I tuoi Post, titolo label")
                                                              Value:nil];
    
    //ALTRE FUNZIONALITA' DA IMPLEMENTARE
    
    QLabelElement *commentLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"I tuoi Commenti", @"I tuoiCommenti, titolo label")
                                                              Value:nil];
    QLabelElement *mediaLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"I tuoi Media", @"I tuoi Media, titolo label")
                                                              Value:nil];
    
    postLabel.key = @"postLabel";
    postLabel.controllerAction =  @"pushPostTableViewController:";
    
    //QUESTE VANNO SETTATE CORRETTAMENTE AL MOMENTO IN CUI SARANNO PRONTE
    commentLabel.key = @"commentLabel";
    commentLabel.controllerAction = @"pushCommentTableViewController:";
    mediaLabel.key = @"mediaLabel";
    mediaLabel.controllerAction = @"pushMediaTableViewController:";

    
    [section addElement:postLabel];
    [section addElement:commentLabel];
    [section addElement:mediaLabel];
    
    return section;
}


@end
