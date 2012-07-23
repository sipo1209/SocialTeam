//
//  PhotoDetailViewController.m
//  SavingImagesTutorial
//
//  Created by Sidwyn Koh on 29/1/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PAWWallPostCreateViewController.h"
#import "PhotolistViewController.h"
#import "CommentListViewController.h"

@implementation PhotoDetailViewController
@synthesize photoImageView, selectedImage,toolBar,imageName,photo;

//Close the view controller

#pragma mark - toolBar Button Methods

-(void)like:(id)sender{
    NSLog(@"like");
    [self.photo incrementKey:@"like"];
    [self.photo save];
    likeLabel.hidden = YES;
    likeLabel.text = [[self.photo objectForKey:@"like"] stringValue];
    likeLabel.hidden = NO;
    [[self.toolBar.items objectAtIndex:0] setEnabled:NO];
    [[self.toolBar.items objectAtIndex:4] setEnabled:NO];
    
}
-(void)disLike:(id)sender{
    NSLog(@"dislike");
    [self.photo incrementKey:@"dislike"];
    [self.photo save];
    dislikeLabel.hidden = YES;
    dislikeLabel.text = [[self.photo objectForKey:@"dislike"] stringValue];
    dislikeLabel.hidden = NO;
    [[self.toolBar.items objectAtIndex:4] setEnabled:NO];
    [[self.toolBar.items objectAtIndex:0] setEnabled:NO];
}

