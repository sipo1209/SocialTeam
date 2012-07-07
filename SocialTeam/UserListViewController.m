//
//  UserListViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 02/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserListViewController.h"


@interface UserListViewController ()

@end

@implementation UserListViewController



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

-(void)mostraPicker{
    
}

#pragma mark - Parse

-(void)objectsWillLoad{
    [super objectsWillLoad];
}

-(void)objectsDidLoad:(NSError *)error{
    [super objectsDidLoad:error];
}


-(PFQuery *)queryForTable{
    PFQuery *query = [PFUser query];
    [query whereKeyExists:@"username"];
    if ([self.objects count] == 0){
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    query.limit = 25;
    [query orderByDescending:@"createdAt"];
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

-(void)displayPicker:(id)sender{
    picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 236, 320, 200)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.hidden = NO;
    [picker reloadAllComponents];
    picker.showsSelectionIndicator = YES;
    [picker selectRow:0 inComponent:0 
             animated:YES];
    [self.view addSubview:picker];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Ordina", @"Ordina titolo bottone barra navigazione userlist") 
                                                                              style:UIBarButtonItemStylePlain 
                                                                             target:self 
                                                                             action:@selector(displayPicker:)];
    picker.hidden = YES;
    pickerTitles = [NSArray arrayWithObjects:NSLocalizedString(@"A-Z", @"Ordinamento Alfabetico"),
                                             NSLocalizedString(@"Piu' Recenti", @"Piu' Recenti Picker"),
                    NSLocalizedString(@"Maggiormente Attivi", @"Maggiormente Attivi Picker"),nil];
    
    //imposto la selezione di A-Z come default
    
    
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
#pragma mark PickerDelegate Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [pickerTitles count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [pickerTitles objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
   
    switch (row) {
        case 0:
            NSLog(@"ORDINE ALFABETICO");
            
            break;
          case 1:  
             NSLog(@"ORDINE CRONOLOGICO");
            break;
        case 2:  
            NSLog(@"ORDINE PER ATTIVITA'");
            break;   
        default:
            break;
    }
}

@end
