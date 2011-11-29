//
//  CreditViewController.h
//  puzzleipad
//
//  Created by Samuel Liard on 20/11/11.
//  Copyright (c) 2011 Liard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditViewController : UIViewController {
    
    IBOutlet UIImageView *backgroundPage;

    IBOutlet UIScrollView *scrollView;

}

@property (retain, nonatomic) UIImageView *backgroundPage;
@property (retain, nonatomic) UIScrollView *scrollView;

- (IBAction)pressReturn;

@end
