//
//  CreditViewController.m
//  puzzleipad
//
//  Created by Samuel Liard on 20/11/11.
//  Copyright (c) 2011 Liard. All rights reserved.
//

#import "CreditViewController.h"
#import "FlurryAnalytics.h"

@implementation CreditViewController

@synthesize backgroundPage, scrollView;

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

- (IBAction)pressReturn {
    
//	[self.navigationController popViewControllerAnimated:YES];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.50];
    
    
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:YES];
    
	[self.navigationController popViewControllerAnimated:NO];
    
    //Start Animation
    [UIView commitAnimations];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [FlurryAnalytics logPageView];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Credit";
    
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
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeRight) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft));
}

@end
