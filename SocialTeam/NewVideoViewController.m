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
#import "YouTubeViewController.h"

//definizione del canale di youtube dal quale fare il parsing dei dati per i video
#define YOUTUBE_CHANNEL @"http://gdata.youtube.com/feeds/api/users/milanchannel/uploads?&v=2&max-results=50&alt=jsonc"


//definizione del numero di celle da mostrare
#define kNumberOfItemsToAdd 10

@interface NewVideoViewController ()

@end

@implementation NewVideoViewController
@synthesize objects;
@synthesize titoli,sottotitoli;
@synthesize videoURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    numberOfItemsToDisplay = kNumberOfItemsToAdd; // Show 10 items at startup
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //metodo per il pullToRefresh
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
    NSArray *datiVideo = [YouTubeVideoGrabber listaVideo:YOUTUBE_CHANNEL];
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
    
    [super performSelector:@selector(dataSourceDidFinishLoadingNewData)
                withObject:nil
                afterDelay:2.0];
}




-(void)dataSourceDidFinishLoadingNewData{
    [refreshHeaderView setCurrentDate];
    [super dataSourceDidFinishLoadingNewData];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (numberOfItemsToDisplay == [objects count]) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return numberOfItemsToDisplay;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:cellIdentifier];
    }
    
       
    if (indexPath.section == 0) {
    
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13.f];
        cell.textLabel.text = [self.titoli objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        [cell.imageView setImageWithURL:[NSURL URLWithString:[objects objectAtIndex:indexPath.row]]
                       placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    } else {
        cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Carica Altri %d Video", @"Carica Altri Post Label"), kNumberOfItemsToAdd];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:0.196f green:0.3098f blue:0.52f alpha:1.f];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.f];
        [cell.imageView setImage:nil];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        NSString *cellText = [self.titoli objectAtIndex:indexPath.row];
        UIFont *cellFont = [UIFont boldSystemFontOfSize:13.f];
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:cellFont
                                constrainedToSize:constraintSize
                                    lineBreakMode:UILineBreakModeWordWrap];
        return labelSize.height + 30;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        NSUInteger i, totalNumberOfItems = [objects count];
        NSUInteger newNumberOfItemsToDisplay = MIN(totalNumberOfItems, numberOfItemsToDisplay + kNumberOfItemsToAdd);
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        for (i=numberOfItemsToDisplay; i<newNumberOfItemsToDisplay; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        numberOfItemsToDisplay = newNumberOfItemsToDisplay;
        
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        if (numberOfItemsToDisplay == totalNumberOfItems) {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
        }
        [tableView endUpdates];
        
        // Scroll the cell to the top of the table
        
        NSIndexPath *scrollPointIndexPath;
        
        if (newNumberOfItemsToDisplay < totalNumberOfItems) {
            scrollPointIndexPath = indexPath;
        } else {
            scrollPointIndexPath = [NSIndexPath indexPathForRow:totalNumberOfItems-1 inSection:0];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 200000000), dispatch_get_main_queue(), ^(void){
            [tableView scrollToRowAtIndexPath:scrollPointIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }else{
    
    YouTubeViewController *youTubeViewController = [[YouTubeViewController alloc] init];
    youTubeViewController.title = NSLocalizedString(@"Video Selezionato", @"Video Selezionato Titolo Controller");
    youTubeViewController.videoURLString = [self.videoURL objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:youTubeViewController
                                         animated:YES];
    }
    
}


@end
