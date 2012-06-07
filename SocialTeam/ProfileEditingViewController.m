//
//  ProfileEditingViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 07/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileEditingViewController.h"

@interface ProfileEditingViewController ()

- (void)textInputChanged:(NSNotification *)note;

@end

@implementation ProfileEditingViewController
@synthesize textView;

@synthesize postButton;

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

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextViewTextDidChangeNotification object:textView];
    textView.text = self.textView.text;

	// Show the keyboard/accept input.
	[textView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:textView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)cancelPost:(id)sender {
    NSLog(@"CANCEL");
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)postPost:(id)sender {
    NSLog(@"EDIT");
    [self dismissModalViewControllerAnimated:YES];
}

- (void)textInputChanged:(NSNotification *)note {
	// Listen to the current text field and count characters.
}


@end
