//
//  PhotoDetailViewController.m
//  SavingImagesTutorial
//
//  Created by Sidwyn Koh on 29/1/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation PhotoDetailViewController
@synthesize photoImageView, selectedImage,toolBar,imageName,photo;

//Close the view controller

#pragma mark - toolBar Button Methods

-(void)like:(id)sender{
    NSLog(@"like");
    [self.photo incrementKey:@"like"];
    //likeLabel.hidden = YES;
    likeLabel.text = [[self.photo objectForKey:@"like"] stringValue];
    //likeLabel.hidden = NO;
    [[toolBar.items objectAtIndex:0] setEnabled:NO];
    [[toolBar.items objectAtIndex:4] setEnabled:NO];
    [self.photo save];
}
-(void)disLike:(id)sender{
    NSLog(@"dislike");
    [self.photo incrementKey:@"dislike"];
    //likeLabel.hidden = YES;
    likeLabel.text = [[self.photo objectForKey:@"dislike"] stringValue];
    //likeLabel.hidden = NO;
    [[toolBar.items objectAtIndex:4] setEnabled:NO];
    [[toolBar.items objectAtIndex:0] setEnabled:NO];
    [self.photo save];
    
}

-(void)comment:(id)sender{
    NSLog(@"comment");
    
}

- (void)close:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Foto Selezionata", @"Foto Selezionata Titolo ViewController");
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self
                                                                                               action:@selector(showPicker:)];
    }
    return self;
}

//qui devi implementare le azioni per la foto: cancellazione della foto,
-(void)showPicker:(id)sender{
    NSLog(@"Mostra Picker");
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoImageView.image = selectedImage;
    
    //aggiunta dei bottoni di like, dislike e commenta alla toolbar
    //array per contenere i bottoni
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
                                 
    //bottone like
    UIImage * buttonLikeImage = [UIImage imageNamed:@"thumbsUp.png"];
    UIBarButtonItem *likeButton = [[UIBarButtonItem alloc] initWithImage:buttonLikeImage 
                                                                   style:UIBarButtonItemStyleBordered 
                                                                  target:self 
                                                                  action:@selector(like:)];
    
    //label per il conteggio di like 
    likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30.0f, 20.0f)];
    [likeLabel sizeToFit];
    [likeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [likeLabel setBackgroundColor:[UIColor clearColor]];
    [likeLabel setTextColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0]];
    [likeLabel setTextAlignment:UITextAlignmentCenter];
    
    
    //label like
    if ([self.photo objectForKey:@"like"]) {
        likeLabel.text = [[self.photo objectForKey:@"like"] stringValue];
        //[likeLabel.layer setBorderWidth:0];
    } else {
        likeLabel.text = @"0";
    }
    
    UIBarButtonItem *likeLabelButton = [[UIBarButtonItem alloc] initWithCustomView:likeLabel];
    
    //bottone dislike
    UIImage *buttonDislikeImage = [UIImage imageNamed:@"thumbsDown.png"];
    UIBarButtonItem *dislikeButton = [[UIBarButtonItem alloc] initWithImage:buttonDislikeImage 
                                                                   style:UIBarButtonItemStyleBordered 
                                                                  target:self 
                                                                     action:@selector(disLike:)];

    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] 
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                 target:nil
                                 action:nil];
    UIBarButtonItem *flexItem2 = [[UIBarButtonItem alloc] 
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                 target:nil
                                 action:nil];
    UIBarButtonItem *flexItem3 = [[UIBarButtonItem alloc] 
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                 target:nil
                                 action:nil];
    UIBarButtonItem *flexItem4 = [[UIBarButtonItem alloc] 
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                 target:nil
                                 action:nil];
    
    //bottone per i commenti, da implementare il metodo per la scrittura del commento
    UIBarButtonItem *commentButton = [[UIBarButtonItem alloc] initWithTitle:@"Commenta" 
                                                                      style:UIBarButtonItemStyleBordered 
                                                                     target:self 
                                                                     action:@selector(comment:)];
    
    //oggetti da aggiungere all'array degli oggetti della toolbar
    [buttons addObject:likeButton];
    [buttons addObject:flexItem];
    [buttons addObject:likeLabelButton];
    [buttons addObject:flexItem2];
    [buttons addObject:dislikeButton];
    [buttons addObject:flexItem3];
    [buttons addObject:likeLabelButton];
    [buttons addObject:flexItem4];
    [buttons addObject:commentButton];
    
    //implementazione della toolbar
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 440, 320, 40)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
               
    [toolBar setItems:buttons];
    [self.navigationController.view addSubview:toolBar];
    //riabilito i pulsanti di like e dislike (per il momento un utente puo' votare quante volte vuole un'immagine
    [[toolBar.items objectAtIndex:0] setEnabled:YES];
    [[toolBar.items objectAtIndex:4] setEnabled:YES];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.toolBar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
