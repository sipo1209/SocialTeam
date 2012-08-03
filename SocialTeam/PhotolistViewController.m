//
//  PhotolistViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 14/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotolistViewController.h"
#import "PhotoDetailViewController.h"
#import "PAPEditPhotoViewController.h"

//va implementato un controller di dettaglio con un toolbar che consenta di fare un commento 
@interface PhotolistViewController ()

@end

@implementation PhotolistViewController

#define PADDING_TOP 0 // For placing the images nicely in the grid
#define PADDING 4
#define THUMBNAIL_COLS 4
#define THUMBNAIL_WIDTH 75
#define THUMBNAIL_HEIGHT 75

#pragma mark - Main methods

- (void)refresh:(id)sender
{
    NSLog(@"Showing Refresh HUD");
    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:refreshHUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    refreshHUD.delegate = self;
	
    // Show the HUD while the provided method executes in a new thread
    [refreshHUD show:YES];
    
    //faccio la query su Photo, la classe di Anypic
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    //PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    //PFUser *user = [PFUser currentUser];
    
    //prendo tutte le foto in questo caso, non solo quelle dell'utente corrente
    [query whereKeyExists:@"createdAt"];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if (refreshHUD) {
                [refreshHUD hide:YES];
                
                refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:refreshHUD];
                
                // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
                // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
                refreshHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                
                // Set custom view mode
                refreshHUD.mode = MBProgressHUDModeCustomView;
                
                refreshHUD.delegate = self;
            }
            
            NSLog(@"Successfully retrieved %d photos.", objects.count);
            
            // Retrieve existing objectIDs
            
            NSMutableArray *oldCompareObjectIDArray = [NSMutableArray array];
            for (UIView *view in [photoScrollView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *eachButton = (UIButton *)view;
                    [oldCompareObjectIDArray addObject:[eachButton titleForState:UIControlStateReserved]];
                }
            }
            
            NSMutableArray *oldCompareObjectIDArray2 = [NSMutableArray arrayWithArray:oldCompareObjectIDArray];
            
            // If there are photos, we start extracting the data
            // Save a list of object IDs while extracting this data
            
            NSMutableArray *newObjectIDArray = [NSMutableArray array];            
            if (objects.count > 0) {
                for (PFObject *eachObject in objects) {
                    [newObjectIDArray addObject:[eachObject objectId]];
                }
            }
            
            // Compare the old and new object IDs
            NSMutableArray *newCompareObjectIDArray = [NSMutableArray arrayWithArray:newObjectIDArray];
            NSMutableArray *newCompareObjectIDArray2 = [NSMutableArray arrayWithArray:newObjectIDArray];
            if (oldCompareObjectIDArray.count > 0) {
                // New objects
                [newCompareObjectIDArray removeObjectsInArray:oldCompareObjectIDArray];
                // Remove old objects if you delete them using the web browser
                [oldCompareObjectIDArray removeObjectsInArray:newCompareObjectIDArray2];
                if (oldCompareObjectIDArray.count > 0) {
                    // Check the position in the objectIDArray and remove
                    NSMutableArray *listOfToRemove = [[NSMutableArray alloc] init];
                    for (NSString *objectID in oldCompareObjectIDArray){
                        int i = 0;
                        for (NSString *oldObjectID in oldCompareObjectIDArray2){
                            if ([objectID isEqualToString:oldObjectID]) {
                                // Make list of all that you want to remove and remove at the end
                                [listOfToRemove addObject:[NSNumber numberWithInt:i]];
                            }
                            i++;
                        }
                    }
                    
                    // Remove from the back
                    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
                    [listOfToRemove sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
                    
                    for (NSNumber *index in listOfToRemove){                        
                        [allImages removeObjectAtIndex:[index intValue]];
                    }
                }
            }
            
            // Add new objects
            for (NSString *objectID in newCompareObjectIDArray){
                for (PFObject *eachObject in objects){
                    if ([[eachObject objectId] isEqualToString:objectID]) {
                        NSMutableArray *selectedPhotoArray = [[NSMutableArray alloc] init];
                        [selectedPhotoArray addObject:eachObject];
                        
                        if (selectedPhotoArray.count > 0) {
                            [allImages addObjectsFromArray:selectedPhotoArray];                
                        }
                    }
                }
            }
            
            // Remove and add from objects before this
            [self setUpImages:allImages];
            
        } else {
            [refreshHUD hide:YES];
            
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)setUpImages:(NSArray *)images
{
    // Contains a list of all the BUTTONS
    allImages = [images mutableCopy];
    
    // This method sets up the downloaded images and places them nicely in a grid
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSMutableArray *imageDataArray = [NSMutableArray array];
        
        // Iterate over all images and get the data from the PFFile
        for (int i = 0; i < images.count; i++) {
            PFObject *eachObject = [images objectAtIndex:i];
            PFFile *theImage = [eachObject objectForKey:@"image"];
            NSData *imageData = [theImage getData];
            UIImage *image = [UIImage imageWithData:imageData];
            [imageDataArray addObject:image];
        }
        
        // Dispatch to main thread to update the UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // Remove old grid
            for (UIView *view in [photoScrollView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    [view removeFromSuperview];
                }
            }
            
            // Create the buttons necessary for each image in the grid
            for (int i = 0; i < [imageDataArray count]; i++) {
                PFObject *eachObject = [images objectAtIndex:i];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *image = [imageDataArray objectAtIndex:i];
                [button setImage:image forState:UIControlStateNormal];
                button.showsTouchWhenHighlighted = YES;
                [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                button.frame = CGRectMake(THUMBNAIL_WIDTH * (i % THUMBNAIL_COLS) + PADDING * (i % THUMBNAIL_COLS) + PADDING,
                                          THUMBNAIL_HEIGHT * (i / THUMBNAIL_COLS) + PADDING * (i / THUMBNAIL_COLS) + PADDING + PADDING_TOP,
                                          THUMBNAIL_WIDTH,
                                          THUMBNAIL_HEIGHT);
                button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [button setTitle:[eachObject objectId] forState:UIControlStateReserved];
                [photoScrollView addSubview:button];
            }
            
            // Size the grid accordingly
            int rows = images.count / THUMBNAIL_COLS;
            if (((float)images.count / THUMBNAIL_COLS) - rows != 0) {
                rows++;
            }
            int height = THUMBNAIL_HEIGHT * rows + PADDING * rows + PADDING + PADDING_TOP;
            
            photoScrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
            photoScrollView.clipsToBounds = YES;
        });
    });
}