-(void)comment:(id)sender{
	PAWWallPostCreateViewController *createPostViewController = [[PAWWallPostCreateViewController alloc] initWithNibName:nil 
                                                                                                                  bundle:nil];
    createPostViewController.comment = YES;
    self.photo = (PFObject *)self.photo;
    NSLog(@"self.photo %@",self.photo);
    
    createPostViewController.oggettoCommentato = self.photo;
    NSLog(@"oggetto commentato 0 %@",createPostViewController.oggettoCommentato);

	[self.navigationController presentViewController:createPostViewController 
                                            animated:YES 
                                          completion:nil];
    
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


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
//manca da impostare meglio il conteggio di commenti & Co; manca da mostrare i commenti
-(void)impostoToolBar{
    //aggiunta dei bottoni di like, dislike e commenta alla toolbar
    //array per contenere i bottoni
    NSArray *buttons = [[NSArray alloc] init];
    
    //bottone like
    UIImage * buttonLikeImage = [UIImage imageNamed:@"thumbsUp.png"];
    UIBarButtonItem *likeButton = [[UIBarButtonItem alloc] initWithImage:buttonLikeImage 
                                                                   style:UIBarButtonItemStyleBordered 
                                                                  target:self 
                                                                  action:@selector(like:)];
    
    //label per il conteggio di like 
    likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [likeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [likeLabel setBackgroundColor:[UIColor clearColor]];
    [likeLabel setTextColor:[UIColor whiteColor]];
    [likeLabel setTextAlignment:UITextAlignmentCenter];
    
    
    //testo like label
    if ([self.photo objectForKey:@"like"]) {
        likeLabel.text = [[self.photo objectForKey:@"like"] stringValue];
        //[likeLabel.layer setBorderWidth:0];
    } else {
        likeLabel.text = @"0";
    }
    
    UIBarButtonItem *likeLabelButton = [[UIBarButtonItem alloc] initWithCustomView:likeLabel];
    
    
    //label per il conteggio di dislike 
    dislikeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [dislikeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [dislikeLabel setBackgroundColor:[UIColor clearColor]];
    [dislikeLabel setTextColor:[UIColor whiteColor]];
    [dislikeLabel setTextAlignment:UITextAlignmentCenter];
    
    
    //testo dislike label
    if ([self.photo objectForKey:@"dislike"]) {
        dislikeLabel.text = [[self.photo objectForKey:@"dislike"] stringValue];
        //[likeLabel.layer setBorderWidth:0];
    } else {
        dislikeLabel.text = @"0";
    }
    
    UIBarButtonItem *disLikeLabelButton = [[UIBarButtonItem alloc] initWithCustomView:dislikeLabel];
    
    
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
    
    
    //bottone per i commenti, da implementare il metodo per la scrittura del commento
    UIBarButtonItem *commentButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comment"] 
                                                                      style:UIBarButtonItemStyleBordered 
                                                                     target:self 
                                                                     action:@selector(comment:)];
    //bottone per i commenti, da implementare il metodo per la scrittura del commento
    UIBarButtonItem *commentButtonList = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Commenti", @"Commenti titolo bottone")
                                                                      style:UIBarButtonItemStyleBordered 
                                                                     target:self 
                                                                     action:@selector(commentList:)];
    
    //oggetti da aggiungere all'array degli oggetti della toolbar
    buttons = [NSArray arrayWithObjects:likeButton,flexItem,likeLabelButton,flexItem,dislikeButton,flexItem,disLikeLabelButton,flexItem,commentButton,flexItem,commentButtonList, nil];
    
    
    //implementazione della toolbar
    
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 440, 320, 40)];
    self.toolBar.barStyle = UIBarStyleBlackOpaque;
    
    [self.toolBar setItems:buttons];
    [self.navigationController.view addSubview:self.toolBar];
    //riabilito i pulsanti di like e dislike (per il momento un utente puo' votare quante volte vuole un'immagine
    [[self.toolBar.items objectAtIndex:0] setEnabled:YES];
    [[self.toolBar.items objectAtIndex:4] setEnabled:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoImageView.image = selectedImage;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.toolBar removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self impostoToolBar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.toolBar = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - actionsheet

//presento un actionsheet differente a seconda che la foto sia mia o di qualcuno
-(void)showPicker:(id)sender{
    //rivedere questa query
    PFUser *currentUser = [PFUser currentUser];
    NSString *currentID =currentUser.username;
    [[self.photo objectForKey:@"user"] fetchIfNeeded];
    NSString *photoId = ((PFUser *)[self.photo objectForKey:@"user"]).username;

    if ([photoId isEqualToString:currentID]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Photo Actions", @"Photo Actions") 
                                                                 delegate:self 
                                                        cancelButtonTitle:NSLocalizedString(@"Cancella", @"Cancella ActionSheet") 
                                                   destructiveButtonTitle:nil 
                                                        otherButtonTitles: NSLocalizedString(@"Cancella Foto", @"Cancella Foto ActionSheet"),NSLocalizedString(@"Condividi Foto", @"Cancella Foto ActionSheet"), NSLocalizedString(@"Edita Foto", @"Cancella Foto ActionSheet"),nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
       
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Photo Actions", @"Photo Actions") 
                                                                 delegate:self 
                                                        cancelButtonTitle:NSLocalizedString(@"Cancella", @"Cancella ActionSheet") 
                                                   destructiveButtonTitle:nil 
                                                        otherButtonTitles:  NSLocalizedString(@"Condividi Foto", @"Cancella Foto ActionSheet"),nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
        
    }
    
}
//implemento metodi diversi a seconda che la foto sia mia o di un qualcuno
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    PFUser *currentUser = [PFUser currentUser];
    NSString *currentID =currentUser.username;
    [[self.photo objectForKey:@"user"] fetchIfNeeded];
    NSString *photoId = ((PFUser *)[self.photo objectForKey:@"user"]).username;
    if ([photoId isEqualToString:currentID]) {
        switch (buttonIndex) {
            case 0:
                [self performSelector:@selector(cancellaFoto:)];
                break;
            case 1:
                [self performSelector:@selector(share:)];
                break;
                case 2:
                [self performSelector:@selector(editaFoto:)];
                break;
            default:
                break;
        }
    }else {
        switch (buttonIndex) {
            case 0:
                [self performSelector:@selector(share:)];
                break;
            default:
                break;
        }

    }
}

-(void)share:(id)sender{
    NSLog(@"share");
}
-(void)cancellaFoto:(id)sender{
    //implementare questo metodo
    
    NSLog(@"%@",((PFObject *)self.photo).objectId); 
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    PFObject *oggettoDaCancellare = [query getObjectWithId:((PFObject *)self.photo).objectId];
    [oggettoDaCancellare deleteInBackground];
    
   
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)editaFoto:(id)sender{
    NSLog(@"editaFoto");
}

-(void)commentList:(id)sender{
    CommentListViewController *commentList = [[CommentListViewController alloc] initWithStyle:UITableViewStylePlain 
                                                                                    className:@"Post"];
    self.photo = (PFObject *)self.photo;
    commentList.oggettoCommentato = self.photo;
    //commentList.textKey = @"text";
    commentList.title = NSLocalizedString(@"Commenti", @"Commenti titolo Viewcontroller");
    [self.navigationController pushViewController:commentList animated:YES];
}

@end
