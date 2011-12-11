//
//  PuzzleViewController.m
//  puzzleipad
//
//  Created by Samuel Liard on 18/11/11.
//  Copyright (c) 2011 Liard. All rights reserved.
//

#import "PuzzleViewController.h"
#import "ViewController.h"
#import "AudioManager.h"
#import "FlurryAnalytics.h"

#define MODE_EASY 1
#define MODE_MEDIUM 2
#define MODE_HARD 3

@implementation PuzzleViewController

@synthesize puzzleFile, allLetter, selectedLetter, allLetterImages, placeLetter, gameImageView;
@synthesize puzzleFileName, mainController;
@synthesize animImageView;

-(NSString *) getStringPosition:(CGPoint)point {
    
    NSNumber *baseX = [self.puzzleFile objectForKey:@"baseX"];
    NSNumber *baseY = [self.puzzleFile objectForKey:@"baseY"];
    NSNumber *width = [self.puzzleFile objectForKey:@"width"];
    NSNumber *height = [self.puzzleFile objectForKey:@"height"];
    
    return [NSString stringWithFormat:@"%i-%i",(int)((point.x-[baseX intValue])/[width intValue]),(int)((point.y-[baseY intValue])/[height intValue])];
    
}

-(NSString *) getLetterPosition:(CGPoint)point {
    
    int baseX = 24;
    int baseY = 639;
    int width = 70;
    int height = 60;
    
    return [NSString stringWithFormat:@"%i-%i",(int)((point.x-baseX)/width),(int)((point.y-baseY)/height)];
}

- (IBAction)pressModeA {
    
    gameImageView.image = [UIImage imageNamed:[self.puzzleFile objectForKey:@"image3"]];
        
    mode = MODE_HARD;
}

- (IBAction)pressModeB {
    
    gameImageView.image = [UIImage imageNamed:[self.puzzleFile objectForKey:@"image2"]];
    
    mode = MODE_MEDIUM;

}

- (IBAction)pressModeC {
    
    gameImageView.image = [UIImage imageNamed:[self.puzzleFile objectForKey:@"image1"]];
    
    mode = MODE_EASY;
}


