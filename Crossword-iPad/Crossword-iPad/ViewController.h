//
//  ViewController.h
//  puzzleipad
//
//  Created by Samuel Liard on 17/11/11.
//  Copyright (c) 2011 Liard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PuzzleViewController;
@class CreditViewController;
@class AllLetterViewController;

@interface ViewController : UIViewController {
    
    IBOutlet PuzzleViewController *puzzleController;
    IBOutlet CreditViewController *creditController;
    IBOutlet AllLetterViewController *letterController;
    
    IBOutlet UIImageView *firstPage;
    IBOutlet UIButton *fullVersion1;
    IBOutlet UIButton *fullVersion2;
    
    NSMutableDictionary *dataDico;
    
}

@property (retain, nonatomic) PuzzleViewController *puzzleController;
@property (retain, nonatomic) CreditViewController *creditController;
@property (retain, nonatomic) AllLetterViewController *letterController;

@property (retain, nonatomic) UIImageView *firstPage;
@property (retain, nonatomic) UIButton *fullVersion1;
@property (retain, nonatomic) UIButton *fullVersion2;

- (IBAction)pressGrille:(id)sender;

- (IBAction)pressCredit;
- (IBAction)pressLetter;

- (IBAction)getFullVersion;

-(void) finishPuzzle:(NSString *) puzzleName level:(int) mode;
-(void) updateMainScreen;
-(void) saveData;

@end
