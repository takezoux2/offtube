//
//  Downloader.h
//  Offtube
//
//  Created by Takeshita Yoshiteru on 13/01/17.
//  Copyright (c) 2013年 Takezoux2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoData.h"

typedef enum{
    DOWNLOAD_NO_AVAILABLE_VIDEOS,
    DOWNLOAD_NETWORK_ERROR
} DownloadError;

@interface Downloader : NSObject

+ (Downloader *)sharedInstance;

- (void)cancel;
- (NSString *)getPageURL:(VideoData *)data;
- (void)downloadVideo:(VideoData *)data
             progress:(void(^)(CGFloat percent))onProgress
             complete:(void(^)(NSURL *videoFile))onComplete
             fail:(void(^)(DownloadError error))onFail;
- (void)downloadSound:(VideoData *)data
             progress:(void(^)(CGFloat percent))onProgress
             complete:(void(^)(NSURL *soundFile))onComplete
             fail:(void(^)(DownloadError error))onFail;

@end
