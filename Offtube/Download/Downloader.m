//
//  Downloader.m
//  Offtube
//
//  Created by Takeshita Yoshiteru on 13/01/17.
//  Copyright (c) 2013年 Takezoux2. All rights reserved.
//

#import "Downloader.h"
#import <HCYoutubeParser/HCYoutubeParser.h>
#import <AFNetworking/AFNetworking.h>
#import "ANMovie.h"

@implementation Downloader{
    NSString *lastDownloadedVideoId;
}

static Downloader * _sharedInstance = nil;

- (id)init
{
    self = [super init];
    if (self) {
        lastDownloadedVideoId = nil;
    }
    return self;
}

+ (Downloader*)sharedInstance {
    @synchronized(self) {
        if (_sharedInstance == nil) {
            (void) [[self alloc] init]; // ここでは代入していない
        }
    }
    return _sharedInstance;
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;  // 最初の割り当てで代入し、返す
        }
    }
    return nil; // 以降の割り当てではnilを返すようにする
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}


- (NSString *)filePath:(NSString *)filename{
    NSString *homeDir = [[NSString stringWithString:NSHomeDirectory()] stringByAppendingPathComponent:@"Library/Caches"];
    return [homeDir stringByAppendingPathComponent:filename];
    
}

- (NSString *)getPageURL:(VideoData *)data {
    return [@"http://www.youtube.com/watch?v=" stringByAppendingString:data.videoId];
}

- (void)downloadVideo:(VideoData *)data complete:(void(^)(NSURL *videoFile))onComplete fail:(void(^)(DownloadError error))onFail
{
    
    NSString *videoFilename = [self filePath:@"cache.mp4"];
    NSURL *filePath = [NSURL fileURLWithPath:videoFilename];
    if([lastDownloadedVideoId isEqualToString:data.videoId]){
        Logging(@"Find in cache");
        onComplete(filePath);
        return;
    }
    /*NSError *e = nil;
    [[NSFileManager defaultManager] removeItemAtURL:filePath error:&e];
    if(e){
        NSLog(@"Fail to delete file %@",e);
    }*/
    
    
    // For future.
    //NSString *videoFilename = [self filePath:[data.videoId stringByAppendingString:@".mp4"]];
    //NSString *soundFilename = [self filePath:[data.videoId stringByAppendingString:@".aac"]];
    //NSString *soundFilename = [self filePath:@"cache.aac"];
    
    NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeURL:[NSURL URLWithString:[self getPageURL:data]]];
    
    
    NSURL *url = [NSURL URLWithString:[videos objectForKey:@"medium"]];
    if(url == nil){
        url = [[videos objectEnumerator] nextObject];
    }
    
    if(url == nil){
        onFail(DOWNLOAD_NO_AVAILABLE_VIDEOS);
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath.path append:NO];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        Logging(@"Success to download %@",url);
        
        lastDownloadedVideoId = data.videoId;
        onComplete(filePath);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Logging(@"Fail to download %@",url);
        
        onFail(DOWNLOAD_NETWORK_ERROR);
    }];
    Logging(@"Begin download file %@",url);
    [operation start];
}

- (void)downloadSound:(VideoData *)data complete:(void(^)(NSURL *soundFile))onComplete fail:(void(^)(DownloadError error))onFail
{
    [self downloadVideo:data complete:^(NSURL *videoFile) {
        ANMovie *movie = [[ANMovie alloc] initWithFile:videoFile.path];
        NSString *soundFilename = [self filePath:@"cache.aac"];
        
        [movie exportAACToFile:soundFilename];
        [movie close];
        
        int size = [[[NSFileManager defaultManager] attributesOfItemAtPath:soundFilename error:NULL] fileSize];
        Logging(@"Sound file size = %d",size);
        onComplete([NSURL fileURLWithPath:soundFilename]);
    } fail:^(DownloadError error) {
        onFail(error);
    }];
}




@end
