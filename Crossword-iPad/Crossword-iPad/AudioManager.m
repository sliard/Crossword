//
//  AudioManager.m
//  iCat
//
//  Created by Samuel Liard on 24/01/10.
//  Copyright net-liard.com 2010. All rights reserved.
//

#import "AudioManager.h"

@implementation AudioManager

static AudioManager *singleton = nil;

+ (AudioManager*) getSingleton
{
    if (singleton == nil) {
        singleton = [[AudioManager alloc] init];
        
        // Audio Session settings
        AudioSessionInitialize( NULL, NULL, NULL, self );
        UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);

    }
    return singleton;
}

- (void) dealloc
{
    if( mAudioData )
    {
        [mAudioData release];
    }
    
    [super dealloc];
}

- (NSData *) getAudioData:(NSString *)fileName {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"]; 
	return [[[NSData alloc] initWithContentsOfFile:filePath] autorelease];
}

- (BOOL) playSound:(NSString *)fileName {
        
        // Loading audio data
        NSError  * error;
        if( mAudioPlayerSound != nil )
        {
            
            [mAudioPlayerSound release];
            mAudioPlayerSound = nil;
        }
        mAudioPlayerSound = [[AVAudioPlayer alloc] initWithData:[self getAudioData:fileName] error:&error];
        
        // Init OK? If so launch playing...
        if( error )
        {
            NSLog(@"Error while initializing MP3 playing: %@", error.userInfo);
        }
        else
        {
            mAudioPlayerSound.volume = 1.0 ;
			mAudioPlayerSound.numberOfLoops = 0;
            [mAudioPlayerSound prepareToPlay];
            [mAudioPlayerSound setDelegate:self];
            [mAudioPlayerSound play];
        }
        return TRUE;
    }


- (NSData *) getAudioData {

	if(mAudioData == nil) {
		
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"africa_day" ofType:@"mp3"]; 
		mAudioData = [[NSData alloc] initWithContentsOfFile:filePath];
		
	}
	
	return mAudioData;
}

- (BOOL) playBackgroundSound
{
        
        // Loading audio data
        NSError  * error;
        if( mAudioPlayer != nil )
        {
            [mAudioPlayer release];
            mAudioPlayer = nil;
        }
        mAudioPlayer = [[AVAudioPlayer alloc] initWithData:[self getAudioData] error:&error];
        
        // Init OK? If so launch playing...
        if( error )
        {
            NSLog(@"Error while initializing MP3 playing: %@", error.userInfo);
        }
        else
        {
            mAudioPlayer.volume = 0.3;
			mAudioPlayer.numberOfLoops = -1;
            [mAudioPlayer prepareToPlay];
            [mAudioPlayer setDelegate:self];
            [mAudioPlayer play];
        }
    return TRUE;
}

- (void) reStart {
	[mAudioPlayer play];
}

- (BOOL) stop
{
    BOOL result = NO;
    
    if( [self isPlaying] )
    {
        [mAudioPlayer stop];
        result = YES;
    }
    return result;
}

- (BOOL) isPlaying
{
    BOOL result = NO;
    
    if( mAudioPlayer && [mAudioPlayer isPlaying] )
    {
        return YES;
    }
    return result;
}

@end
