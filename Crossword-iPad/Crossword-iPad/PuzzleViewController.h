//
//  PuzzleViewController.h
//  puzzleipad
//
//  Created by Samuel Liard on 18/11/11.
//  Copyright (c) 2011 Liard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class ViewController;

@interface PuzzleViewController : UIViewController {
        
    IBOutlet UIImageView *gameImageView;

    IBOutlet UIImageView *animImageView;
    
    NSString *selectedLetter;
    
    NSDictionary *puzzleFile;
    NSMutableDictionary *allLetter;
    NSMutableDictionary *allLetterImages;
    NSMutableDictionary *placeLetter;

    int mode;
    
    NSString *puzzleFileName;
    
    IBOutlet ViewController *mainController;
}

@property (retain, nonatomic) NSDictionary *puzzleFile;
@property (retain, nonatomic) NSMutableDictionary *allLetter;
@property (retain, nonatomic) NSString *selectedLetter;
@property (retain, nonatomic) NSMutableDictionary *allLetterImages;
@property (retain, nonatomic) NSMutableDictionary *placeLetter;

@property (retain, nonatomic) UIImageView *gameImageView;
@property (retain, nonatomic) UIImageView *animImageView;
@property (retain, nonatomic) NSString *puzzleFileName;
@property (retain, nonatomic) ViewController *mainController;

- (IBAction)pressReset;

- (IBAction)pressModeA;
- (IBAction)pressModeB;
- (IBAction)pressModeC;

- (IBAction)pressReturn;

- (bool)isFinish;
-(bool) isWordFinish:(CGPoint)point;

- (void)initData:(NSString *) fileName;

@end
