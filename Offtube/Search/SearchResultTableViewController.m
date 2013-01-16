//
//  SearchResultTableViewController.m
//  Offtube
//
//  Created by Takeshita Yoshiteru on 13/01/16.
//  Copyright (c) 2013年 Takezoux2. All rights reserved.
//

#import "SearchResultTableViewController.h"
#import <AFNetworking/AFNetworking.h>

#define CELL_HEIGHT 60

@interface SearchResultTableViewController ()

@end

@implementation SearchResultTableViewController{
    NSArray *_results;
    id<SelectSerachResult> selectDelegate;
    
}
@synthesize selectDelegete;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = CELL_HEIGHT;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateCells:(NSArray *)results{
    _results = results;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat frameWidth = tableView.frame.size.width;
    CGRect tmp_rect = CGRectMake(0, 0, tableView.frame.size.width, CELL_HEIGHT);
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:tmp_rect];    
    
    VideoData *data = [_results objectAtIndex:indexPath.item];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               CELL_HEIGHT + 3, 5,
                                                               frameWidth - CELL_HEIGHT - 50, 20)];
    title.text = data.title;
    
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, CELL_HEIGHT, CELL_HEIGHT)];
    [indicator startAnimating];
    indicator.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    
    // Get thumbnail
    NSString *thumnailUrl = data.thumbnailUrl;
    NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:thumnailUrl]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:rq];
    NSOutputStream *stream = [NSOutputStream outputStreamToMemory];
    operation.outputStream = stream;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIImageView *thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_HEIGHT, CELL_HEIGHT)];
        NSData *imageData = [stream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
        data.thumbnailData = imageData;
        thumbnail.image = [UIImage imageWithData:imageData];
        [cell addSubview:thumbnail];
        [indicator removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [indicator stopAnimating];
    }];
    [cell addSubview:title];
    [cell addSubview:indicator];
    [operation start];
    
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Logging(@"Select at %d",indexPath.item);
    VideoData *data = [_results objectAtIndex:indexPath.item];
    
    Logging(@"Dele %@",selectDelegete);
    [selectDelegete didSelectSearchResult:data];
    
}

@end
