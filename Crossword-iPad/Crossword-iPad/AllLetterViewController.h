//
//  AllLetterViewController.h
//  Crossword-iPad
//
//  Created by Samuel Liard on 24/11/11.
//  Copyright (c) 2011 Liard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllLetterViewController : UIViewController {
    
    IBOutlet UIScrollView *scrollView;

}

@property (retain, nonatomic) UIScrollView *scrollView;

- (IBAction)pressReturn;

@end
