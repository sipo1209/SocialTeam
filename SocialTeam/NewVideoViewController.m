//
//  NewVideoViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 20/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewVideoViewController.h"
#import "UIImageView+WebCache.h"
#import "VideoCell.h"
#import "YouTubeVideoGrabber.h"
#import "Video.h"

@interface NewVideoViewController ()

@end

@implementation NewVideoViewController
@synthesize objects;
@synthesize titoli,sottotitoli;

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
    [self.refreshHeaderView setLastRefreshDate:nil];
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

#pragma mark - Refresh Methods
-(void)reloadTableViewDataSource{
    NSArray *datiVideo = [YouTubeVideoGrabber listaVideo:@"http://gdata.youtube.com/feeds/api/users/milanchannel/uploads?&v=2&max-results=10&alt=jsonc"];
    NSMutableArray *arrayURLthumb = [[NSMutableArray alloc] init];
    NSMutableArray *arrayTitoli = [[NSMutableArray alloc] init];
    NSMutableArray *arraySottotitoli = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < datiVideo.count; i = i +1) {
    
        [arrayURLthumb addObject:((Video *)[datiVideo objectAtIndex:i]).thumbURL];
        [arrayTitoli addObject:((Video *)[datiVideo objectAtIndex:i]).title];
        [arraySottotitoli addObject:((Video *)[datiVideo objectAtIndex:i]).description];
    }
    
   
    self.objects = arrayURLthumb;
    self.titoli = arrayTitoli;
    self.sottotitoli = arraySottotitoli;
    
    [super performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil afterDelay:2.0];
}


-(void)dataSourceDidFinishLoadingNewData{
    [refreshHeaderView setCurrentDate];
    [super dataSourceDidFinishLoadingNewData];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    
    
    cell.textLabel.text = [self.titoli objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.sottotitoli objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[objects objectAtIndex:indexPath.row]]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [self.titoli objectAtIndex:indexPath.row];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return labelSize.height + 20;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


@end
