//
//  ListaUtentiViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListaUtentiViewController.h"

@interface ListaUtentiViewController ()

@end

@implementation ListaUtentiViewController
@synthesize tableData;

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

#pragma mark - tableViewDelegate

 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 //we use sectionTitles and not sections
     return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return [[self.tableData objectAtIndex:section] count];
 }
 
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
     BOOL showSection = [[self.tableData objectAtIndex:section] count] != 0;
     //only show the section title if there are rows in the section
     return (showSection) ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
 }

-(PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    static NSString *cellIdentifier = @"Cell";
   PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    //prendo gli elementi della cella che mi interessano
    NSArray *objects = [self.tableData objectAtIndex:indexPath.section];
    PFObject *oggetto = [objects objectAtIndex:indexPath.row];
    
    //imposto la cella
    cell.textLabel.text = [oggetto objectForKey:@"username"];
    cell.detailTextLabel.text = [oggetto objectForKey:@"nome"];                   
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //imposto l'immagine
    UIImage *imageToResize = [UIImage imageNamed:@"avatarPlaceholder.png"];
    UIImage *resizedImage =[imageToResize scaledToSize:CGSizeMake(48.0f, 48.0f)];
    cell.imageView.image = resizedImage;
    cell.imageView.file = (PFFile *) [oggetto objectForKey:@"avatar"];
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
    NSLog(@"Selezionato %@ sezione %d riga %d",[[self.objects objectAtIndex:indexPath.row] objectForKey:@"nome"],indexPath.section,indexPath.row);
    
    NSLog(@"Selezionato %@ sezione %d riga %d",[[self.objects objectAtIndex:indexPath.row] objectForKey:@"cognome"],indexPath.section,indexPath.row);
    
    
    NSLog(@"Selezionato %@ sezione %d riga %d",[[self.objects objectAtIndex:indexPath.row] objectForKey:@"username"],indexPath.section,indexPath.row);
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    ;
}

#pragma mark - Indici
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    //sectionForSectionIndexTitleAtIndex: is a bit buggy, but is still useable
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

#pragma mark - Organizzazione dei dati
 
 
-(void)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector{
         UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
         
         NSInteger sectionCount = [[collation sectionTitles] count]; //section count is take from sectionTitles and not sectionIndexTitles
         NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
         
         //create an array to hold the data for each section
         for(int i = 0; i < sectionCount; i++){
             [unsortedSections addObject:[NSMutableArray array]];
         }
         
         //put each object into a section
         for (id object in array){
             NSInteger index = [collation sectionForObject:object 
                                   collationStringSelector:selector];
             
             [[unsortedSections objectAtIndex:index] addObject:object];
         }
         
         NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
         
         //sort each section
         for (NSMutableArray *section in unsortedSections)
         {
             [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:selector]];
         }
        NSLog(@"%@ tabledata",self.tableData);
         self.tableData = sections;
}



#pragma mark - Parse

-(void)objectsWillLoad{
    
    [super objectsWillLoad];
}

-(void)objectsDidLoad:(NSError *)error{
    //inizio l'ordinamento dei dati
    [self partitionObjects:self.objects 
   collationStringSelector:@selector(username)];
    [super objectsDidLoad:error];
}

//manca da implementare la ripetizione della query
-(PFQuery *)queryForTable{
    PFQuery *query = [PFUser query];
    [query whereKeyExists:@"username"];
    if ([self.objects count] == 0){
                query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    query.limit = 25;
    [query orderByDescending:@"username"];
    return query;
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
