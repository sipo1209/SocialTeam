//
//  FBDataGrabber.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 03/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBDataGrabber : NSObject <PF_FBRequestDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSMutableData *imageData;
    NSURLConnection *urlConnection;
}


-(void)FBDataGrab;

@end
