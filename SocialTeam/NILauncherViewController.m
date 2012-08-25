//
// Copyright 2011 Jeff Verkoeyen
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

//NIMBUS
#import "NILauncherViewController.h"
#import "NILauncherView.h"
#import "NimbusCore.h"

//PARSE
#import "LoginController.h"
#import "SignUpController.h"

//WALL
#import "PAWWallViewController.h"

//ANYPIC
#import "PAPEditPhotoViewController.h"
#import "PAPHomeViewController.h"
#import "PAPPhotoTimelineViewController.h"
#import "PAPFindFriendsViewController.h"
#import "PAPActivityFeedViewController.h"


//IMPOSTAZIONE DATI

#import "YouTubeVideoGrabber.h"
#import "FBDataGrabber.h"
#import "FBFrieds Grabber.h"
//#import "TwitterDataGrabber.h"



//VIEWCONTROLLER PER LANCIO DA BOTTONI

#import "PAPAccountViewController.h"


#import "UserListViewController.h"
#import "Video.h"
#import "NewVideoViewController.h"
#import "ListaUtentiViewController.h"
#import "PhotolistViewController.h"
#import "ListaSitiViewController.h"

//definizione del canale di youtube dal quale fare il parsing dei dati per i video
#define YOUTUBE_CHANNEL @"http://gdata.youtube.com/feeds/api/users/milanchannel/uploads?&v=2&max-results=50&alt=jsonc"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NILauncherViewController

@synthesize launcherView  = _launcherView;
@synthesize pages         = _pages;
@synthesize root,rootVoti,videoArray;
#pragma login & signup delegate methods

