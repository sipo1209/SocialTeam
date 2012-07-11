//
//  UserListViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 02/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserListViewController.h"
#import "ActionSheetPicker.h"


@interface UserListViewController ()
- (void)orderSelected:(NSNumber *)selIndex element:(id)element;

@end

@implementation UserListViewController
@synthesize selectedIndex,actionSheetPicker,indices;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.className = @"User";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}


#pragma mark - Parse

-(void)objectsWillLoad{
    [super objectsWillLoad];
}

-(void)objectsDidLoad:(NSError *)error{
    //indices = [self getLetter:self.objects];
    [super objectsDidLoad:error];
}

#pragma mark - Query

//manca da implementare la ripetizione della query
-(PFQuery *)queryForTable{
    PFQuery *query = [PFUser query];
    switch (self.selectedIndex) {
        case 0:
            NSLog(@"cronologico");
            [query whereKeyExists:@"username"];
            if ([self.objects count] == 0){
                query.cachePolicy = kPFCachePolicyCacheThenNetwork;
            }
            query.limit = 25;
            [query orderByDescending:@"createdAt"];
            break;
        case 1:
             NSLog(@"alfabetico");
            [query whereKeyExists:@"username"];
            if ([self.objects count] == 0){
                query.cachePolicy = kPFCachePolicyCacheThenNetwork;
            }
            query.limit = 25;
            [query orderByDescending:@"username"];
            break;
        case 2:
             NSLog(@"Anticronologico");
            [query whereKeyExists:@"username"];
            if ([self.objects count] == 0){
                query.cachePolicy = kPFCachePolicyCacheThenNetwork;
            }
            query.limit = 25;
            [query orderByAscending:@"createdAt"];
            break;
        default:
            break;
    }
    return query;
}


#pragma mark - TableView Delegate Methods
- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    static NSString *cellIdentifier = @"Cell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    //impostazione della cella
    /*
    NSString *alphabet = [[self.objects  objectAtIndex:indexPath.section] objectForKey:@"username"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@",alphabet];
    NSArray *utentiPerLettera = [[self.objects filteredArrayUsingPredicate:predicate];
    
    if ([utentiPerLettera count]> 0) {
        cell.textLabel.text = [[utentiPerLettera objectAtIndex:indexPath.row] objectForKey:@"username"];
        cell.detailTextLabel.text = [[utentiPerLettera objectAtIndex:indexPath.row] objectForKey:@"username"];
    }
    */
                                 
    cell.textLabel.text = [object objectForKey:@"username"];
    cell.detailTextLabel.text = [object objectForKey:@"nome"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    //impostazione dell'immagine nella tabela di query
    UIImage *imageToResize = [UIImage imageNamed:@"avatarPlaceholder.png"];
    UIImage *resizedImage =[imageToResize scaledToSize:CGSizeMake(48.0f, 48.0f)];
    cell.imageView.image = resizedImage;
    cell.imageView.file = (PFFile *) [object objectForKey:@"avatar"];
    [cell.imageView loadInBackground:NULL];
     
    return cell;
}


//metodo per il passaggio alla nuova pagina,riesegue la query per mostrare nuova pagina
- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NextPage";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = NSLocalizedString(@"Carica Altri Utenti", @"Carica Altri Post Label");
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NSLog(@"Selezionato");
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - PickerViewActions
//presenta il picker

- (void)ordinaUtenti:(id)sender{
     [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Ordina Utenti", @"Ordina Utenti Titolo PickerView") 
                                             rows:pickerTitles 
                                 initialSelection:self.selectedIndex 
                                           target:self 
                                    successAction:@selector(orderSelected:element:) 
                                     cancelAction:@selector(actionPickerCancelled:) 
                                           origin:sender];
    
}


- (void)texFieldTapped:(UIBarButtonItem *)sender {
    [self ordinaUtenti:sender];
}

//esegue un'azione in base a quale cella e' stata premuta
- (void)orderSelected:(NSNumber *)selIndex element:(id)element {
    [self clear];
    self.selectedIndex = [selIndex intValue];
    [self queryForTable];
    
    //impostazione dell'HUD
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = NSLocalizedString(@"Caricamento...", @"Caricamento... HUD");
	[self loadObjects];
	[HUD showWhileExecuting:@selector(loadObjects) 
                   onTarget:self 
                 withObject:nil 
                   animated:YES];
    
}
#pragma mark - tableViewDelegate

/*
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [indices count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [indices objectAtIndex:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *alphabet = [indices objectAtIndex:section];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@",alphabet];
    NSArray *utentiPerLettera = [indices filteredArrayUsingPredicate:predicate];
    return [utentiPerLettera count];
}

*/
#pragma mark - Indici

/*
//metodo per prendere la prima lettere 
-(NSMutableArray *)getLetter:(NSArray *)indici{
    NSMutableArray *iniziali = [[NSMutableArray alloc] init];
    //prendo la prima lettera di ciascun username
    for (int i = 0; i < [self.objects count]; i = i +1) {
        char alphabet = [[[self.objects objectAtIndex:i] objectForKey:@"username"] characterAtIndex:0];
        NSString *uniChar = [NSString stringWithFormat:@"%C",alphabet];
        if(![iniziali containsObject:uniChar]){
            [iniziali addObject:uniChar];
        }
    } 
    return iniziali;
}


//metodi per l'impostazione degli indici
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return indices;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return [indices indexOfObject:title];
}
*/

#pragma mark - LifeCicle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    pickerTitles = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Piu Recenti", @"Piu Recenti Picker"),
                                                    NSLocalizedString(@"A-Z", @"Ordine Alfabetico Picker"),
                                                    NSLocalizedString(@"Piu' Attivi", @"Piu' Attivi Picker"),
                                                    nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Ordina Utenti", @"Ordina Utenti rightBarButtonItem") 
                                                                             style:UIBarButtonItemStylePlain 
                                                                            target:self 
                                                                            action:@selector(ordinaUtenti:)];
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

-(void)actionPickerCancelled:(id)sender {
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}


@end
