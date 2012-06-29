//
//  GCShareView.m
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCShareView.h"


@implementation GCShareView
@synthesize sharedItem;


-(NSString*)linkEmailMessage{
    return [self.sharedItem absoluteString];
}
-(NSString*)linkEmailSubject{
    return @"Check out this link";
}
-(NSString*)linkFacebookMessage{
    return @"Check out this link";
}
-(NSString*)linkTwitterMessage{
    return @"Check out this link";
}
-(NSString*)assetEmailMessage{
    return [NSString stringWithFormat:@"%@/%@/%@", SERVER_URL, [[self.sharedItem class] elementName], [self.sharedItem objectID]];
}
-(NSString*)assetEmailSubject{
    return @"Check out this image I posted on chute";
}
-(NSString*)assetFacebookMessage{
    return @"Check out this image I posted on chute";
}
-(NSString*)assetTwitterMessage{
    return @"Check out this image I posted on chute";
}
-(NSString*)chuteEmailMessage{
    return [NSString stringWithFormat:@"%@/%@/%@", SERVER_URL, [[self.sharedItem class] elementName], [self.sharedItem shortcut]];
}
-(NSString*)chuteEmailSubject{
    return @"Check out these images I posted on chute";
}
-(NSString*)chuteFacebookMessage{
    return @"Check out these images I posted on chute";
}
-(NSString*)chuteTwitterMessage{
    return @"Check out these images I posted on chute";
}
-(NSString*)parcelEmailMessage{
    return [NSString stringWithFormat:@"%@/%@/%@", SERVER_URL, [[self.sharedItem class] elementName], [self.sharedItem shortcut]];
}
-(NSString*)parcelEmailSubject{
    return @"Check out these images I posted on chute";
}
-(NSString*)parcelFacebookMessage{
    return @"Check out these images I posted on chute";
}
-(NSString*)parcelTwitterMessage{
    return @"Check out these images I posted on chute";
}

-(void)shareURL:(NSString*)stringURL viaFacebookWithMessage:(NSString*)message {
    if(!stringURL)
        return;
    if(!message)
        message = @"";
    NSString *facebookURL = [NSString stringWithFormat:@"http://www.facebook.com/sharer/sharer.php?u=%@&t=%@",[stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [shareWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:facebookURL]]];
    [self showWebView];
}

-(void)shareURL:(NSString*)stringURL viaTwitterWithMessage:(NSString*)message {
    if(!stringURL)
        return;
    if(!message)
        message = @"";
    NSString *twitterURL = [NSString stringWithFormat:@"http://twitter.com/share?url=%@&text=%@",[stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [shareWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:twitterURL]]];
    [self showWebView];
}

-(void)shareMessage:(NSString*)message viaEmailWithSubject:(NSString*)subject{
    if (![MFMailComposeViewController canSendMail])
        return;
    if(!message)
        message = @"";
    if(!subject)
        subject = @"";
    NSString *body = message;
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller.navigationBar setBarStyle:UIBarStyleBlack];
    [controller setSubject:subject];
    [controller setMessageBody:body isHTML:YES];
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

-(void)closeClicked:(id)sender{
    [self hideChoices];
}

-(IBAction)emailClicked:(id)sender{
    NSString *message = NULL;
    NSString *subject = NULL;
    if([self.sharedItem isKindOfClass:[NSURL class]]){
        message = [self linkEmailMessage];
        subject = [self linkEmailSubject];
    }
    else if([self.sharedItem isKindOfClass:[GCChute class]]){
        message = [self chuteEmailMessage];
        subject = [self chuteEmailSubject];
    }
    else if([self.sharedItem isKindOfClass:[GCParcel class]]){
        message = [self parcelEmailMessage];
        subject = [self parcelEmailSubject];
    }
    else if([self.sharedItem isKindOfClass:[GCAsset class]]){
        message = [self assetEmailMessage];
        subject = [self assetEmailSubject];
    }
    else
        return;
    [self shareMessage:message viaEmailWithSubject:subject];
}

