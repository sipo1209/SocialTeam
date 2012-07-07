//
//  SignUpController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpController.h"

@interface SignUpController ()

@end

@implementation SignUpController

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
    UILabel *logo = [[UILabel alloc] init];
    logo.backgroundColor = [UIColor clearColor];
    logo.textColor = [UIColor blackColor];
    logo.textAlignment = UITextAlignmentCenter;
    logo.font = [UIFont fontWithName:@"Arial" 
                                size:(36.0)];
    logo.text = @"Social Team";
    [logo sizeToFit];
    self.signUpView.logo = logo;
    
    self.fields = PFSignUpFieldsUsernameAndPassword 
    | PFSignUpFieldsSignUpButton 
    | PFSignUpFieldsEmail;
    
    
    self.signUpView.signUpButton.titleLabel.text = NSLocalizedString(@"Registrati", @"Registrati titolo bottone signupcontroller");
    //imposto la dimensione del testo della label che si adatti al testo della specifica lingua
    self.signUpView.signUpButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
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
