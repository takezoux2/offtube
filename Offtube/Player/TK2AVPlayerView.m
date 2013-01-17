//
//  TK2AVPlayerView.m
//  Offtube
//
//  Created by Takeshita Yoshiteru on 13/01/17.
//  Copyright (c) 2013年 Takezoux2. All rights reserved.
//

#import "TK2AVPlayerView.h"
#import <AVFoundation/AVFoundation.h>


@implementation TK2AVPlayerView{
    AVPlayer *player;
    id<TK2AVPlayerDelegate> playerDelegate;
}

@synthesize playerDelegate;

+ (Class)layerClass{
    return [AVPlayerLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (CGFloat)totalPlayTime{
    return CMTimeGetSeconds(player.currentItem.duration);
}

- (CGFloat)currentPlayTime{
    return CMTimeGetSeconds(player.currentTime);
}

- (void)setCurrentPlayTime:(CGFloat)currentPlayTime{
    [player seekToTime:CMTimeMakeWithSeconds(currentPlayTime, NSEC_PER_SEC)];
}


- (void)loadVideo:(NSURL *)path{
    
    if(player && player.currentItem){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    player = [AVPlayer playerWithURL:path];
    AVPlayerLayer *layer = (AVPlayerLayer *)self.layer;
    layer.player = player;
    
    CMTime interval = CMTimeMakeWithSeconds(0.5f, NSEC_PER_SEC);
    id<TK2AVPlayerDelegate> dele = playerDelegate;
    [player addPeriodicTimeObserverForInterval:interval queue:NULL usingBlock:^(CMTime time) {
        if(dele != nil){
            [dele playing:CMTimeGetSeconds(player.currentTime)];
        }
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFinishPlay) name:AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem];
}

- (void)onFinishPlay{
    Logging(@"Finish play");
    [player seekToTime:CMTimeMakeWithSeconds(0.0f, NSEC_PER_SEC)];
    [player play];
}

- (void)play{
    [player play];
    if(playerDelegate) [playerDelegate beginPlay:CMTimeGetSeconds(player.currentTime)];
}

- (void)pause{
    [player pause];
    if(playerDelegate) [playerDelegate pausePlay:CMTimeGetSeconds(player.currentTime)];
}

@end
