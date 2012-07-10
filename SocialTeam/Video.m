//
//  Video.m
//  Campioni del Milan
//
//  Created by Luca Gianneschi on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Video.h"



@implementation Video
@synthesize titolo,tags,description,thumbURL,urlVideo;


+(id)videoWithTitle:(NSString *)title description:(NSString *)description tags:(NSArray *)tags thumbURL:(NSString *)thumbURL urlVideo:(NSString *)urlVideo{
    
    Video *newVideo = [[Video alloc] init];
    newVideo.titolo = title;
    newVideo.description = description;
    newVideo.tags = tags;
    newVideo.thumbURL = thumbURL;
    newVideo.urlVideo = urlVideo;
    
    return newVideo;
}


@end
