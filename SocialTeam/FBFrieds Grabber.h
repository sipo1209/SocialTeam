//
//  FBFrieds Grabber.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 08/08/12.
//
//

#import <Foundation/Foundation.h>

@interface FBFrieds_Grabber : NSObject <PF_FBRequestDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
        NSMutableData *_data;
        BOOL firstLaunch;
}
@property (nonatomic, strong) NSTimer *autoFollowTimer;

-(void)friendsGrab;


@end
