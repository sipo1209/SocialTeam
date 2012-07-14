//
//  ProfileViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "DemoHintView.h"
#import "UserPostViewController.h"
#import "ImpostaProfilo.h"
#import "ViewController.h"

@interface ProfileViewController ()
-(void) displayHint;

@end

@implementation ProfileViewController

-(void)editAvatar:(id)sender{
    NSLog(@"editAvatar");
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"AVATARTAPPED");
    return YES;
}

-(void) displayHint
{
    if( ![DemoHintView shouldShowHint:kHintID_Home] )
    {
        return;
    }
    
    __block DemoHintView* hintView = [DemoHintView  infoHintView];
    
    // Overwrites the pages titles
    //hintView.title = @"Welcome to the Demo!";
    
    hintView.hintID = kHintID_Home;
    
    [hintView addPageWithtitle:@"Page 1" text:@"We'll show you these little helpers throughout the app. However, you can certainly turn them off if you like." buttonText:@"Turn off hints" buttonAction:^{
        
        [DemoHintView enableHints:NO];
        
        [hintView dismiss];
    }];
    
    [hintView addPageWithTitle:@"Page 2" text:@"This is some demo text. Swipe this message to see the next hint!"];
    [hintView addPageWithTitle:@"Page 3" image:[UIImage imageNamed:@"touchbee_small.png"]];
    [hintView addPageWithTitle:@"Page 4" text:@"Text B"];
    [hintView addPageWithTitle:@"Page 5" text:@"Text C"];
    
    [hintView showInView:self.view orientation:kHintViewOrientationBottom];
}



-(void) hint
{
    __block DemoHintView* hintView = [DemoHintView  warningHintView];
    
    // Overwrites the pages titles
    hintView.title = NSLocalizedString(@"Impostazione Dati Account",@"Impostazione Dati Account, Profilo Utente");
    
    hintView.hintID = kHintID_Home;
    /*
    qui un esempio di come potresti inserire un bottone per aprire una ltro viewController
    [hintView addPageWithtitle:@"Page 1" 
                          text:@"We'll show you these little helpers throughout the app. However, you can certainly turn them off if you like." buttonText:@"Turn off hints" 
                  buttonAction:^{
        
        [DemoHintView enableHints:NO];
        
        [hintView dismiss];
    }];
     */
    
    [hintView addPageWithTitle:@"AVATAR" 
                          text:NSLocalizedString(@"Impostazione Avatar",@"Impostazione Avatar, Profilo Utente")];
    [hintView addPageWithTitle:@"USERNAME" 
                          text:@"Come impostare username"];
    [hintView addPageWithTitle:@"Nome e Cognome" 
                          text:NSLocalizedString(@"Impostazione Nome e Cognome",@"Impostazione Nome e Cognome, Profilo Utente")];
    [hintView addPageWithTitle:@"MAIL" 
                          text:NSLocalizedString(@"Impostazione Mail",@"Impostazione Mail, Profilo Utente")];
    [hintView addPageWithTitle:@"ETA'" 
                          text:NSLocalizedString(@"Impostazione Eta",@"Impostazione Eta', Profilo Utente")];
    [hintView addPageWithTitle:@"SESSO" 
                          text:NSLocalizedString(@"Impostazione Genere",@"Impostazione Genere, Profilo Utente")];
    [hintView addPageWithTitle:@"CITTA'" 
                          text:NSLocalizedString(@"Impostazione Citta",@"Impostazione Citta, Profilo Utente")];
    [hintView addPageWithTitle:@"Privacy Classifiche" 
                          text:NSLocalizedString(@"Privacy Classifiche", "Frase Privacy Classifiche, Profilo Utente")];
    [hintView addPageWithTitle:@"Privacy Messaggi" 
                          text:NSLocalizedString(@"Privacy Messaggi", "Frase Privacy Messaggi, Profilo Utente")];
    //[hintView addPageWithTitle:@"Page 3" image:[UIImage imageNamed:@"touchbee_small.png"]];
    
    [hintView showInView:self.view 
             orientation:kHintViewOrientationTop
            presentation:kHintViewPresentationBounce];
}

//METODO PER LA SELEZIONE DELL'AVATAR DALLE LIBRERIE DEI VARI SOCIAL NETWORK
-(void)selezioneAvatar:(id)sender{
    PhotoPickerPlus *temp = [[PhotoPickerPlus alloc] init];
    [temp setDelegate:self];
    [temp setModalPresentationStyle:UIModalPresentationCurrentContext];
    [temp setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:temp animated:YES 
                     completion:^(void){
        [temp release];
    }];
}

