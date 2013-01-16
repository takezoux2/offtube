//
//  DetailViewController.m
//  Offtube
//
//  Created by Takeshita Yoshiteru on 13/01/17.
//  Copyright (c) 2013年 Takezoux2. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()

@end

@implementation DetailViewController{
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UIImageView *thumbnailImage;
    VideoData *_data;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
}

- (IBAction)pushWatchOffline:(id)sender
{
    
}

- (IBAction)pushWatchOfflineOnlySound:(id)sender{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setData:(VideoData *)data{
    
    _data = data;
    
    
    
}

@end
