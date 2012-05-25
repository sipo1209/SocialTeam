//
//  WallController.h
//  SocialTeam
//
//  Created by Luca Gianneschi on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PAWPost.h"

@interface WallController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>



@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@end

@protocol PAWWallViewControllerHighlight <NSObject>

- (void)highlightCellForPost:(PAWPost *)post;
- (void)unhighlightCellForPost:(PAWPost *)post;

@end
