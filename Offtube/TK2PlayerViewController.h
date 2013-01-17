//
//  TK2PlayerViewController.h
//  Offtube
//
//  Created by Takeshita Yoshiteru on 13/01/17.
//  Copyright (c) 2013年 Takezoux2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoData.h"
#import "TK2AVPlayerView.h"

@interface TK2PlayerViewController : UIViewController<TK2AVPlayerDelegate>

@property (strong,nonatomic) VideoData *data;
@property (assign,atomic) BOOL onlySound;

@end