-(void)caricamentoDati{
    //pensa di fare queste operazioni in background!!!
    //imposto il caricamento di dati da youtube
    self.videoArray = [YouTubeVideoGrabber listaVideo:YOUTUBE_CHANNEL];
   
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    NSLog(@"LOGGATO CORRETTAMENTE");
    //se l'utente si logga con FB prendo i dati
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        FBDataGrabber *fb = [[FBDataGrabber alloc] init];
        [fb FBDataGrab];
        
        FBFrieds_Grabber *FBfriends = [[FBFrieds_Grabber alloc] init];
        [FBfriends friendsGrab];
        
        ///CODICE AGGIUNTO DA ANYPIC
        if (user) {
            NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [user objectId]];
            [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:kPAPInstallationUserKey];
            [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kPAPInstallationChannelsKey];
            [[PFInstallation currentInstallation] saveEventually];
            [user setObject:privateChannelName forKey:kPAPUserPrivateChannelKey];
        }
        
    }
    //il codice di Twitter non viene richiamato perche' si e' limitata l'iscrizione ai soli utenti FB
    else if ([PFUser currentUser] && [PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
       /*
        TwitterDataGrabber *tw = [[TwitterDataGrabber alloc] init];
        [tw getTwitterData];
        [tw getTwitterStatus];
        */
    }
    //richiamo la funzione di caricamento dei dati 
    [self caricamentoDati];

    [self dismissModalViewControllerAnimated:YES];
}
-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error{
    NSLog(@"errore %@",[error userInfo]);
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    
}
-(void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController{
    NSLog(@"CANCEL");
    [self presentWelcomeViewController];

}
-(BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password{
    return YES;
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController
           shouldBeginSignUp:(NSDictionary *)info {
    NSString *password = [info objectForKey:@"password"];
    return (BOOL)(password.length >= 8); // prevent sign up if password has to be at least 8 characters long
}

- (void)presentWelcomeViewController;
{
	// Go to the welcome screen and have them log in or create an account.
    LoginController *loginController = [[LoginController alloc] init];
    loginController.fields = PFLogInFieldsFacebook ;
    loginController.delegate = self;
    loginController.signUpController.delegate = self;
    loginController.signUpController = [[SignUpController alloc] init];
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = [NSArray arrayWithObjects:@"user_about_me",
                                 @"user_relationships",
                                 @"user_birthday",
                                 @"user_location",
                                 @"offline_access",
                                 @"user_hometown",
                                 @"user_photos",
                                 @"user_status",
                                 @"user_website",
                                 @"email",
                                 nil];
    loginController.facebookPermissions = permissionsArray;
    [self presentModalViewController:loginController 
                            animated:NO];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  NI_RELEASE_SAFELY(_pages);
  // _launcherView is retained by self.view and is released in viewDidUnload

  [super dealloc];
}


#pragma mark - ViewLifeCicle

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
  [super viewDidLoad];
    self.title = NSLocalizedString(@"Social Team", @"Social Team Titolo Launcher");
    
    //CODICE PER il LOGIN
    if(![PFUser currentUser]){
        NSLog(@"UTENTE NON LOGGATO");
        [self presentWelcomeViewController];
    }
    if (!([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) || (!([PFUser currentUser] && [PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]))) {
        NSLog(@"UTENTE NON LOGGATO");
        [self presentWelcomeViewController];
    }
    
     _launcherView = [[[NILauncherView alloc] initWithFrame:self.view.bounds] autorelease];
    _launcherView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                    | UIViewAutoresizingFlexibleHeight);
    _launcherView.dataSource = self;
    _launcherView.delegate = self;
    [_launcherView reloadData];
    [self.view addSubview:_launcherView];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
  _launcherView = nil;
    self.rootVoti = nil;
    self.root = nil;

  [super viewDidUnload];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  // Only allow portrait for the iPhone and iPod touch.
  return NIIsPad() || UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NILauncherDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfRowsPerPageInLauncherView:(NILauncherView *)launcherView {
  // Replace this with NILauncherViewDynamic to allow the launcher view to calculate the number
  // of rows and columns automatically.
  return (NIIsPad()
          ? 4
          : (UIInterfaceOrientationIsPortrait(NIInterfaceOrientation())
             ? 3 : 2));
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfColumnsPerPageInLauncherView:(NILauncherView *)launcherView {
  return (NIIsPad()
          ? 5
          : (UIInterfaceOrientationIsPortrait(NIInterfaceOrientation())
             ? 3 : 5));
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfPagesInLauncherView:(NILauncherView *)launcherView {
  return [_pages count];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)launcherView:(NILauncherView *)launcherView numberOfButtonsInPage:(NSInteger)page {
  return [[_pages objectAtIndex:page] count];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton *)launcherView: (NILauncherView *)launcherView
             buttonForPage: (NSInteger)page
                   atIndex: (NSInteger)buttonIndex {
  UIButton* button = [[[[self launcherButtonClass] alloc] init] autorelease];

  // launcherButtonClass must return a class that is a subclass of UIButton.
  NIDASSERT([button isKindOfClass:[UIButton class]]);
  if (![button isKindOfClass:[UIButton class]]) {
    return nil;
  }

  NILauncherItemDetails* item = [[_pages objectAtIndex:page] objectAtIndex:buttonIndex];
  [button setTitle:item.title forState:UIControlStateNormal];
  [button setImage: [UIImage imageWithContentsOfFile:item.imagePath]
          forState: UIControlStateNormal];

  return button;
}

#pragma buttons methods

//1: pagina del profilo personale

//2: timeline

//3: worldwall

//4: foto

//5: video

//6: lista degli utenti (da rivedere se si riesce ad accorpara con lista utenti o si fa una sottoclasse della lista utenti)

//7: cerca amici

//8: social news

//9: classifica utenti

//10: siti

//11: FAQ

-(void)firstButtonSelected{
    /*
    //Per impostare i dati del form uso una classe esterna di caricamento dati
    ProfileViewController *navigation = [[ProfileViewController alloc] initWithRoot:self.root];
    navigation.title = NSLocalizedString(@"Pagina Personale", "Pagina Personale Titolo View Controller");
     */
    PAPAccountViewController *navigation = [[PAPAccountViewController alloc]initWithClassName:@"Users"];
    PFUser *current = [PFUser currentUser];
    navigation.user = current;
    navigation.title = NSLocalizedString(@"Pagina Personale", @"Pagina Personale Titolo ViewController");
    
    [self.navigationController pushViewController:navigation
                                         animated:YES];

    }

-(void)secondButtonSelected{
    PAPHomeViewController *photoHome = [[PAPHomeViewController alloc] init];
    photoHome.title = NSLocalizedString(@"TimeLine", @"TIMELINE Titolo ViewController");
    [self.navigationController pushViewController:photoHome
                                         animated:YES];
}

-(void)thirdButtonSelected{
    // imposto il viewController di cui fare il push per ognuno dei bottoni
    PAWWallViewController *wallController = [[PAWWallViewController alloc] init];
    wallController.title = NSLocalizedString(@"WorldWall", @"WorldWall Titolo del View Controller");
    [self.navigationController pushViewController:wallController
                                         animated:YES];
  
}

-(void)fourthButtonSelected{
     PhotolistViewController *photoListViewController = [[PhotolistViewController alloc] initWithNibName:@"PhotolistViewController" bundle:nil];
    photoListViewController.title = NSLocalizedString(@"Social Photo", @"Social Photo Titolo ViewController");
     [self.navigationController pushViewController:photoListViewController
                                          animated:YES];
}

-(void)fifthButtonSelected{
    NewVideoViewController *videoViewController = [[NewVideoViewController alloc] initWithStyle:UITableViewStylePlain];
    NSMutableArray *arrayURLthumb = [[NSMutableArray alloc] init];
    NSMutableArray *arrayTitoli = [[NSMutableArray alloc] init];
    NSMutableArray *arraySottotitoli = [[NSMutableArray alloc] init];
    NSMutableArray *arrayURL = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.videoArray.count; i = i +1) {
        [arrayURLthumb addObject:((Video *)[self.videoArray objectAtIndex:i]).thumbURL];
        [arrayTitoli addObject:((Video *)[self.videoArray objectAtIndex:i]).title];
        [arraySottotitoli addObject:((Video *)[self.videoArray objectAtIndex:i]).description];
        [arrayURL addObject:((Video *)[self.videoArray objectAtIndex:i]).urlVideo];
    }
    
    videoViewController.title = NSLocalizedString(@"Social Video", @"Social Video Titolo ViewController");
    videoViewController.objects = arrayURLthumb;
    videoViewController.titoli = arrayTitoli;
    videoViewController.sottotitoli = arraySottotitoli;
    videoViewController.videoURL = arrayURL;
    
    [self.navigationController pushViewController:videoViewController
                                         animated:YES];
    
}

-(void)sixthButtonSelected{
    ListaUtentiViewController *listaViewController = [[ListaUtentiViewController alloc] initWithStyle:UITableViewStylePlain className:@"User"];
    listaViewController.textKey = @"username";
    listaViewController.title = NSLocalizedString(@"Lista Utenti", @"Lista Utenti Titolo Pagina");
    [self.navigationController pushViewController:listaViewController
                                         animated:YES];
}

-(void)seventhButtonSelected{

    PAPFindFriendsViewController *detailViewController = [[PAPFindFriendsViewController alloc] init];
    detailViewController.title = NSLocalizedString(@"Cerca Amici", @"Cerca Amici titolo della pagina");
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
    
}

-(void)eightButtonSelected{
    PAPActivityFeedViewController *activityContoller = [[PAPActivityFeedViewController alloc] init];
    [self.navigationController pushViewController:activityContoller
                                         animated:YES];
}

-(void)ninethButtonSelected{
    
     UserListViewController *userlist = [[UserListViewController alloc] initWithStyle:UITableViewStylePlain
     className:@"User"];
     userlist.textKey = @"username";
     userlist.title = NSLocalizedString(@"Classifica Utenti", @"Classifica Utenti Titolo Pagina");
    [self.navigationController pushViewController:userlist
                                         animated:YES];

}

-(void)tenthButtonSelected{
    ListaSitiViewController *listaSiti = [[ListaSitiViewController alloc] initWithClassName:@"Websites"];
    [self.navigationController pushViewController:listaSiti
                                         animated:YES];
}

-(void)eleventhButtonSelected{
    NSLog(@"FAQ");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NILauncherDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)launcherView: (NILauncherView *)launcher
     didSelectButton: (UIButton *)button
              onPage: (NSInteger)page
             atIndex: (NSInteger)buttonIndex {

//introduco uno switch che identifica per ognuno dei pulsanti che viene premuto l'azione da compiere
    switch (page) {
        case 0:
            switch (buttonIndex) {
                case 0:
                    [self firstButtonSelected];
                    break;
                case 1:
                    [self secondButtonSelected];
                    break;
                case 2:
                    [self thirdButtonSelected];
                    break;
                case 3:
                    [self fourthButtonSelected];
                    break;
                case 4:
                    [self fifthButtonSelected];
                    break;
                case 5:
                    [self sixthButtonSelected];
                    break;
                case 6:
                    [self seventhButtonSelected];
                    break;
                case 7:
                    [self eightButtonSelected];
                    break;
                case 8:
                    [self ninethButtonSelected];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (buttonIndex) {
                case 0:
                    [self tenthButtonSelected];
                    break;
                case 1:
                    [self eleventhButtonSelected];
                    break;
                default:
                    break;
            }
        default:
            break;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Override Methods


///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)launcherButtonClass {
  return [NILauncherButton class];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setPages:(NSArray *)pages {
  if (_pages != pages) {
    [_pages release];
    _pages = [pages mutableCopy];

    // If the view hasn't been loaded yet (entirely possible) then this will no-op and the
    // launcher view will load its data in viewDidLoad.
    [_launcherView reloadData];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)pages {
  return [NSArray arrayWithArray:_pages];
}


@end