-(IBAction)facebookClicked:(id)sender{
    NSString *message = NULL;
    NSString *url = NULL;
    if([self.sharedItem isKindOfClass:[NSURL class]]){
        message = [self linkFacebookMessage];
        url = [self.sharedItem absoluteString];
    }
    else if([self.sharedItem isKindOfClass:[GCChute class]]){
        message = [self chuteFacebookMessage];
        url = [NSString stringWithFormat:@"%@/%@/%@", SERVER_URL, [[self.sharedItem class] elementName], [self.sharedItem shortcut]];
    }
    else if([self.sharedItem isKindOfClass:[GCParcel class]]){
        message = [self parcelFacebookMessage];
        url = [NSString stringWithFormat:@"%@/%@/%@", SERVER_URL, [[self.sharedItem class] elementName], [self.sharedItem shortcut]];
    }
    else if([self.sharedItem isKindOfClass:[GCAsset class]]){
        message = [self assetFacebookMessage];
        url = [NSString stringWithFormat:@"%@/%@/%@", SERVER_URL, [[self.sharedItem class] elementName], [self.sharedItem objectID]];
    }
    else
        return;
    [self shareURL:url viaFacebookWithMessage:message];
}

-(IBAction)twitterClicked:(id)sender{
    NSString *message = NULL;
    NSString *url = NULL;
    if([self.sharedItem isKindOfClass:[NSURL class]]){
        message = [self linkTwitterMessage];
        url = [self.sharedItem absoluteString];
    }
    else if([self.sharedItem isKindOfClass:[GCChute class]]){
        message = [self chuteTwitterMessage];
        url = [NSString stringWithFormat:@"%@/%@/%@", SERVER_URL, [[self.sharedItem class] elementName], [self.sharedItem shortcut]];
    }
    else if([self.sharedItem isKindOfClass:[GCParcel class]]){
        message = [self parcelTwitterMessage];
        url = [NSString stringWithFormat:@"%@/%@/%@", SERVER_URL, [[self.sharedItem class] elementName], [self.sharedItem shortcut]];
    }
    else if([self.sharedItem isKindOfClass:[GCAsset class]]){
        message = [self assetTwitterMessage];
        url = [NSString stringWithFormat:@"%@/%@/%@", SERVER_URL, [[self.sharedItem class] elementName], [self.sharedItem objectID]];
    }
    else
        return;
    [self shareURL:url viaTwitterWithMessage:message];
}

-(IBAction)WebViewBackClicked:(id)sender{
    [self hideWebView];
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

-(void)showView{
    UIView *modalView = self.view;
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [mainWindow addSubview:modalView];
}
-(void)closeView{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.view removeFromSuperview];
}

-(void)showChoices{
    [choiceView setTransform:CGAffineTransformTranslate(choiceView.transform, 0, self.view.frame.size.height)];
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         [choiceView setTransform:CGAffineTransformIdentity];
                     }
                     completion:^(BOOL finished){
                     }
     ];
}

-(void)hideChoices{
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         [choiceView setTransform:CGAffineTransformTranslate(choiceView.transform, 0, self.view.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         [self closeView];
                     }
     ];
}

-(void)showWebView{
    [self.view addSubview:shareView];
}

-(void)hideWebView{
    [shareWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
    [shareView removeFromSuperview];
    [self closeView];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([self.sharedItem isKindOfClass:[NSURL class]]){
        [shareLabel setText:@"Share This Link"];
    }
    else if([self.sharedItem isKindOfClass:[GCChute class]]){
        [shareLabel setText:@"Share These Photos"];
    }
    else if([self.sharedItem isKindOfClass:[GCParcel class]]){
        [shareLabel setText:@"Share These Photos"];
    }
    else if([self.sharedItem isKindOfClass:[GCAsset class]]){
        [shareLabel setText:@"Share This Photo"];
    }
    
    [self showChoices];
    
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

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)dealloc{
    [sharedItem release];
    [super dealloc];
}

@end