#pragma mark PhotoPickerPlus Delegate Methods

//DELEGATI DEL PICKER DELLE FOTO DAI SOCIAL NETWORK
-(void) PhotoPickerPlusControllerDidCancel:(PhotoPickerPlus *)picker{
    [self dismissViewControllerAnimated:YES 
                             completion:^(void){
        
    }];
}
-(void)PhotoPickerPlusController:(PhotoPickerPlus *)picker didFinishPickingArrayOfMediaWithInfo:(NSArray *)info{
    
}
-(void) PhotoPickerPlusController:(PhotoPickerPlus *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    PFUser *currentUser = [PFUser currentUser];
    [self dismissViewControllerAnimated:YES 
                             completion:^(void){
    NSData *imageData = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]);
    [[((QSection *)[self.root.sections objectAtIndex:0]).headerView.subviews objectAtIndex:0] setImage:[UIImage imageWithData:imageData]];  
    [self.quickDialogTableView reloadData];
                                 
    //faccio l'upload dell'avatar su PARSE
    //dai dati faccio un file di immagine che posso poi uploadare su PARSE
    NSString *fileName = [[NSString alloc] initWithFormat:@"avatar.png"];
    PFFile *imageFile = [PFFile fileWithName:fileName 
                                        data:imageData];
    [imageFile save];
    [currentUser setObject:imageFile 
                    forKey:@"avatar"];
             
                                 /*
        //QUI POTRESTI IMPLEMENTARE LA CREAZIONE DI UN THUMBNAIL 
        CGSize newSize = CGSizeMake(48.0f, 48.0f);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [avatarContainer.image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *imageData = UIImagePNGRepresentation(small);
        PFFile *thumbFile = [PFFile fileWithName:@"thumb.png" data:imageData];
        [thumbFile save];                             
                                 
      */                           
    [currentUser saveInBackground];
    }];
}


#pragma mark QEntryElement delegate Methods

//metodi chiamati alla pressione delle celle del controller

-(void)QEntryDidEndEditingElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell{

    PFUser *user = [PFUser currentUser];
    if ([element.key isEqualToString:@"textFieldNome"]) {
        [user setObject:element.textValue
                 forKey:@"nome"];
        NSLog(@"%@ ",[user objectForKey:@"nome"]);
    }
    else if ([element.key isEqualToString:@"textFieldCognome"]) {
       [user setObject:element.textValue
                 forKey:@"cognome"];
      
        NSLog(@"%@ ",[user objectForKey:@"cognome"]);
    }
    else if ([element.key isEqualToString:@"textFieldEta"]) {
        [user setObject:element.textValue
                 forKey:@"eta"];
        NSLog(@"%@ ",[user objectForKey:@"eta"]);
    }
    else if ([element.key isEqualToString:@"textFieldCitta"]) {
        [user setObject:element.textValue
                 forKey:@"citta"];
        NSLog(@"%@ ",[user objectForKey:@"citta"]);
            }
    else if ([element.key isEqualToString:@"textFieldNomeutente"]) {
        [user setObject:element.textValue
                 forKey:@"username"];
    }else if ([element.key isEqualToString:@"textFieldWebsite"]){
        NSString *HTTPstring = [[NSString alloc] initWithFormat:@"http://"];
        NSString *URLString = [HTTPstring stringByAppendingString:element.textValue];
        [user setObject:URLString
                 forKey:@"webSite"];
    }else if ([element.key isEqualToString:@"textFieldStatus"]) {
        NSLog(@"status");
        [user setObject:element.textValue
                 forKey:@"status"];
    }
    [user save];
    
    [self.quickDialogTableView reloadCellForElements:element, nil];
    NSLog(@"FINE SCRITTURA");
    return;
}

-(void)QEntryDidBeginEditingElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell{
    NSLog(@"INIZIO SCRITTURA");
}


#pragma  mark QuickDialog Cell delegate Method
-(void)cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath{
    //da implementare l'allineamento delle celle a destr per il QEntryElement
    if ([element isKindOfClass:[QEntryElement class]]){
        cell.detailTextLabel.textAlignment = UITextAlignmentRight;
    }

}

