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

#import "NILauncherViewController.h"

#import "NILauncherView.h"

#import "NimbusCore.h"

#import "PAWWallViewController.h"

#import "LoginController.h"



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NILauncherViewController

@synthesize launcherView  = _launcherView;
@synthesize pages         = _pages;

#pragma login & signup delegate methods

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    NSLog(@"LOGGATO");
    [self dismissModalViewControllerAnimated:YES];
}
-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error{
    NSLog(@"pass sbagliata o username sbagliata");
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
    loginController.fields = PFLogInFieldsUsernameAndPassword 
    |PFLogInFieldsLogInButton 
    |PFLogInFieldsPasswordForgotten 
    |PFLogInFieldsSignUpButton
    |PFLogInFieldsTwitter 
    |PFLogInFieldsFacebook ;
    loginController.delegate = self;
    loginController.signUpController.delegate = self;
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = [NSArray arrayWithObjects:@"user_about_me",
                                 @"user_relationships",
                                 @"user_birthday",
                                 @"user_location",
                                 @"offline_access",
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


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
  [super viewDidLoad];
    self.title = @"Social Team";
    if(![PFUser currentUser]){
        NSLog(@"LOGIN 1");
        [self presentWelcomeViewController];
    }
    if (!([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) || (!([PFUser currentUser] && [PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]))) {
        NSLog(@"LOGIN 2");
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
-(void)firstButtonSelected{
    // imposto il viewController di cui fare il push per ognuno dei bottoni
    PAWWallViewController *wallController = [[PAWWallViewController alloc] init];
    [self.navigationController pushViewController:wallController 
                                         animated:YES];
    }

-(void)secondButtonSelected{
    NSLog(@"secondo bottone");
}

-(void)thirdButtonSelected{
    NSLog(@"terzo bottone");
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
  //NILauncherItemDetails* item = [[_pages objectAtIndex:page] objectAtIndex:index];

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
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 4:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 5:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 6:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 7:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 8:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 9:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (buttonIndex) {
                case 0:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 1:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 2:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 3:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 4:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 5:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 6:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 7:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 8:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
                    break;
                case 9:
                    NSLog(@" %d numero pagina, %d numero bottone", page, buttonIndex);
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
