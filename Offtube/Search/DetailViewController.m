//
//  DetailViewController.m
//  Offtube
//
//  Created by Takeshita Yoshiteru on 13/01/17.
//  Copyright (c) 2013年 Takezoux2. All rights reserved.
//

#import "DetailViewController.h"
#import "TK2PlayerViewController.h"
#import "Downloader.h"


@interface DetailViewController ()

@end

@implementation DetailViewController{
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UIImageView *thumbnailImage;
    BOOL onlySound;
    VideoData *_data;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        onlySound = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleLabel.text = _data.title;
    descriptionLabel.text = _data.description;
    thumbnailImage.image = [UIImage imageWithData:_data.thumbnailData];
}

- (IBAction)pushWatchByWeb:(id)sender
{
    NSString *url = [[Downloader sharedInstance] getPageURL:_data];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
}

- (IBAction)pushWatchOffline:(id)sender
{
    onlySound = NO;
    [self performSegueWithIdentifier:@"playOffline" sender:self];
}

- (IBAction)pushWatchOfflineOnlySound:(id)sender{
    
    onlySound = YES;
    [self performSegueWithIdentifier:@"playOffline" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setData:(VideoData *)data{
    
    _data = data;
    
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"playOffline"]) {
        TK2PlayerViewController *viewController = (TK2PlayerViewController*)[segue destinationViewController];
        viewController.data = _data;
        viewController.onlySound = onlySound;
    }
    
}

@end
