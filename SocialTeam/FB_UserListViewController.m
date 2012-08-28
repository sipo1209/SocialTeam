//
//  FB_UserListViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 28/08/12.
//
//

#import "FB_UserListViewController.h"

@interface FB_UserListViewController ()

@end



@implementation FB_UserListViewController


- (PFQuery *)queryForTable {
    // Use cached facebook friend ids
    // NSArray *facebookFriends = [[PAPCache sharedCache] facebookFriends];
    
    // Query for all friends you have on facebook and who are using the app
    PFQuery *query = [PFUser query];
    [query whereKeyExists:kPAPUserFacebookIDKey];
    [query whereKey:kPAPUserFacebookIDKey notEqualTo:[[PFUser currentUser]objectForKey:@"facebookId"]];
    
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:kPAPUserDisplayNameKey];
    
    return query;
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
