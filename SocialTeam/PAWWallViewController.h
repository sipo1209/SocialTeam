//
//  PAWWallViewController.h
//  AnyWall
//
//  Created by Christopher Bowns on 1/30/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "PAWPost.h"

@interface PAWWallViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    UISegmentedControl *segmentedControl;
}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@end

@protocol PAWWallViewControllerHighlight <NSObject>

- (void)highlightCellForPost:(PAWPost *)post;
- (void)unhighlightCellForPost:(PAWPost *)post;

@end
