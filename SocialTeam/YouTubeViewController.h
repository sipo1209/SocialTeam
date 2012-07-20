//
//  YouTubeViewController.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 20/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class PSYouTubeView;


@interface YouTubeViewController : UIViewController{
    PSYouTubeView *youTubeView;
}

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;

@property (nonatomic, strong) NSString *videoURLString;


@end