- (IBAction)pressReturn {
    
	[self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)pressReset {
    
    for (UIImageView *anImage in [placeLetter allValues]) {    
        [anImage removeFromSuperview];
    }
    
    [self.placeLetter removeAllObjects];
    
    NSNumber *level = [self.puzzleFile objectForKey:@"level"];
    
    gameImageView.image = [UIImage imageNamed:[self.puzzleFile objectForKey:[NSString stringWithFormat:@"image%i",[level intValue]]]];

    mode = [level intValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(bool) isWellPlaced:(CGPoint)point letter:(NSString *)selectLetter {
    
    NSArray *allWord = [self.puzzleFile objectForKey:@"words"];
    
    NSString *val = nil;
    NSString *pos = [self getStringPosition:point];
    
    for(int i=0; (val == nil) && (i<[allWord count]); i++) {
        val = [[[allWord objectAtIndex:i] objectForKey:@"letters"] objectForKey:pos];
    }
    
    return ((val != nil) ? ([selectLetter isEqualToString:val]) : FALSE);
}

-(bool) isFinish {
    
    int nbPlace = [placeLetter count];
    int nbTotal = [[self.puzzleFile objectForKey:@"nbLetters"] intValue];
    
    return nbPlace == nbTotal;
}

-(bool) isWordFinish:(CGPoint)point {
        
    NSArray *allWord = [self.puzzleFile objectForKey:@"words"];
    NSString *pos = [self getStringPosition:point];
    
    NSMutableDictionary *finishLetter = [[NSMutableDictionary alloc] init];
    
    bool result = false;

    for(NSDictionary *aWord in allWord) {
        NSDictionary *allLetters = [aWord objectForKey:@"letters"];

        bool allGoodLetter = true;
        bool containtLastLetter = false;
        NSArray *allKeys = [allLetters allKeys];
        
        for(int j=0; (allGoodLetter) && (j<[allKeys count]); j++) {
            allGoodLetter &= ([placeLetter objectForKey:[allKeys objectAtIndex:j]] != nil);
            containtLastLetter |= [pos isEqualToString:[allKeys objectAtIndex:j]];
        }
        
        if(allGoodLetter && containtLastLetter) {
            
            result = true;
            
            for(int j=0; (allGoodLetter) && (j<[allKeys count]); j++) {
                [finishLetter setObject:[placeLetter objectForKey:[allKeys objectAtIndex:j]] forKey:[allKeys objectAtIndex:j]];
            }
            
/* OLA
            NSString *wordString = [aWord objectForKey:@"word"];
            
            float decal = 0;
            float duration = 0.5;
            
            for(int k=0; k<[wordString length]; k++) {
                NSRange range;
                range.length=1;
                range.location=k;
                NSArray *keys = [allLetters allKeysForObject:[wordString substringWithRange:range]];
                if((keys != nil) && ([keys count] > 0)) {
                    UIView *aLetter = [placeLetter objectForKey:[keys objectAtIndex:0]];
                    
                    CGRect firstRec;
                    CGRect bigRec;
                    
                    firstRec = aLetter.frame;
                    bigRec = aLetter.frame;
                    
                    bigRec.size.height = bigRec.size.height*2.8;
                    bigRec.size.width = bigRec.size.width*2.8;
                                        
                    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"bounds"];
                        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                        anim.duration = duration;
                        anim.beginTime = CACurrentMediaTime() + decal;
                        anim.toValue = [NSValue valueWithCGRect:bigRec];
                        anim.fillMode = kCAFillModeBoth;
                        anim.removedOnCompletion = NO;
                        [aLetter.layer addAnimation:anim forKey:nil];        
                    } completion:^(BOOL finished){
                        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                            
                            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"bounds"];
                            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                            anim.duration = duration;
                            anim.beginTime = CACurrentMediaTime() + decal;
                            anim.toValue = [NSValue valueWithCGRect:firstRec];
                            anim.fillMode = kCAFillModeBoth;
                            anim.removedOnCompletion = NO;
                            [aLetter.layer addAnimation:anim forKey:nil];        
                            
                        }  completion:^(BOOL finished) {
                            
                        }];           
                    }];

                }
                decal += 0.1;

            }            
*/
        }
        
    }
    
    if([finishLetter count] > 0) {
        
        for(UIView *aLetter in [finishLetter allValues]) {
            
            [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                aLetter.layer.transform = CATransform3DMakeRotation(M_PI,0.0,0.0,-1.0);
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                    aLetter.layer.transform = CATransform3DConcat(aLetter.layer.transform, CATransform3DMakeRotation(M_PI,0.0,0.0,-1.0));
                    
                }  completion:^(BOOL finished) {
                }];           
            }];
        }
        
    }
    
    [finishLetter release];


    return result;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView:touch.view];
    
    selectedLetter = [allLetter objectForKey:[self getLetterPosition:location]];  
    
    if(selectedLetter != nil) {
    
        UIImageView *selectLetter = ((UIImageView *)[allLetterImages objectForKey:selectedLetter]);
                
        [self.view bringSubviewToFront:selectLetter];
                
        CGPoint newLocation;
        newLocation.x = -80;
        newLocation.y = -80;
        selectLetter.center = newLocation;
        
        [selectLetter.layer removeAllAnimations];

        NSNumber *level = [self.puzzleFile objectForKey:@"level"];

        if(([level intValue] == 1) || (mode == MODE_EASY)) {
            [[AudioManager getSingleton] playSound:selectedLetter];
        }

    }

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(selectedLetter != nil) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:touch.view];    
        
        UIImageView *selectLetter = ((UIImageView *)[allLetterImages objectForKey:selectedLetter]);        
        selectLetter.center = location;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView:touch.view];
    if (([self isWellPlaced:location letter:selectedLetter]) &&
        ([placeLetter objectForKey:[self getStringPosition:location]]) == nil) {
        
        UIImage *noPicImageSmall = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",selectedLetter]];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:noPicImageSmall];
        
        imgView.center = location;
        // customize the UIImageView as you like
        [self.view addSubview:imgView];
        
        [placeLetter setObject:imgView forKey:[self getStringPosition:location]];
        
        NSNumber *baseX = [self.puzzleFile objectForKey:@"baseX"];
        NSNumber *baseY = [self.puzzleFile objectForKey:@"baseY"];
        NSNumber *width = [self.puzzleFile objectForKey:@"width"];
        NSNumber *height = [self.puzzleFile objectForKey:@"height"];

        int xPos = (int)((location.x-[baseX intValue])/[width intValue]);
        int yPos = (int)((location.y-[baseY intValue])/[height intValue]);

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];

        CGRect imageFrame = imgView.frame;
        imageFrame.size.width = [width intValue];
        imageFrame.size.height = [height intValue];
        imageFrame.origin.x = (xPos*[width intValue])+[baseX intValue];
        imageFrame.origin.y = (yPos*[height intValue])+[baseY intValue];
        imgView.frame = imageFrame;
        
        [UIView commitAnimations];
        
        [imgView release];

        bool finishWord = [self isWordFinish:location];

        if([self isFinish ]) {
            [mainController finishPuzzle:puzzleFileName level:mode];
            [[AudioManager getSingleton] playSound:@"endGrid"];
            
            [self.view bringSubviewToFront:animImageView];
            [animImageView startAnimating];

            [FlurryAnalytics logEvent:@"END_GRID"];

        } else {
            [[AudioManager getSingleton] playSound:@"wellPlaced"];
            
            if(finishWord) {
//                [[AudioManager getSingleton] playSound:@"endWord"];
            }
        }
        
        
        CGPoint newLocation;
        newLocation.x = -80;
        newLocation.y = -80;
        ((UIImageView *)[allLetterImages objectForKey:selectedLetter]).center = newLocation;

    } else if (selectedLetter != nil) {

        UIImageView *letter = ((UIImageView *)[allLetterImages objectForKey:selectedLetter]);

        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"bounds"];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        anim.duration = 0.5;
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)];
        anim.fillMode = kCAFillModeBoth;
        anim.removedOnCompletion = NO;
        [letter.layer addAnimation:anim forKey:nil];        

        if(location.y < 630) {
            // Si on relache sur les lettres
            // Pour écouter la lettre
            [[AudioManager getSingleton] playSound:@"falseletter"];
        }

    }
    
    selectedLetter = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)initData:(NSString *) fileName {
    
    NSString *dataFile = [[NSBundle mainBundle]  pathForResource:fileName ofType:@"plist"];    
    self.puzzleFile = [NSDictionary dictionaryWithContentsOfFile:dataFile];    

    self.puzzleFileName = fileName;
    
    if(placeLetter != nil) {
        for (UIImageView *anImage in [placeLetter allValues]) {    
            [anImage removeFromSuperview];
        }
        
        [self.placeLetter removeAllObjects];
    }
    
    NSNumber *level = [self.puzzleFile objectForKey:@"level"];
    
    gameImageView.image = [UIImage imageNamed:[self.puzzleFile objectForKey:[NSString stringWithFormat:@"image%i",[level intValue]]]];
    
    mode = [level intValue];

}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    placeLetter = [[NSMutableDictionary alloc] init];

    
    NSString *letterDataFile = [[NSBundle mainBundle]  pathForResource:@"allLetter" ofType:@"plist"];
    NSDictionary *allLetterFile = [NSDictionary dictionaryWithContentsOfFile:letterDataFile];

    self.allLetter = [[[NSMutableDictionary alloc] init] autorelease];
    self.allLetterImages = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSDictionary *allLetterDico = [allLetterFile objectForKey:@"all"];
    
    for (NSString *theLetter in [allLetterDico allKeys]) {
                
        NSString *place = [[allLetterDico objectForKey:theLetter] objectForKey:@"place"];
        [self.allLetter setObject:theLetter forKey:place];
        UIImage *letterImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",theLetter]];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:letterImage];
        
        [self.view addSubview:imgView];
        
        CGPoint startLocation;
        startLocation.x = -80;
        startLocation.y = -80;
        imgView.center = startLocation;

        [self.allLetterImages setObject:imgView forKey:theLetter];
        
        [imgView release];
    }
    
    self.view.multipleTouchEnabled=NO;
    self.view.exclusiveTouch=YES;
    
    
