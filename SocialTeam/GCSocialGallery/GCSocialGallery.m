//
//  GCSocialGallery.m
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GCSocialGallery.h"

@implementation GCSocialGallery
@synthesize heartedButton, chute, shareView, commentView, closeCommentsButton;

-(IBAction)heartButtonClicked:(UIButton*)sender{
    if(!self.objects || self.objects.count == 0 || currentPage > self.objects.count)
        return;
    GCAsset *asset = [self.objects objectAtIndex:currentPage-1];
    if([sender isSelected]){
        [asset unheartInBackgroundWithCompletion:^(BOOL success, NSError *error){[[GCAccount sharedManager] loadHeartedAssets];}];
    }
    else{
        [asset heartInBackgroundWithCompletion:^(BOOL success, NSError *error){[[GCAccount sharedManager] loadHeartedAssets];}];
    }
    [sender setSelected:![sender isSelected]];
}
-(IBAction)commentsButtonClicked:(UIButton*)sender{
    [self showCommentView];
}
-(IBAction)shareButtonClicked:(UIButton*)sender{
    [self showShareView];
}
-(IBAction)closeCommentsButtonClicked:(UIButton*)sender{
    [self hideCommentsView];
}

-(void)hideCommentsView{
    [self.commentView.view removeFromSuperview];
    [self setCommentView:NULL];
    [self.closeCommentsButton setHidden:YES];
}

-(void)showCommentView{
    if(!self.objects || self.objects.count == 0 || currentPage > self.objects.count)
        return;
    GCCommentsView *temp = [[GCCommentsView alloc] init];
    [temp setChute:self.chute];
    [temp setAsset:[self.objects objectAtIndex:currentPage-1]];
    [self setCommentView:temp];
    [temp release];
    [self.view addSubview:self.commentView.view];
    [self.commentView.view setFrame:CGRectMake(0, 40, 320, self.view.frame.size.height-40)];
    [self.closeCommentsButton setHidden:NO];
}
-(void)showShareView{
    if(!self.objects || self.objects.count == 0 || currentPage > self.objects.count)
        return;
    GCShareView *temp = [[GCShareView alloc] init];
    [temp setSharedItem:[self.objects objectAtIndex:currentPage-1]];
    [self setShareView:temp];
    [temp release];
    [self.shareView showView];
}
-(void)loadObjectsForCurrentPosition{
    [super loadObjectsForCurrentPosition];
    if(self.objects && self.objects.count > 0 && currentPage <= self.objects.count){
        GCAsset *asset = [self.objects objectAtIndex:currentPage-1];
        if([asset isHearted])
            [heartedButton setSelected:YES];
        else
            [heartedButton setSelected:NO];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [[GCAccount sharedManager] loadHeartedAssets];
    [super viewDidLoad];
    [self.closeCommentsButton setHidden:YES];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
