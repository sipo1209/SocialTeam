//
//  ListaSitiViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 24/08/12.
//
//

#import "ListaSitiViewController.h"
#import "SitiViewController.h"

@interface ListaSitiViewController ()

@end

@implementation ListaSitiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.className = @"Websites";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
        self.title = NSLocalizedString(@"Siti", @"Websites titolo viewcontroller");
    }
    return self;
}
#pragma mark - Query

-(PFQuery *)queryForTable{
    PFQuery *query = [PFQuery queryWithClassName:@"Websites"];
    [query whereKeyExists:@"createdAt"];
    if ([self.objects count] == 0){
                query.cachePolicy = kPFCachePolicyCacheThenNetwork;
            }
            query.limit = 25;
    [query orderByDescending:@"createdAt"];
    return query;
}

-(PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    static NSString *cellIdentifier = @"Cell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    //prendo gli elementi della cella che mi interessano
    
    
    //imposto la cella
    cell.textLabel.text = [object objectForKey:@"Title"];
    cell.detailTextLabel.text = [object objectForKey:@"SubTitle"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //imposto l'immagine
    UIImage *imageToResize = [UIImage imageNamed:@"placeholder.png"];
    UIImage *resizedImage =[imageToResize scaledToSize:CGSizeMake(48.0f, 48.0f)];
    cell.imageView.image = resizedImage;
    cell.imageView.file = (PFFile *) [object objectForKey:@"image"];
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
    cell.textLabel.text = NSLocalizedString(@"Carica Altri Siti", @"Carica Altri Utenti Label");
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
	//[super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NSLog(@"selezione");
    SitiViewController *sitoSelezionato = [[SitiViewController alloc] init];
    sitoSelezionato.title = [[self.objects objectAtIndex:indexPath.row] objectForKey:@"Title"];
    sitoSelezionato.url = [NSURL URLWithString:[[self.objects objectAtIndex:indexPath.row] objectForKey:@"URL"]];
    
    [self.navigationController pushViewController:sitoSelezionato
                                         animated:YES];
    
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
