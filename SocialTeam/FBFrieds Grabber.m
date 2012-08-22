//
//  FBFrieds Grabber.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 08/08/12.
//
//QUESTA CLASSE SERVER PER PRENDERE GLI AMICI DI FB

#import "FBFrieds Grabber.h"
#import "PAPUtility.h"

@implementation FBFrieds_Grabber
@synthesize autoFollowTimer;

-(void)friendsGrab{
    NSString *requestPath = @"me/?fields=name,picture";
    [[PFFacebookUtils facebook] requestWithGraphPath:requestPath
                                         andDelegate:self];
    
}
#pragma mark - PF_FBRequestDelegate
- (void)request:(PF_FBRequest *)request didLoad:(id)result {
    // This method is called twice - once for the user's /me profile, and a second time when obtaining their friends. We will try and handle both scenarios in a single method.
    
    NSArray *data = [result objectForKey:@"data"];
    
    if (data) {
        // we have friends data
        NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for (NSDictionary *friendData in data) {
            [facebookIds addObject:[friendData objectForKey:@"id"]];
        }
        
        NSLog(@"%@ FB_ID",facebookIds);
        NSLog(@"numero amici %d",[facebookIds count]);
        
        // cache friend data
        [[PAPCache sharedCache] setFacebookFriends:facebookIds];
        
        if (![[PFUser currentUser] objectForKey:kPAPUserAlreadyAutoFollowedFacebookFriendsKey]) {
            //[self.hud setLabelText:@"Following Friends"];
            NSLog(@"Auto-following");
            firstLaunch = YES;
            
            [[PFUser currentUser] setObject:[NSNumber numberWithBool:YES] forKey:kPAPUserAlreadyAutoFollowedFacebookFriendsKey];
            NSError *error = nil;
            
            // find common Facebook friends already using Anypic
            PFQuery *facebookFriendsQuery = [PFUser query];
            [facebookFriendsQuery whereKey:kPAPUserFacebookIDKey containedIn:facebookIds];
            
            NSArray *anypicFriends = [facebookFriendsQuery findObjects:&error];
            if (!error) {
                [anypicFriends enumerateObjectsUsingBlock:^(PFUser *newFriend, NSUInteger idx, BOOL *stop) {
                    NSLog(@"Join activity for %@", [newFriend objectForKey:kPAPUserDisplayNameKey]);
                    PFObject *joinActivity = [PFObject objectWithClassName:kPAPActivityClassKey];
                    [joinActivity setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey];
                    [joinActivity setObject:newFriend forKey:kPAPActivityToUserKey];
                    [joinActivity setObject:kPAPActivityTypeJoined forKey:kPAPActivityTypeKey];
                    
                    PFACL *joinACL = [PFACL ACL];
                    [joinACL setPublicReadAccess:YES];
                    joinActivity.ACL = joinACL;
                    
                    // make sure our join activity is always earlier than a follow
                    [joinActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"Followed %@", [newFriend objectForKey:kPAPUserDisplayNameKey]);
                        }
                        
                        [PAPUtility followUserInBackground:newFriend block:^(BOOL succeeded, NSError *error) {
                            // This block will be executed once for each friend that is followed.
                            // We need to refresh the timeline when we are following at least a few friends
                            // Use a timer to avoid refreshing innecessarily
                            if (self.autoFollowTimer) {
                                [self.autoFollowTimer invalidate];
                            }
                            
                            self.autoFollowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoFollowTimerFired:) userInfo:nil repeats:NO];
                        }];
                    }];
                }];
            }
            /*
            if (![self shouldProceedToMainInterface:[PFUser currentUser]]) {
                [self logOut];
                return;
            }
            
            if (!error) {
                [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:NO];
                self.hud = [MBProgressHUD showHUDAddedTo:self.homeViewController.view animated:NO];
                [self.hud setDimBackground:YES];
                [self.hud setLabelText:@"Following Friends"];
            }*/
        }
        
        [[PFUser currentUser] saveEventually];
    } else {
        //[self.hud setLabelText:@"Creating Profile"];
        NSString *facebookId = [result objectForKey:@"id"];
        NSString *facebookName = [result objectForKey:@"name"];
        
        if (facebookName && facebookName != 0) {
            [[PFUser currentUser] setObject:facebookName
                                     forKey:kPAPUserDisplayNameKey];
        }
        
        if (facebookId && facebookId != 0) {
            [[PFUser currentUser] setObject:facebookId
                                     forKey:kPAPUserFacebookIDKey];
        }
        
        [[PFFacebookUtils facebook] requestWithGraphPath:@"me/friends"
                                             andDelegate:self];
    }
}


           

- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
        NSLog(@"Facebook error: %@", error);
        
        if ([PFUser currentUser]) {
            if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                 isEqualToString: @"OAuthException"]) {
                NSLog(@"The facebook token was invalidated");
                //[self logOut];
            }
        }
    }



#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [PAPUtility processFacebookProfilePictureData:_data];
}


@end
