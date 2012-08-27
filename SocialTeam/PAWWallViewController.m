//
//  PAWWallViewController.m
//  AnyWall
//
//  Created by Christopher Bowns on 1/30/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

#import "PAWWallViewController.h"

#import "PAWSettingsViewController.h"
#import "PAWWallPostCreateViewController.h"
#import "AppDelegate.h"
#import "PAWWallPostsTableViewController.h"
#import "PAWSearchRadius.h"
#import "PAWCircleView.h"
#import "PAWPost.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImageResizing.h"



// private methods and properties
@interface PAWWallViewController ()

@property (nonatomic, strong) CLLocationManager *_locationManager;
@property (nonatomic, strong) PAWSearchRadius *searchRadius;
@property (nonatomic, strong) PAWCircleView *circleView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, strong) PAWWallPostsTableViewController *wallPostsTableViewController;
@property (nonatomic, assign) BOOL mapPinsPlaced;
@property (nonatomic, assign) BOOL mapPannedSinceLocationUpdate;

// posts:
@property (nonatomic, strong) NSMutableArray *allPosts;




- (void)startStandardUpdates;

// CLLocationManagerDelegate methods:
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;


- (IBAction)postButtonSelected:(id)sender;
- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance;
- (void)updatePostsForLocation:(CLLocation *)location withNearbyDistance:(CLLocationAccuracy) filterDistance;

// NSNotification callbacks
- (void)distanceFilterDidChange:(NSNotification *)note;
- (void)locationDidChange:(NSNotification *)note;
- (void)postWasCreated:(NSNotification *)note;

@end

@implementation PAWWallViewController

@synthesize mapView;
@synthesize _locationManager = locationManager;
@synthesize searchRadius;
@synthesize circleView;
@synthesize annotations;
@synthesize className;
@synthesize wallPostsTableViewController;
@synthesize allPosts;
@synthesize mapPinsPlaced;
@synthesize mapPannedSinceLocationUpdate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = NSLocalizedString(@"WorldWall", @"WorldWall");
		self.className = kPAWParsePostsClassKey;
		annotations = [[NSMutableArray alloc] initWithCapacity:10];
		allPosts = [[NSMutableArray alloc] initWithCapacity:10];
	}
	return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

	

	// Set our nav bar items.
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											  initWithTitle:NSLocalizedString(@"Post", @"Post")
                                              style:UIBarButtonItemStylePlain
                                              target:self 
                                              action:@selector(postButtonSelected:)];
	

	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(distanceFilterDidChange:) 
                                                 name:kPAWFilterDistanceChangeNotification 
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(locationDidChange:) 
                                                 name:kPAWLocationChangeNotification 
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(postWasCreated:) 
                                                 name:kPAWPostCreatedNotification 
                                               object:nil];

    //qui dovresti inizializzare la mappa con la posiizone corrente dell'utente
	self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.332495, -122.029095), MKCoordinateSpanMake(0.008516, 0.021801));
    
	self.mapPannedSinceLocationUpdate = NO;
    
    //inserisco un segmentedControl per la gestione delle viste
    segmentedControl = [[UISegmentedControl alloc] initWithItems:nil];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl insertSegmentWithTitle:NSLocalizedString(@"Mappa", @"Mappa segmented controller wall") 
                                     atIndex:0 
                                    animated:NO];
    [segmentedControl insertSegmentWithTitle:NSLocalizedString(@"Lista", @"Lista segmented controller wall") 
 
                                     atIndex:1 
                                    animated:NO];
    self.navigationItem.titleView = segmentedControl;
    [segmentedControl addTarget:self 
                         action:@selector(segmentedControlPressed:)
               forControlEvents:UIControlEventValueChanged];
    
    //[locationManager startUpdatingLocation];
	[self startStandardUpdates];
}

-(void)segmentedControlPressed:(id)sender{
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self.wallPostsTableViewController.view removeFromSuperview];
            break;
        case 1:
            // Add the wall posts tableview as a subview with view containment (new in iOS 5.0):
            self.wallPostsTableViewController = [[PAWWallPostsTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self addChildViewController:self.wallPostsTableViewController];
            self.wallPostsTableViewController.view.frame = CGRectMake(0.f, 208.f, 320.f, 208.f);
            [self.view addSubview:self.wallPostsTableViewController.view];
            break;
        default:
            break;
    }
}



- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[locationManager stopUpdatingLocation];

	[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:kPAWFilterDistanceChangeNotification 
                                                  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:kPAWLocationChangeNotification 
                                                  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:kPAWPostCreatedNotification 
                                                  object:nil];

	self.mapPinsPlaced = NO; // reset this for the next time we show the map.
}

