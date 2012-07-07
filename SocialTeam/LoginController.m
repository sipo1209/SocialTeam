//
//  LoginController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 24/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@end

@implementation LoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    self.logInView.logInButton.titleLabel.text = NSLocalizedString(@"LogIn", @"Login Bottone");
    self.logInView.signUpButton.titleLabel.text = NSLocalizedString(@"Registrati", @"Registrati Bottone LoginViewController");
    
    //imposto la dimensione del testo della label che si adatti al testo della specifica lingua
    self.logInView.logInButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.logInView.signUpButton.titleLabel.adjustsFontSizeToFitWidth = YES;
}


- (void)viewDidLoad
{
    //customizzazione del logo, quando arai un logo inserisci una imageView
    UILabel *logo = [[UILabel alloc] init];
    logo.backgroundColor = [UIColor clearColor];
    logo.textColor = [UIColor blackColor];
    logo.textAlignment = UITextAlignmentCenter;
    logo.font = [UIFont fontWithName:@"Arial" 
                                size:(36.0)];
    logo.text = @"Social Team";
    [logo sizeToFit];
    self.logInView.logo = logo;
    self.logInView.logInButton.titleLabel.text = NSLocalizedString(@"LogIn", @"Login Bottone");
    self.logInView.signUpButton.titleLabel.text = NSLocalizedString(@"Registrati", @"Registrati Bottone LoginViewController");
    
    
    //imposto la dimensione del testo della label che si adatti al testo della specifica lingua
    self.logInView.logInButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.logInView.signUpButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.logInView.passwordForgottenButton.titleLabel.text = NSLocalizedString(@"Dimenticati?", @"Password dimenticata");
    //mancano da tradurre "you can also log in with" e "Don't have an account yet?"
    
    [super viewDidLoad];
   
	// Do any additional setup after loading the view.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
