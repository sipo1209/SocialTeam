//
//  Video.m
//  Campioni del Milan
//
//  Created by Luca Gianneschi on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Video.h"



@implementation Video
@synthesize title,tags,description,thumbURL,urlVideo,duration,uploaded;


+(id)videoWithTitle:(NSString *)title description:(NSString *)description tags:(NSArray *)tags thumbURL:(NSString *)thumbURL urlVideo:(NSString *)urlVideo duration:(NSNumber *)duration uploaded:(NSString *)uploaded {
    
    Video *newVideo = [[Video alloc] init];
    newVideo.title = title;
    newVideo.description = description;
    newVideo.tags = tags;
    newVideo.thumbURL = thumbURL;
    newVideo.urlVideo = urlVideo;
    newVideo.duration = duration;
    newVideo.uploaded = uploaded;

    return newVideo;
}


@end
