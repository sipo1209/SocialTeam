//
//  YouTubeViewController.m
//  SocialTeam
//
//  Created by Luca Gianneschi on 20/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YouTubeViewController.h"
#import "PSYouTubeView.h"

@interface YouTubeViewController ()

@end

@implementation YouTubeViewController
@synthesize moviePlayerController = moviePlayerController_;
@synthesize videoURLString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [youTubeView.moviePlayerController stop];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSURL *youTubeURL = [NSURL URLWithString:self.videoURLString];
    CGFloat size = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? 250 : 500;
    CGRect videoRect = CGRectMake(0, 0, size, size);
    
    youTubeView = [[PSYouTubeView alloc] initWithYouTubeURL:youTubeURL frame:videoRect showNativeFirst:YES];
    youTubeView.center = self.view.center;
    youTubeView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [self.view addSubview:youTubeView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    youTubeView = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
