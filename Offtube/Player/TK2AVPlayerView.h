//
//  TK2AVPlayerView.h
//  Offtube
//
//  Created by Takeshita Yoshiteru on 13/01/17.
//  Copyright (c) 2013年 Takezoux2. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TK2AVPlayerDelegate

- (void)beginPlay:(Float64)time;
- (void)pausePlay:(Float64)time;
- (void)playing:(Float64)time;


@end

@interface TK2AVPlayerView : UIView

@property (assign,readonly) CGFloat totalPlayTime;
@property (assign,atomic) CGFloat currentPlayTime;
@property (strong,atomic) id<TK2AVPlayerDelegate> playerDelegate;

- (void)loadVideo:(NSURL *)path;
- (void)play;
- (void)pause;


@end
