//
//  VideoData.h
//  Offtube
//
//  Created by Takeshita Yoshiteru on 13/01/16.
//  Copyright (c) 2013年 Takezoux2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoData : NSObject


@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSData *thumbnailData;
@property (strong,nonatomic) NSString *thumbnailUrl;
@property (strong,nonatomic) NSString * description;
@property (strong,nonatomic) NSString *videoId;

@end


static VideoData* parseData(NSDictionary *dict){
    VideoData *data = [[VideoData alloc] init];
    
    NSString *fullId = [[dict objectForKey:@"id"] objectForKey:@"$t"];
    data.videoId = [[fullId componentsSeparatedByString:@":"] lastObject];
    data.title = [[dict objectForKey:@"title"] objectForKey:@"$t"];
    data.thumbnailUrl = [[[[dict objectForKey:@"media$group"] objectForKey:@"media$thumbnail"] objectAtIndex:0] objectForKey:@"url"];
    data.description = [[[dict objectForKey:@"media$group"] objectForKey:@"media$description"] objectForKey:@"$t"]; 
    
    return data;
}