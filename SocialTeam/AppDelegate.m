//
//  AppDelegate.m
//  Prova
//
//  Created by Luca Gianneschi on 24/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


static NSString * const defaultsFilterDistanceKey = @"filterDistance";
static NSString * const defaultsLocationKey = @"currentLocation";

#import "AppDelegate.h"

//importazione FRAMEWORK
#import <Parse/Parse.h>

//importazione Classi
#import "NILauncherViewController.h"
#import "CaricaDati.h"
#import "Appirater.h"
#import "Reachability.h"

//definizione del codice di PARSE
#define PARSE_ID @"YypljylfZMhggT25ZV8JbvjGoacOPCCBjegJihd1"
#define PARSE_KEY @"rPEy2sGkzbzAsNlHyME1qhwpCjzoGgBzR8XY50IH"

//definizione delle chiavi di accesso con Facebook e Twitter
#define FACEBOOK_KEY @"190431614412034"
#define TWITTER_CONSUMER @"W4XohY4N81ujkspcz6XNtw"
#define TWITTER_SECRET @"TGDzI5BlAvvggEldDamCEqiPjjGdYzFbVedIGu3Y"

@interface AppDelegate ()

void uncaughtExceptionHandler(NSException *exception);

@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize pages,dati;
@synthesize currentLocation,filterDistance;


@synthesize hostReach;
@synthesize internetReach;
@synthesize wifiReach;
@synthesize networkStatus;

#pragma mark - LOCAL NOTIFICATION
-(void)applicationDidReceiveLocalNotification:(UILocalNotification *) notif{
    //inserire un alertView per dire che e' un giorno impostante per la squadra
}

#pragma mark - WALL
- (void)setFilterDistance:(CLLocationAccuracy)aFilterDistance
{
	filterDistance = aFilterDistance;
    
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setDouble:filterDistance forKey:defaultsFilterDistanceKey];
	[userDefaults synchronize];
    
	// Notify the app of the filterDistance change:
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:filterDistance] forKey:kPAWFilterDistanceKey];
	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:kPAWFilterDistanceChangeNotification 
                                                            object:nil 
                                                          userInfo:userInfo];
	});
}

// We also add a method to be called when the location changes.
// This is where we post the notification to all observers.
- (void)setCurrentLocation:(CLLocation *)aCurrentLocation
{
	currentLocation = aCurrentLocation;
    
	// Notify the app of the location change:
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:currentLocation forKey:kPAWLocationKey];
	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:kPAWLocationChangeNotification 
                                                            object:nil 
                                                          userInfo:userInfo];
	});
    NSLog(@"Chiamato");
    NSString *tmp = [[NSString alloc] initWithFormat:@"%f", currentLocation.coordinate.latitude];
    NSLog(@"%@",tmp);
    NSString *tmp1 = [[NSString alloc] initWithFormat:@"%f", currentLocation.coordinate.longitude];
    NSLog(@"%@",tmp1);
}


#pragma facebook login methods
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url]; 
}

#pragma mark APPDELEGATE

- (void)logOut {
    // clear cache
    [[PAPCache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications
    [[PFInstallation currentInstallation] removeObjectForKey:kPAPInstallationUserKey];
    [[PFInstallation currentInstallation] removeObject:[[PFUser currentUser] objectForKey:kPAPUserPrivateChannelKey] forKey:kPAPInstallationChannelsKey];
    [[PFInstallation currentInstallation] saveEventually];
    
    // Log out
    [PFUser logOut];
    
    //DA RIVEDERE questa chiamata
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)monitorReachability {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostName: @"api.parse.com"];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    //CODICE PER GESTIONE LOCAL NOTIFICATION
    UILocalNotification *notifica =[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notifica) {
        NSLog(@"Avviato da Notifica Locale");
    }
    //cancello tutte le local notification, poi le ricreo ogni volta
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = 0;
    
    
    
    //setto il codice di PARSE
    [Parse setApplicationId:PARSE_ID 
                  clientKey:PARSE_KEY];
    
    //setto il codice FACEBOOK e TWITTER per consentire il LOGIN
    [PFFacebookUtils initializeWithApplicationId:FACEBOOK_KEY];
    
    
    [PFTwitterUtils initializeWithConsumerKey:TWITTER_CONSUMER
                               consumerSecret:TWITTER_SECRET];
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveEventually];
    }
    
    ///FAI UN CONTROLLO SULLA CONNESSIONE: se non e' presente la connessione fai il push di un VIEWCONTROLLER DI "SPIACENTI, MA l'APP FUNZIONA SOLO SE CONNESSI
    // Use Reachability to monitor connectivity
    [self monitorReachability];
    
    //qui devi passare il NIMBUSVIEWCONTROLLER
    NILauncherViewController* launcherController = [[NILauncherViewController alloc] initWithNibName:nil 
                                                                                              bundle:nil];
    
    //utilizzo la classe esterna per caricare i dati nel launchController
    [launcherController setPages:[CaricaDati inizializza]];
    
    

    // Grab values from NSUserDefaults:
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // Desired search radius:
	if ([userDefaults doubleForKey:defaultsFilterDistanceKey]) {
		// use the ivar instead of self.accuracy to avoid an unnecessary write to NAND on launch.
		filterDistance = [userDefaults doubleForKey:defaultsFilterDistanceKey];
	} else {
		// if we have no accuracy in defaults, set it to 1000 feet.
        
		self.filterDistance = 1000 * kPAWFeetToMeters;
	}
	
    //IMPOSTAZIONE DEL NAVIGATION CONTROLLER
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:launcherController];
    self.window.rootViewController = self.navigationController;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    
    //introduco Appirater per la valutazione dell'APP
    [Appirater appLaunched];
    
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

- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}


//queata funzione fa si che si seguano in automatico tutti quelli di FB che si conoscono e che gia' usano l'applicazione
- (void)autoFollowTimerFired:(NSTimer *)aTimer {
    //[MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
    //[MBProgressHUD hideHUDForView:self.homeViewController.view animated:YES];
    //[self.homeViewController loadObjects];
}


//Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification* )note {
    Reachability *curReach = (Reachability *)[note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NSLog(@"Reachability changed: %@", curReach);
    networkStatus = [curReach currentReachabilityStatus];
    
    if ([self isParseReachable] && [PFUser currentUser]) {
        // Refresh home timeline on network restoration. Takes care of a freshly installed app that failed to load the main timeline under bad network conditions.
        // In this case, they'd see the empty timeline placeholder and have no way of refreshing the timeline unless they followed someone.
        //[self.homeViewController loadObjects];
    }
}

@end
