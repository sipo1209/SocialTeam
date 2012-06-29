//
//  GCCommentsView.m
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCCommentsView.h"
#import "UIImageView+WebCache.h"

@implementation GCCommentsView
@synthesize asset, chute, comments, commentTable, commentArea, addCommentField;

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.addCommentField)
        [self postComment];
    else
        [textField resignFirstResponder];
    return YES;
}

-(void)reloadComments{
    if(!self.asset)
        return;
    if(!self.chute)
        return;
    [self setComments:NULL];
    [self.commentTable reloadData];
    [self showHUDWithTitle:@"Loading Comments" andOpacity:0.5];
    [self.asset setParentID:[self.chute objectID]];
    
    [self.asset commentsInBackgroundWithCompletion:^(GCResponse *response) {
        [self hideHUD];
        if ([response isSuccessful]) {
            [self setComments:[response object]];
            [commentTable reloadData];
        }
        else {
            [self quickAlertWithTitle:@"Error" message:[[response error] localizedDescription] button:@"Okay"];
        }
    }];
}

-(IBAction)postComment{
    if(!self.chute)
        return;
    if(!self.asset)
        return;
    if ([[self.addCommentField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] > 0) {
        [self showHUD];
        [self.asset setParentID:[self.chute objectID]];
        [self.asset addComment:self.addCommentField.text inBackgroundWithCompletion:^(GCResponse *response) {
            [self hideHUD];
            if ([response isSuccessful]) {
                [self reloadComments];
                [self.addCommentField setText:@""];
            } 
            else {
                [self quickAlertWithTitle:@"Error" message:[[response error] localizedDescription] button:@"Okay"];
            }
        }];
    }
    [self.addCommentField resignFirstResponder];
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

-(void)keyboardDidShow:(NSNotification*)notification{
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    CGRect keyboardFrameConverted = [self.view convertRect:keyboardFrame fromView:window];
    float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^(void) {
        [self.commentArea setTransform:CGAffineTransformMakeTranslation(0, -(self.commentArea.frame.origin.y+self.commentArea.frame.size.height-keyboardFrameConverted.origin.y))];
    }];
}

-(void)keyboardDidHide:(NSNotification*)notification{
    float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^(void) {
        [self.commentArea setTransform:CGAffineTransformIdentity];
    }];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.addCommentField setDelegate:self];
    [self.commentTable setDelegate:self];
    [self.commentTable setDataSource:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [self reloadComments];
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

-(UIView*)viewForCommentAtIndexPath:(NSIndexPath*)indexPath{
    GCComment *comment = [self.comments objectAtIndex:indexPath.row];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(2, 2, commentTable.frame.size.width-4, [self tableView:commentTable heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]-4)];
    [v setClipsToBounds:YES];
    [v setBackgroundColor:[UIColor whiteColor]];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, v.frame.size.height-4, v.frame.size.height-4)];
    GCUser *u = [comment user];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.size.width+7, 0, v.frame.size.width-iv.frame.size.width-11, v.frame.size.height)];
    [label setText:[NSString stringWithFormat:@"%@",[comment objectForKey:@"comment"]]];
    [label setNumberOfLines:3];
    [label setFont:[UIFont systemFontOfSize:15]];
    [v addSubview:label];
    [label release];
    NSString *avatarURLString = [u avatarURL];
    [iv setImageWithURL:[NSURL URLWithString:avatarURLString]];
    [v addSubview:iv];
    [iv release];
    return [v autorelease];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(![self comments])
        return 0;
    return [[self comments] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
        cell = [[[UITableViewCell alloc] init] autorelease];
    }
    else{
        for(UIView *content in [cell.contentView subviews])
            [content removeFromSuperview];
    }
    [cell.contentView addSubview:[self viewForCommentAtIndexPath:indexPath]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 65;
}

-(void)dealloc{
    [asset release];
    [chute release];
    [comments release];
    [super dealloc];
}


@end
