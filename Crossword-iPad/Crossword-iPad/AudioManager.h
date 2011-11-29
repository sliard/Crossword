//
//  AudioManager.h
//  iCat
//
//  Created by Samuel Liard on 24/01/10.
//  Copyright net-liard.com 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolBox/AudioToolBox.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioManager : NSObject <AVAudioPlayerDelegate>
{
    NSData          *mAudioData;
    AVAudioPlayer   *mAudioPlayer;
    AVAudioPlayer   *mAudioPlayerSound;
    
}

+ (AudioManager*) getSingleton;

- (BOOL) playBackgroundSound;
- (BOOL) stop;
- (BOOL) isPlaying;
- (void) reStart;
- (BOOL) playSound:(NSString *)fileName;

@end