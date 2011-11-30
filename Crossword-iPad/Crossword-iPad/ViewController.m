//
//  ViewController.m
//  puzzleipad
//
//  Created by Samuel Liard on 17/11/11.
//  Copyright (c) 2011 Liard. All rights reserved.
//

#import "ViewController.h"
#import "PuzzleViewController.h"
#import "CreditViewController.h"
#import "AllLetterViewController.h"
#import "AudioManager.h"
#import "FlurryAnalytics.h"

#define PUZZLE_DATA @"puzzleData.dat"

@implementation ViewController

@synthesize puzzleController, creditController, letterController;
@synthesize firstPage;
@synthesize fullVersion1,fullVersion2;

NSMutableDictionary *allTag;

- (IBAction)pressGrille:(id)sender {
    
    UIButton *bPress =  (UIButton *)sender;

    NSString *puzzleName = bPress.titleLabel.text;
    
    [self.navigationController pushViewController:puzzleController animated:YES];
    
    if((puzzleController.puzzleFileName == nil) ||
       (![puzzleController.puzzleFileName isEqualToString:puzzleName])) {
        [puzzleController initData:puzzleName];
    }
    
    [[AudioManager getSingleton] playSound:@"bouton"];

}

- (IBAction)pressCredit {

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.50];
    
    [FlurryAnalytics logEvent:@"PRESS_CREDIT"];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:YES];
        
    [self.navigationController pushViewController:creditController animated:NO];
    
    //Start Animation
    [UIView commitAnimations];

}

- (IBAction)pressLetter {
    
//    [self.navigationController pushViewController:creditController animated:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.50];
    
    [FlurryAnalytics logEvent:@"PRESS_LETTER"];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:YES];
        
    [self.navigationController pushViewController:letterController animated:NO];
    
    //Start Animation
    [UIView commitAnimations];
    
}

- (IBAction)getFullVersion {

    /*
    UIAlertView *someError = [[UIAlertView alloc] initWithTitle:@"Version Complete" message:@"La prendre !" delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    
    [someError show];
    [someError release];
    */
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/kidschool-my-first-criss-cross/id484590469?l=fr&ls=1&mt=8"]];

//    http://itunes.apple.com/us/app/cute-kittens/id352275799?mt=8&uo=4
    
//    http://itunes.apple.com/us/app/kidschool-my-first-criss-cross/id484590469?l=fr&ls=1&mt=8
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:PUZZLE_DATA];
    
    //    dataDico
    if ( ![fileManager fileExistsAtPath:filePath] ) {
        dataDico = [[NSMutableDictionary alloc] init];
        [dataDico writeToFile:filePath atomically:YES];
	} else {
        dataDico = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }

	[[AudioManager getSingleton] playBackgroundSound];
    
    allTag = [[NSMutableDictionary alloc] init];
    [allTag setObject:[NSNumber numberWithInt:1] forKey:@"grille-1-1"];
    [allTag setObject:[NSNumber numberWithInt:2] forKey:@"grille-1-2"];
    [allTag setObject:[NSNumber numberWithInt:3] forKey:@"grille-1-3"];
    [allTag setObject:[NSNumber numberWithInt:4] forKey:@"grille-1-4"];
    [allTag setObject:[NSNumber numberWithInt:5] forKey:@"grille-1-5"];
    [allTag setObject:[NSNumber numberWithInt:6] forKey:@"grille-2-1"];
    [allTag setObject:[NSNumber numberWithInt:7] forKey:@"grille-2-2"];
    [allTag setObject:[NSNumber numberWithInt:8] forKey:@"grille-2-3"];
    [allTag setObject:[NSNumber numberWithInt:9] forKey:@"grille-2-4"];
    [allTag setObject:[NSNumber numberWithInt:10] forKey:@"grille-2-5"];
    [allTag setObject:[NSNumber numberWithInt:11] forKey:@"grille-3-1"];
    [allTag setObject:[NSNumber numberWithInt:12] forKey:@"grille-3-2"];
    [allTag setObject:[NSNumber numberWithInt:13] forKey:@"grille-3-3"];
    [allTag setObject:[NSNumber numberWithInt:14] forKey:@"grille-3-4"];
    [allTag setObject:[NSNumber numberWithInt:15] forKey:@"grille-3-5"];
    
    [self updateMainScreen];
    
#if defined(LITE)
    firstPage.image = [UIImage imageNamed:@"firstPage-free.png"];
    [fullVersion1 setUserInteractionEnabled:TRUE];
    [fullVersion2 setUserInteractionEnabled:TRUE];
#else
    firstPage.image = [UIImage imageNamed:@"firstPage.png"];
    [fullVersion1 setUserInteractionEnabled:FALSE];
    [fullVersion2 setUserInteractionEnabled:FALSE];
#endif    
    
}

-(void) saveData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:PUZZLE_DATA];
    
    [dataDico writeToFile:filePath atomically:YES];
}

-(void) finishPuzzle:(NSString *) puzzleName level:(int) mode {
    
    NSMutableDictionary *puzzleDic = [dataDico objectForKey:puzzleName];
    
    if(puzzleDic == nil) {
        puzzleDic = [[[NSMutableDictionary alloc] init] autorelease];
        [dataDico setObject:puzzleDic forKey:puzzleName];
    }
    
    NSNumber *oldMode = [puzzleDic objectForKey:@"mode"];
    
    if((oldMode == nil) || ([oldMode intValue] < mode)) {
        [puzzleDic setObject:[NSNumber numberWithInt:mode] forKey:@"mode"];
    }
    
    [self saveData];
    
    [self updateMainScreen];
}

-(void) updateMainScreen {
    
    for(NSString *key in [dataDico keyEnumerator]) {
        NSMutableDictionary *puzzleDic = [dataDico objectForKey:key];
        if(puzzleDic != nil) {
            NSNumber *oldMode = [puzzleDic objectForKey:@"mode"];        
            if(oldMode != nil) {
                
                NSNumber *tagId = [allTag objectForKey:key];
                
                UIImage *letterImage = [UIImage imageNamed:[NSString stringWithFormat:@"%i-star.png",[oldMode intValue]]];
                
                UIImageView *starImage = (UIImageView*)[self.view viewWithTag:[tagId integerValue]];
                
                [starImage setImage:letterImage];
                [starImage setHidden:FALSE];
            }
        }
    }
        
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeRight) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft));
}

@end
