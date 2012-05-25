//
//  AppDelegate.m
//  Prova
//
//  Created by Luca Gianneschi on 24/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>

#import "NILauncherViewController.h"
#import "CaricaDati.h"

//definizione del codice di PARSE
#define PARSE_ID @"YypljylfZMhggT25ZV8JbvjGoacOPCCBjegJihd1"
#define PARSE_KEY @"rPEy2sGkzbzAsNlHyME1qhwpCjzoGgBzR8XY50IH"

//definizione delle chiavi di accesso con Facebook e Twitter
#define FACEBOOK_KEY @"190431614412034"
#define TWITTER_CONSUMER @"W4XohY4N81ujkspcz6XNtw"
#define TWITTER_SECRET @"TGDzI5BlAvvggEldDamCEqiPjjGdYzFbVedIGu3Y"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize pages,dati;


#pragma facebook login methods
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url]; 
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //setto il codice di PARSE
    [Parse setApplicationId:PARSE_ID 
                  clientKey:PARSE_KEY];
    //setto il codice FACEBOOK e TWITTER per consentire il LOGIN
    [PFFacebookUtils initializeWithApplicationId:FACEBOOK_KEY];
    [PFTwitterUtils initializeWithConsumerKey:TWITTER_CONSUMER 
                               consumerSecret:TWITTER_SECRET];
    
    //qui devi passare il NIMBUSVIEWCONTROLLER
    NILauncherViewController* launcherController = [[NILauncherViewController alloc] initWithNibName:nil 
                                                                                              bundle:nil];
    
    //utilizzo la classe esterna per caricare i dati nel launchController
    [launcherController setPages:[CaricaDati inizializza]];
    


    //MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];

    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:launcherController];
    self.window.rootViewController = self.navigationController;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //[PFUser logOut];
}

@end