//    UIImage *image0 = [UIImage imageNamed:@"01.png"];
//    UIImage *image1 = [UIImage imageNamed:@"02.png"];
//    UIImage *image2 = [UIImage imageNamed:@"03.png"];
    UIImage *image3 = [UIImage imageNamed:@"04.png"];
    UIImage *image4 = [UIImage imageNamed:@"05.png"];
    UIImage *image5 = [UIImage imageNamed:@"06.png"];
    UIImage *image6 = [UIImage imageNamed:@"07.png"];
    UIImage *image7 = [UIImage imageNamed:@"08.png"];
    UIImage *image8 = [UIImage imageNamed:@"09.png"];
    UIImage *image9 = [UIImage imageNamed:@"10.png"];
    UIImage *image10 = [UIImage imageNamed:@"11.png"];
    UIImage *image11 = [UIImage imageNamed:@"12.png"];
    UIImage *image12 = [UIImage imageNamed:@"13.png"];
    UIImage *image13 = [UIImage imageNamed:@"14.png"];
    UIImage *image14 = [UIImage imageNamed:@"15.png"];
    UIImage *image15 = [UIImage imageNamed:@"16.png"];
    UIImage *image16 = [UIImage imageNamed:@"17.png"];
    UIImage *image17 = [UIImage imageNamed:@"18.png"];
    UIImage *image18 = [UIImage imageNamed:@"19.png"];
    UIImage *image19 = [UIImage imageNamed:@"20.png"];
    UIImage *image20 = [UIImage imageNamed:@"21.png"];
    UIImage *image21 = [UIImage imageNamed:@"22.png"];
    UIImage *image22 = [UIImage imageNamed:@"23.png"];
    