- (void)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = NSLocalizedString(@"Caricamento Foto", @"Caricamento Foto HUD");
    [HUD show:YES];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //Hide determinate HUD
            [HUD hide:YES];
            
            // Show checkmark
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
            // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            
            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;
            
            HUD.delegate = self;
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:imageFile 
                          forKey:@"imageFile"];
            
            // Privilegi sulle foto: l'utente che ha fatto l'upload legge e scrive, gli altri vedono soltanto
            PFACL *photoACL = [PFACL ACL];
            [photoACL setPublicWriteAccess:YES];
            [photoACL setPublicReadAccess:YES];
            [userPhoto setACL:photoACL];
            
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self refresh:nil];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            [HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        HUD.progress = (float)percentDone/100;
    }];
    
    
}

- (void)buttonTouched:(id)sender {
    // When picture is touched, open a viewcontroller with the image
    PFObject *theObject = (PFObject *)[allImages objectAtIndex:[sender tag]];
    PFFile *theImage = [theObject objectForKey:@"image"];
    
    NSData *imageData;
    imageData = [theImage getData];
    UIImage *selectedPhoto = [UIImage imageWithData:imageData];
    //qui faccio il passaggio del viewController di interesse, inserisco il viewcontroller con i commenti
    /*
    PhotoDetailViewController *pdvc = [[PhotoDetailViewController alloc] init];
    
    pdvc.selectedImage = selectedPhoto;
    pdvc.photo = theObject;
    NSLog(@"pdvc id %@", theObject.objectId);
    //[self presentModalViewController:pdvc animated:YES];
    [self.navigationController pushViewController:pdvc 
                                         animated:YES];
     */
    PAPEditPhotoViewController *editPhoto = [[PAPEditPhotoViewController alloc] initWithImage:selectedPhoto];
    [self.navigationController pushViewController:editPhoto
                                         animated:YES];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"SocialFoto", @"Social Foto Titolo Pagina");
        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera 
                                                                                      target:self 
                                                                                      action:@selector(cameraButtonTapped:)];
        
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                       target:self 
                                                                                       action:@selector(refresh:)];
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:cameraButton,refreshButton, nil];
    }
    return self;
}

//DELEGATI DEL PICKER DELLE FOTO DAI SOCIAL NETWORK
-(void) PhotoPickerPlusControllerDidCancel:(PhotoPickerPlus *)picker{
    [self dismissViewControllerAnimated:YES 
                             completion:^(void){
                                 
                             }];
}
-(void)PhotoPickerPlusController:(PhotoPickerPlus *)picker didFinishPickingArrayOfMediaWithInfo:(NSArray *)info{
    
}
-(void) PhotoPickerPlusController:(PhotoPickerPlus *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES 
                             completion:^(void){
                                 
                                 UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                                 
                                 // Resize image
                                 UIGraphicsBeginImageContext(CGSizeMake(640, 960));
                                 [image drawInRect: CGRectMake(0, 0, 640, 960)];
                                 UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
                                 UIGraphicsEndImageContext();   
                                 
                                 // Upload image
                                 NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
                                 [self uploadImage:imageData];
                                 
                             }];
    
}


- (void)cameraButtonTapped:(id)sender
{
    //quando si preme il pulsante camera viene fuori il picker che prende le foto sia dalla camera sia dai social network
    PhotoPickerPlus *temp = [[PhotoPickerPlus alloc] init];
    [temp setDelegate:self];
    [temp setModalPresentationStyle:UIModalPresentationCurrentContext];
    [temp setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:temp animated:YES 
                     completion:^(void){
                         [temp release];
                     }];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [self refresh:self];
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    allImages = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [HUD removeFromSuperview];
	HUD = nil;
}

@end
