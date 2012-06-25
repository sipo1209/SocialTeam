//
//  ProfileViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "DemoHintView.h"



@interface ProfileViewController ()
//-(void) displayHint;

@end

@implementation ProfileViewController

-(void)puppa:(id)sender{
    NSLog(@"AVATARTAPPED");
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"AVATARTAPPED");
    return YES;
    
}


//manca da implementare un delegato obbligatorio

/*
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

*/

#pragma mark tableView delegate methods
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
   PhotoPickerPlus *temp = [[PhotoPickerPlus alloc] init];
    NSLog(@"puppo");
    [temp setDelegate:self];
    [temp setModalPresentationStyle:UIModalPresentationFullScreen];
    [temp setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    switch (indexPath.row) {
        case 0:
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [self presentViewController:temp animated:YES 
                             completion:^(void){
                                 [temp release];
                             }];
            break;
        default:
            break;
    }
}
/*
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    AvatarViewController *avatarViewController = [[AvatarViewController alloc] init];
    switch (indexPath.row) {
        case 0:
            self.immagineAvatar = avatarViewController.avatarImage;
            //faccio il push del view controller alla pressione del primo disclosure indicator (unico al momento)
            [self.navigationController pushViewController:avatarViewController 
                                                 animated:YES];
            
            break;
        default:
            break;
    }
}
 */

-(void) hint
{
    __block DemoHintView* hintView = [DemoHintView  warningHintView];
    
    // Overwrites the pages titles
    hintView.title = @"Come settare i dati Account";
    
    hintView.hintID = kHintID_Home;
    /*
    qui un esmpio di come potressti inserire un bottone per aprire una ltro viewController
    [hintView addPageWithtitle:@"Page 1" 
                          text:@"We'll show you these little helpers throughout the app. However, you can certainly turn them off if you like." buttonText:@"Turn off hints" 
                  buttonAction:^{
        
        [DemoHintView enableHints:NO];
        
        [hintView dismiss];
    }];
     */
    
    [hintView addPageWithTitle:@"AVATAR" 
                          text:@"Impostare un AVATAR:"];
    [hintView addPageWithTitle:@"USERNAME" 
                          text:@"Come impostare username"];
    [hintView addPageWithTitle:@"Nome e Cognome" 
                          text:@"Impostare un Nome e Cognome"];
    [hintView addPageWithTitle:@"MAIL" 
                          text:@"Impostare indirizzo mail"];
    [hintView addPageWithTitle:@"ETA'" 
                          text:@"Impostare eta'"];
    [hintView addPageWithTitle:@"SESSO" 
                          text:@"Impostare Genere"];
    [hintView addPageWithTitle:@"CITTA'" 
                          text:@"Impostare Citta'"];
    [hintView addPageWithTitle:@"Privacy Classifiche" 
                          text:@"Impostare Privacy Classifiche"];
    [hintView addPageWithTitle:@"Privacy Messaggi" 
                          text:@"Impostare Privacy Ricezione Messaggi"];
    //[hintView addPageWithTitle:@"Page 3" image:[UIImage imageNamed:@"touchbee_small.png"]];
    
    [hintView showInView:self.view 
             orientation:kHintViewOrientationTop
            presentation:kHintViewPresentationBounce];
}

//METODO PER LA SELEZIONE DELL'AVATAR DALLE LIBRERIE DEI VARI SOCIAL NETWORK
-(void)selezioneAvatar:(id)sender{
    NSLog(@"PIPPO");
    PhotoPickerPlus *temp = [[PhotoPickerPlus alloc] init];
    [temp setDelegate:self];
    [temp setModalPresentationStyle:UIModalPresentationFullScreen];
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
-(void) PhotoPickerPlusController:(PhotoPickerPlus *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSLog(@"selezionato");
    PFUser *currentUser = [PFUser currentUser];
    [self dismissViewControllerAnimated:YES 
                             completion:^(void){
                                 //faccio l'upload dell'avatar su PARSE
    NSData *imageData = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]);
    //dai dati faccio un file di immagine che posso poi uploadare su PARSE
                                 NSString *fileName = [[NSString alloc] initWithFormat:@"avatar.png"];
    PFFile *imageFile = [PFFile fileWithName:fileName 
                                        data:imageData];
    [imageFile save];
                                 [currentUser setObject:imageFile 
                                                 forKey:@"avatar"];
                                 [currentUser saveInBackground];
                                 
        //[self.immagineAvatar setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
                                 //qui devi impostare la SEZIONE che abbia in testa l'immagine
    }];
}


#pragma mark QEntryElement delegate Methods

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


//implemento il metodo per la selezione del genere dell'utente
-(void)selezionaGenere:(QRadioElement *) element{
    //prendo l'utente corrente
    PFUser *currentUser = [PFUser currentUser];
    //in base al sesso scrivo i valori su parse
    switch (element.selected) {
        case 0:
            [currentUser setObject:@"M" forKey:@"genere"];
            break;
        case 1:
            [currentUser setObject:@"F" forKey:@"genere"];
            break;
        case 2:
            [currentUser setObject:@"Other" forKey:@"genere"];
            break;
        default:
            break;
    }
    [currentUser save];
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
                                                                             action:@selector(hint)];
    
    
   //aggiungo un gesture recognizer sopra l'avatar, in modo tale che venga richiamato il metodo per la selezione dell'avatar
    UITapGestureRecognizer *editAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                 action:@selector(selezioneAvatar:)];
    editAvatar.numberOfTapsRequired = 1;
    editAvatar.delegate = self;
    
    //faccio una cast conversione e prendo la prima subView dell'headerView della prima sezione, la abilito e aggiungo il recognizer
    [[((QSection *)[self.root.sections objectAtIndex:0]).headerView.subviews objectAtIndex:0] setUserInteractionEnabled:YES];
    [[((QSection *)[self.root.sections objectAtIndex:0]).headerView.subviews objectAtIndex:0]addGestureRecognizer:editAvatar];
     
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