//    animImageView.animationImages = [NSArray arrayWithObjects:image0, image0, image0, image0, image1, image2, image3, image4, image5, image6, image7, image8, image9, image10, image11, image12, image13, image14, image15, image16, image17, image18, image19, image20, image21, image22, nil];

//    animImageView.animationImages = [NSArray arrayWithObjects:image22, image21, image20, image19, image18, image17, image16, image15, image14, image13, image12, image11, image10, image9, image8, image7, image6, image5, image4, image3, image2, image1, image0, image1, image2, image3, image2, image1, image0, image1, image2, image3, image2, image1, image0, image1, image2, image3, image2, image3, image4, image5, image6, image7, image8, image9, image10, image11, image12, image13, image14, image15, image16, image17, image18, image19, image20, image21, image22, nil];

    animImageView.animationImages = [NSArray arrayWithObjects:image22, image21, image20, image19, image18, image17, image16, image15, image14, image13, image12, image11, image10, image9, image8, image7, image6, image5, image4, image3, image3, image3, image3, image4, image5, image6, image7, image8, image9, image10, image11, image12, image13, image14, image15, image16, image17, image18, image19, image20, image21, image22, nil];

    
    [animImageView setAnimationDuration:5.0f];
    animImageView.animationRepeatCount = 1;

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
