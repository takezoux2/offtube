//
//  TK2PlayerViewController.m
//  Offtube
//
//  Created by Takeshita Yoshiteru on 13/01/17.
//  Copyright (c) 2013年 Takezoux2. All rights reserved.
//

#import "TK2PlayerViewController.h"
#import "Downloader.h"

static NSString * secToString(Float64 sec){
    NSInteger minutes = ((NSInteger)sec) / 60;
    NSInteger seconds = ((NSInteger)sec) % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];    
}

@interface TK2PlayerViewController ()

@end

@implementation TK2PlayerViewController{
    VideoData *data;
    UIView *glayCover;
    TK2AVPlayerView *playerView;
    
    __weak IBOutlet UISlider *playTimeSlider;
    __weak IBOutlet UIButton *playButton;
    __weak IBOutlet UILabel *currentPlayTimeLabel;
    __weak IBOutlet UILabel *totalPlayTimeLabel;
    
    BOOL onlySound;
    BOOL playing;
    UIImage *toggleImage;
    UILabel *onlySoundLabel;
}

@synthesize data;
@synthesize onlySound;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        playing = NO;
    }
    return self;
}

- (void)cover{
    
    glayCover = [[UIView alloc] initWithFrame:self.view.frame];
    glayCover.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    [self.view addSubview:glayCover];
    
    CGFloat width = self.view.frame.size.width;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((width - 50) / 2, 100, 50, 50)];
    [glayCover addSubview:indicator];
    [indicator startAnimating];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, width, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    label.text = @"Caching";
    [glayCover addSubview:label];
    
}

- (void)uncover{
    [glayCover removeFromSuperview];
    glayCover = nil;
}

- (void)loadData:(VideoData *)_data{
    Downloader *downloader = [Downloader sharedInstance];
    
    if(onlySound){
        [downloader downloadSound:_data complete:^(NSURL *soundFile) {
            [playerView loadVideo:soundFile];
            
            playTimeSlider.minimumValue = 0;
            playTimeSlider.maximumValue = playerView.totalPlayTime;
            playTimeSlider.value = 0;
            
            currentPlayTimeLabel.text = secToString(0);
            totalPlayTimeLabel.text = secToString(playerView.totalPlayTime);
            
            [self uncover];
        } fail:^(DownloadError error) {
            switch (error) {
                case DOWNLOAD_NETWORK_ERROR:{
                    ALERT(@"Network error.Please retry later.");
                    break;
                }
                case DOWNLOAD_NO_AVAILABLE_VIDEOS:{
                    ALERT(@"No available videos.");
                    break;
                }
                default:{
                    ALERT(@"Unknown error");
                    break;
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.view addSubview:onlySoundLabel];
    }else{
        [downloader downloadVideo:_data complete:^(NSURL *videoFile) {
            [playerView loadVideo:videoFile];
            
            playTimeSlider.minimumValue = 0;
            playTimeSlider.maximumValue = playerView.totalPlayTime;
            playTimeSlider.value = 0;
            
            currentPlayTimeLabel.text = secToString(0);
            totalPlayTimeLabel.text = secToString(playerView.totalPlayTime);
            
            [self uncover];
        } fail:^(DownloadError error) {
            switch (error) {
                case DOWNLOAD_NETWORK_ERROR:{
                    ALERT(@"Network error.Please retry later.");
                    break;
                }
                case DOWNLOAD_NO_AVAILABLE_VIDEOS:{
                    ALERT(@"No available videos.");
                    break;
                }
                default:{
                    ALERT(@"Unknown error");
                    break;
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [onlySoundLabel removeFromSuperview];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    toggleImage = [UIImage imageNamed:@"pause.png"];
    CGFloat width = self.view.frame.size.width;
    playerView = [[TK2AVPlayerView alloc] initWithFrame:CGRectMake(0, 0, width, width * 0.75)];
    playerView.playerDelegate = self;
    [self.view addSubview:playerView];
    
    onlySoundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, width, 20)];
    onlySoundLabel.text = @"Sound only";
    onlySoundLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    onlySoundLabel.textAlignment = NSTextAlignmentCenter;
    
    [self cover];
    [self loadData:data];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [playerView pause];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushPlay:(id)sender{
    
    UIImage *temp = playButton.currentImage;
    [playButton setImage:toggleImage forState:UIControlStateNormal];
    toggleImage = temp;
    
    if(!playing){
        [playerView play];
    }else{
        [playerView pause];
    }
}

- (IBAction)slidePlayTime:(id)sender{
    UISlider *slider = (UISlider *)sender;
    playerView.currentPlayTime = slider.value;
}

#pragma mark - AVPlayer delegate

- (void)beginPlay:(Float64)time{
    Logging(@"Begin playing");
    playing = YES;
}

- (void)playing:(Float64)time{
    playTimeSlider.value = time;
    currentPlayTimeLabel.text = secToString(time);
}

- (void)pausePlay:(Float64)time{
    Logging(@"Pause playing");
    playing = NO;
}


@end
