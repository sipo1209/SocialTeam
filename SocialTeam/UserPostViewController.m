//
//  UserPostViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 26/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserPostViewController.h"

@interface UserPostViewController ()

@end

@implementation UserPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.className = @"Posts";
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
    [super objectsDidLoad:error];
}


-(PFQuery *)queryForTable{
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query whereKey:@"user" equalTo:currentUser];
    if ([self.objects count] == 0){
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    query.limit = 25;
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
    cell.textLabel.text = [object objectForKey:@"text"];
    
    //FORMATTARE LA DATA IN MODO CORRETTO
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-ddTHH:mm.sss"];
    NSString *dateString = [dateFormat stringFromDate:[object objectForKey:@"createdAt"]];
    NSString *detail = NSLocalizedString(@"Data: ", @"Data Label tabella Post");
    
    //RITORNARE LA CELLA
    cell.detailTextLabel.text = [detail stringByAppendingFormat:@" %d",dateString];
 
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
    cell.textLabel.text = NSLocalizedString(@"Carica Altri Post", @"Carica Altri Post Label");
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //fare un check se serve questa chiamata
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		//elimina l'elemento dalla lista
        [[self.objects objectAtIndex:indexPath.row] delete];

		//elimina le'elemento dalla tabella
        [self clear];
		[self loadObjects];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - TableViewLifeCicle
- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"just_background@2x.png"]]; 
    //impostazione de
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