- (void)viewWillAppear:(BOOL)animated {
	[locationManager startUpdatingLocation];
	[super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[locationManager stopUpdatingLocation];
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[locationManager stopUpdatingLocation];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:kPAWFilterDistanceChangeNotification 
                                                  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:kPAWLocationChangeNotification 
                                                  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:kPAWPostCreatedNotification 
                                                  object:nil];
	
	self.mapPinsPlaced = NO; // reset this for the next time we show the map.
    [super dealloc];
}

#pragma mark - NSNotificationCenter notification handlers

- (void)distanceFilterDidChange:(NSNotification *)note {
	CLLocationAccuracy filterDistance = [[[note userInfo] objectForKey:kPAWFilterDistanceKey] doubleValue];
	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

	if (self.searchRadius == nil) {
		self.searchRadius = [[PAWSearchRadius alloc] initWithCoordinate:appDelegate.currentLocation.coordinate radius:appDelegate.filterDistance];
		[mapView addOverlay:self.searchRadius];
	} else {
		self.searchRadius.radius = appDelegate.filterDistance;
	}

	// Update our pins for the new filter distance:
	[self updatePostsForLocation:appDelegate.currentLocation withNearbyDistance:filterDistance];
	
	// If they panned the map since our last location update, don't recenter it.
	if (!self.mapPannedSinceLocationUpdate) {
		// Set the map's region centered on their location at 2x filterDistance
		MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, appDelegate.filterDistance * 2, appDelegate.filterDistance * 2);

		[mapView setRegion:newRegion animated:YES];
		self.mapPannedSinceLocationUpdate = NO;
	} else {
		// Just zoom to the new search radius (or maybe don't even do that?)
		MKCoordinateRegion currentRegion = mapView.region;
		MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(currentRegion.center, appDelegate.filterDistance * 2, appDelegate.filterDistance * 2);

		BOOL oldMapPannedValue = self.mapPannedSinceLocationUpdate;
		[mapView setRegion:newRegion animated:YES];
		self.mapPannedSinceLocationUpdate = oldMapPannedValue;
	}
}

- (void)locationDidChange:(NSNotification *)note {
	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

	// If they panned the map since our last location update, don't recenter it.
	if (!self.mapPannedSinceLocationUpdate) {
		// Set the map's region centered on their new location at 2x filterDistance
		MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, appDelegate.filterDistance * 2, appDelegate.filterDistance * 2);

		BOOL oldMapPannedValue = self.mapPannedSinceLocationUpdate;
		[mapView setRegion:newRegion animated:YES];
		self.mapPannedSinceLocationUpdate = oldMapPannedValue;
	} // else do nothing.

	// If we haven't drawn the search radius on the map, initialize it.
	if (self.searchRadius == nil) {
		self.searchRadius = [[PAWSearchRadius alloc] initWithCoordinate:appDelegate.currentLocation.coordinate radius:appDelegate.filterDistance];
		[mapView addOverlay:self.searchRadius];
	} else {
		self.searchRadius.coordinate = appDelegate.currentLocation.coordinate;
	}

	// Update the map with new pins:
	[self queryForAllPostsNearLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
	// And update the existing pins to reflect any changes in filter distance:
	[self updatePostsForLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
}

- (void)postWasCreated:(NSNotification *)note {
	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[self queryForAllPostsNearLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
}

#pragma mark - UINavigationBar-based actions


- (IBAction)postButtonSelected:(id)sender {
	PAWWallPostCreateViewController *createPostViewController = [[PAWWallPostCreateViewController alloc] initWithNibName:nil
                                                                                                                  bundle:nil];
    createPostViewController.comment = NO;
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    PFObject *nullObject = [query getFirstObject];
    createPostViewController.oggettoCommentato = nullObject;
    
	[self.navigationController presentViewController:createPostViewController 
                                            animated:YES 
                                          completion:nil];
}

#pragma mark - CLLocationManagerDelegate methods and helpers

- (void)startStandardUpdates {
	if (nil == locationManager) {
		locationManager = [[CLLocationManager alloc] init];
	}

	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;

	// Set a movement threshold for new events.
	locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;

	[locationManager startUpdatingLocation];

	CLLocation *currentLocation = locationManager.location;
	if (currentLocation) {
		AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		appDelegate.currentLocation = currentLocation;
	}
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	switch (status) {
		case kCLAuthorizationStatusAuthorized:
			NSLog(@"kCLAuthorizationStatusAuthorized");
			// Re-enable the post button if it was disabled before.
			self.navigationItem.rightBarButtonItem.enabled = YES;
			[locationManager startUpdatingLocation];
			break;
		case kCLAuthorizationStatusDenied:
			NSLog(@"kCLAuthorizationStatusDenied");
			{{
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SocialTeam non puo' accedere alla tua posizione attuale.\n\nPer vedere i post vicino a te, o per fare un post nella tua posizione attuale, attiva la geolocalizzazione per SocialTeam sotto Impostazioni -> Servizi di Localizzazione", @"messaggio actionsheet")                                                                    message:nil
                                                                   delegate:self 
                                                          cancelButtonTitle:nil 
                                                          otherButtonTitles:@"Ok", nil];
				[alertView show];
				// Disable the post button.
				self.navigationItem.rightBarButtonItem.enabled = NO;
			}}
			break;
		case kCLAuthorizationStatusNotDetermined:
			NSLog(@"kCLAuthorizationStatusNotDetermined");
			break;
		case kCLAuthorizationStatusRestricted:
			NSLog(@"kCLAuthorizationStatusRestricted");
			break;
	}
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	appDelegate.currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	NSLog(@"Error: %@", [error description]);

	if (error.code == kCLErrorDenied) {
		[locationManager stopUpdatingLocation];
	} else if (error.code == kCLErrorLocationUnknown) {
		// todo: retry?
		// set a timer for five seconds to cycle location, and if it fails again, bail and tell the user.
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errore nella rilevazione della posizione", @"Errore nella rilevazione della posizione alertView")
		                                                message:[error description]
		                                               delegate:nil
		                                      cancelButtonTitle:nil
		                                      otherButtonTitles:@"OK", nil];
		[alert show];
	}
}

