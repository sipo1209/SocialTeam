//
//  ProfileViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController


//metodi chiamati alla pressione delle celle del controller

-(void)QEntryDidEndEditingElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell{
    if (element == (QEntryElement *) [self.root elementWithKey:@"entryElement"]) {
       NSLog(@"Field di inserimento citta'"); 
        if (element.textValue != nil){
            PFUser *user = [PFUser currentUser];
            [user setObject:element.textValue
                     forKey:@"city"];
            [user save];
            NSLog(@"%@ ",[user objectForKey:@"city"]);
            [self.quickDialogTableView reloadCellForElements:element, nil];
            return;
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" 
                                                            message:@"Il campo citta' non puo' essere vuoto" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil ];
            alert.delegate = self;
            [alert show];

        }   
    }
    NSLog(@"FINE SCRITTURA");
    return;
}

-(void)QEntryDidBeginEditingElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell{
    NSLog(@"INIZIO SCRITTURA");
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
    ((QEntryElement *)[self.root elementWithKey:@"entryElement"]).delegate = self;
    // Do any additional setup after loading the view from its nib.
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
