//
//  CommentListViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentListViewController.h"
#import "UIImageResizing.h"

@interface CommentListViewController ()

@end

@implementation CommentListViewController
@synthesize oggettoCommentato;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
-(PFQuery *)queryForTable{
    PFObject *currentPhoto = self.oggettoCommentato;
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query whereKey:@"oggetto" equalTo:currentPhoto];
    if ([self.objects count] == 0){
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query orderByDescending:@"createdAt"];
    query.limit = 25;
    return query;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView Delegate Methods
- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    static NSString *cellIdentifier = @"Cell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    NSLog(@"%@",[object objectForKey:@"user"] );
    
    PFUser *userForComment = (PFUser *)[[object objectForKey:@"user"] fetchIfNeeded];
    cell.textLabel.text = userForComment.username;
    
    cell.detailTextLabel.text = [object objectForKey:@"text"];
    
    
    UIImage *imageToResize = [UIImage imageNamed:@"avatarPlaceholder.png"];
    UIImage *resizedImage =[imageToResize scaledToSize:CGSizeMake(48.0f, 48.0f)];
    cell.imageView.image = resizedImage;
    
    cell.imageView.file = (PFFile *) [userForComment objectForKey:@"avatar"];
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
    cell.textLabel.text = NSLocalizedString(@"Carica Altri Commenti", @"Carica Altri Commenti alla foto");
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
 
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    ;
}

@end