#pragma mark - MKMapViewDelegate methods

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
	MKOverlayView *result = nil;
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	
	// Only display the search radius in iOS 5.1+
	if (version >= 5.1f && [overlay isKindOfClass:[PAWSearchRadius class]]) {
		result = [[PAWCircleView alloc] initWithSearchRadius:(PAWSearchRadius *)overlay];
		[(MKOverlayPathView *)result setFillColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.2]];
		[(MKOverlayPathView *)result setStrokeColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.7]];
		[(MKOverlayPathView *)result setLineWidth:2.0];
	}
	return result;
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
	// Let the system handle user location annotations.
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}

	static NSString *pinIdentifier = @"CustomPinAnnotation";

	// Handle any custom annotations.
	if ([annotation isKindOfClass:[PAWPost class]])
	{
		// Try to dequeue an existing pin view first.
		MKPinAnnotationView *pinView = (MKPinAnnotationView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];

		if (!pinView)
		{
			// If an existing pin view was not available, create one.
			pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
			                                          reuseIdentifier:pinIdentifier];
		}
		else {
			pinView.annotation = annotation;
		}
		pinView.pinColor = [(PAWPost *)annotation pinColor];
		pinView.animatesDrop = [((PAWPost *)annotation) animatesDrop];
		pinView.canShowCallout = YES;
        
        //selezione dell'avatar da PARSE
        UIImage *avatar = [[UIImage alloc] init];
        if ([[(PAWPost *)annotation user] objectForKey:@"avatar"]) {
            NSLog(@"CARICO AVATAR nell'annotation");
            //prendo l'immagine da PARSE la metto in un file, ne estraggo i dati e poi la imposto nella View
            PFFile *imageFile = [[(PAWPost *)annotation user] objectForKey:@"avatar"];
            NSData *immagine = [imageFile getData];
            avatar = [UIImage imageWithData:immagine];
            
        } else {
            avatar = [UIImage imageNamed:@"avatarPlaceHolder.png"];
        }
        //impostazione dell'immagine nel pin
        //devo ridimensionare a 32x32 px
        UIImage *resizedImage = [avatar scaledToSize:CGSizeMake(32.0f, 32.0f)];
        UIImageView *leftImage = [[UIImageView alloc] initWithImage:resizedImage];
        pinView.leftCalloutAccessoryView = leftImage;
        
        
        //impostazione del bottone di callout sulla annotation
        UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = disclosureButton;
		return pinView;
	}

	return nil;
}

//aggiungo il metodo per il callout alla pressione del bottone a destra della annotazione
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    id<MKAnnotation> annotation = [view annotation];
    	if ([annotation isKindOfClass:[PAWPost class]]) {
           PAWPost *post = [view annotation];
        NSLog(@"chi ha fatto il post: %@",post.user.username);
            //qui devi fare il push del viewcontroller che mostra il profilo dell'utente che ha fatto il post; devi fare un check sulla privacy impostata dall'utente
       }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	id<MKAnnotation> annotation = [view annotation];
	if ([annotation isKindOfClass:[PAWPost class]]) {
		PAWPost *post = [view annotation];
		[wallPostsTableViewController highlightCellForPost:post];
	} else if ([annotation isKindOfClass:[MKUserLocation class]]) {
		// Center the map on the user's current location:
		AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, appDelegate.filterDistance * 2, appDelegate.filterDistance * 2);

		[self.mapView setRegion:newRegion animated:YES];
		self.mapPannedSinceLocationUpdate = NO;
	}
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	id<MKAnnotation> annotation = [view annotation];
	if ([annotation isKindOfClass:[PAWPost class]]) {
		PAWPost *post = [view annotation];
		[wallPostsTableViewController unhighlightCellForPost:post];
	}
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
	self.mapPannedSinceLocationUpdate = YES;
}