#pragma  mark Metodi custom alla pressione delle celle
//implemento il metodo per la selezione del genere dell'utente
-(void)selezionaGenere:(QRadioElement *) element{
    //prendo l'utente corrente
    PFUser *currentUser = [PFUser currentUser];
    //in base al sesso scrivo i valori su parse
    switch (element.selected) {
        case 0:
            [currentUser setObject:@"male" forKey:@"genere"];
            break;
        case 1:
            [currentUser setObject:@"female" forKey:@"genere"];
            break;
        default:
            break;
    }
    [currentUser save];
}

#pragma mark - user interactions methods

-(void)pushCommentTableViewController:(QLabelElement *) label{
    NSLog(@"TABELLA DEI COMMENTI");
}
-(void)pushMediaTableViewController:(QLabelElement *) label{

    ViewController *photoViewController = [[ViewController alloc] initWithNibName:@"ViewController" 
                                                                           bundle:nil];
   
    [self.navigationController pushViewController:photoViewController
                                         animated:YES];
    
}

-(void)pushFriendsTableViewController:(QLabelElement *)label{
    NSLog(@"TABELLA DEGLI AMICI");
}
-(void)pushPostTableViewController:(QLabelElement *) label{
    //utilizzo una classe apposita per mostrare i post dell'utente
    UserPostViewController *userPostController = [[UserPostViewController alloc] initWithStyle:UITableViewStylePlain className:@"Post"];
   userPostController.textKey = @"text";
   userPostController.title = NSLocalizedString(@"I tuoi post", @"I tuoi post, titolo ViewController");
    
   [self.navigationController pushViewController:userPostController 
                                        animated:YES];
}



#pragma  mark View Life Cicle

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
    ((QEntryElement *)[self.root elementWithKey:@"textFieldEmail"]).delegate = self;
    ((QEntryElement *)[self.root elementWithKey:@"textFieldWebsite"]).delegate = self;
    ((QEntryElement *)[self.root elementWithKey:@"textFieldNomeutente"]).delegate = self;
    ((QEntryElement *)[self.root elementWithKey:@"textFieldStatus"]).delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info" 
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self 
                                                                             action:@selector(hint)];
    
    
    
   //aggiungo un gesture recognizer sopra l'avatar, in modo tale che venga richiamato il metodo per la selezione dell'avatar
    UITapGestureRecognizer *editAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                 action:@selector(selezioneAvatar:)];
    editAvatar.numberOfTapsRequired = 1;
    editAvatar.delegate = self;
    
    //faccio una cast conversion e prendo la prima subView dell'headerView della prima sezione, la abilito e aggiungo il recognizer
    [[((QSection *)[self.root.sections objectAtIndex:0]).headerView.subviews objectAtIndex:0] setUserInteractionEnabled:YES];
    [[((QSection *)[self.root.sections objectAtIndex:0]).headerView.subviews objectAtIndex:0] addGestureRecognizer:editAvatar];
    //faccio una cast conversion e prendo la seconda subView dell'headerView e aggiungo il comportamento (e' un bottone)
    [[((QSection *)[self.root.sections objectAtIndex:0]).headerView.subviews objectAtIndex:1] setTitle:NSLocalizedString(@"Edita Avatar", "Edita Avatar Label") forState:UIControlStateNormal];
    [[((QSection *)[self.root.sections objectAtIndex:0]).headerView.subviews objectAtIndex:1] addTarget:self action:@selector(editAvatar:) forControlEvents:UIControlEventTouchUpInside];
   
    
    self.quickDialogTableView.styleProvider = self;
    //self.quickDialogTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"just_background@2x.png"]];
   
    //impostazione dell'HUD 
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
    [self selezionaGenereHUD];
    //[self inserimentoDatiHUD];

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

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	 HUD = nil;

}

#pragma mark - metodiHUD
/*
-(void)inserimentoDatiHUD{
    HUD.labelText = NSLocalizedString(@"Inserimento Dati", @"Inserimento Dati HUD");
	[HUD showWhileExecuting:@selector(QEntryDidEndEditingElement:andCell:) 
                   onTarget:self 
                 withObject:nil 
                   animated:YES];
}
*/

-(void)selezionaGenereHUD{
	HUD.labelText = NSLocalizedString(@"Impostazione Genere", @"Impostazione Genere HUD");
	[HUD showWhileExecuting:@selector(selezionaGenere:) 
                   onTarget:self 
                 withObject:nil 
                   animated:YES];
}


@end
