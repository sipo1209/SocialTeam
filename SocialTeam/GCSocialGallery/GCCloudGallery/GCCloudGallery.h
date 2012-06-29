//
//  GCCloudGallery.h
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 10/1/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetChute.h"

@interface GCCloudGallery : GCUIBaseViewController <UIScrollViewDelegate> {
    NSMutableArray *sliderObjects;
    NSArray *objects;
    IBOutlet UIScrollView *objectSlider;
    NSInteger currentPage;
}

//currentPage is not zero indexed, starts at 1, use currentPage-1 when accessing array position.
@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, retain) IBOutlet UIScrollView *objectSlider;

//use for objects used for the page views
@property (nonatomic, retain) NSArray *objects;

//use to store any objects you need to retain for any views to interact with, such as view controllers.
@property (nonatomic, retain) NSMutableArray *sliderObjects;

//can override to add custom behavior when finished switching pages.  Reccomended to call [super loadObjectsForCurrentPosition] in your implementation though to insure views are loaded properly in slider.
- (void)loadObjectsForCurrentPosition;

//can be overridden in child class for a custom look of each GCAsset.  Page is zero indexed.  Any UIView or subclass should work, please retain any objects that you need to use with the view.
- (UIView*)viewForPage:(NSInteger)page;

//resizes the content size of the scroll viw based on the number of objects
- (void)resizeScrollView;

//scrolls to the next or previous page if there is one.
- (void)nextObject;
- (void)previousObject;

- (void)switchToObjectAtIndex:(NSUInteger)index animated:(BOOL)_animated;
//same as switchToObjectAtIndex: animated: with NO passed in to animated field
- (void)switchToObjectAtIndex:(NSNumber*)index;

//returns the size and position of a view for a given page.  Page is zero indexed.
- (CGRect)rectForPage:(NSInteger)page;

@end