#pragma mark - Fetch map pins

- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance {
	PFQuery *query = [PFQuery queryWithClassName:self.className];

	if (currentLocation == nil) {
		NSLog(@"%s got a nil location!", __PRETTY_FUNCTION__);
	}

	// If no objects are loaded in memory, we look to the cache first to fill the table
	// and then subsequently do a query against the network.
	if ([self.allPosts count] == 0) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}

	// Query for posts sort of kind of near our current location.
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
	[query whereKey:kPAWParseLocationKey nearGeoPoint:point withinKilometers:kPAWWallPostMaximumSearchDistance];
	[query includeKey:kPAWParseUserKey];
	query.limit = kPAWWallPostsSearch;

	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			NSLog(@"error in geo query!"); // todo why is this ever happening?
		} else {
			// We need to make new post objects from objects,
			// and update allPosts and the map to reflect this new array.
			// But we don't want to remove all annotations from the mapview blindly,
			// so let's do some work to figure out what's new and what needs removing.

			// 1. Find genuinely new posts:
			NSMutableArray *newPosts = [[NSMutableArray alloc] initWithCapacity:kPAWWallPostsSearch];
			// (Cache the objects we make for the search in step 2:)
			NSMutableArray *allNewPosts = [[NSMutableArray alloc] initWithCapacity:kPAWWallPostsSearch];
			for (PFObject *object in objects) {
				PAWPost *newPost = [[PAWPost alloc] initWithPFObject:object];
				[allNewPosts addObject:newPost];
				BOOL found = NO;
				for (PAWPost *currentPost in allPosts) {
					if ([newPost equalToPost:currentPost]) {
						found = YES;
					}
				}
				if (!found) {
					[newPosts addObject:newPost];
				}
			}
			// newPosts now contains our new objects.

			// 2. Find posts in allPosts that didn't make the cut.
			NSMutableArray *postsToRemove = [[NSMutableArray alloc] initWithCapacity:kPAWWallPostsSearch];
			for (PAWPost *currentPost in allPosts) {
				BOOL found = NO;
				// Use our object cache from the first loop to save some work.
				for (PAWPost *allNewPost in allNewPosts) {
					if ([currentPost equalToPost:allNewPost]) {
						found = YES;
					}
				}
				if (!found) {
					[postsToRemove addObject:currentPost];
				}
			}
			// postsToRemove has objects that didn't come in with our new results.

			// 3. Configure our new posts; these are about to go onto the map.
			for (PAWPost *newPost in newPosts) {
				CLLocation *objectLocation = [[CLLocation alloc] initWithLatitude:newPost.coordinate.latitude longitude:newPost.coordinate.longitude];
				// if this post is outside the filter distance, don't show the regular callout.
				CLLocationDistance distanceFromCurrent = [currentLocation distanceFromLocation:objectLocation];
				[newPost setTitleAndSubtitleOutsideDistance:( distanceFromCurrent > nearbyDistance ? YES : NO )];
				// Animate all pins after the initial load:
				newPost.animatesDrop = mapPinsPlaced;
			}

			// At this point, newAllPosts contains a new list of post objects.
			// We should add everything in newPosts to the map, remove everything in postsToRemove,
			// and add newPosts to allPosts.
			[mapView removeAnnotations:postsToRemove];
			[mapView addAnnotations:newPosts];
			[allPosts addObjectsFromArray:newPosts];
			[allPosts removeObjectsInArray:postsToRemove];

			self.mapPinsPlaced = YES;
		}
	}];
}

// When we update the search filter distance, we need to update our pins' titles to match.
- (void)updatePostsForLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy) nearbyDistance {
	for (PAWPost *post in allPosts) {
		CLLocation *objectLocation = [[CLLocation alloc] initWithLatitude:post.coordinate.latitude longitude:post.coordinate.longitude];
		// if this post is outside the filter distance, don't show the regular callout.
		CLLocationDistance distanceFromCurrent = [currentLocation distanceFromLocation:objectLocation];
		if (distanceFromCurrent > nearbyDistance) { // Outside search radius
			[post setTitleAndSubtitleOutsideDistance:YES];
			[mapView viewForAnnotation:post];
			[(MKPinAnnotationView *) [mapView viewForAnnotation:post] setPinColor:post.pinColor];
		} else {
			[post setTitleAndSubtitleOutsideDistance:NO]; // Inside search radius
			[mapView viewForAnnotation:post];
			[(MKPinAnnotationView *) [mapView viewForAnnotation:post] setPinColor:post.pinColor];
		}
	}
}

@end
