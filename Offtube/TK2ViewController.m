//
//  TK2ViewController.m
//  Offtube
//
//  Created by Takeshita Yoshiteru on 13/01/16.
//  Copyright (c) 2013年 Takezoux2. All rights reserved.
//

#import "TK2ViewController.h"
#import <AFNetworking/AFNetworking.h>

#import "VideoData.h"
#import "DetailViewController.h"

@interface TK2ViewController ()

@end

@implementation TK2ViewController{
    
    __weak IBOutlet UITextField *searchText;
    AFHTTPClient *client;
    SearchResultTableViewController *resultController;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if(client == nil){
        
        NSURL *url = [NSURL URLWithString:@"http://gdata.youtube.com"];
        client = [[AFHTTPClient alloc] initWithBaseURL:url];
        [client setDefaultHeader:@"X-GData-Key" value:@"key=AI39si6dKOV5aWEVF0OUH2bsdPgfyIj6fvj99sq87XOa0jJikB-9qIbxpfmsvxUbXC8ibCfDNAT_TGvE_mlPXBa3N5L93x4bpg"];
        
        NSInteger HEIGHT = 60;
        resultController = [[SearchResultTableViewController alloc] init];
        resultController.tableView.frame = CGRectMake(0, HEIGHT, self.view.frame.size.width, self.view.frame.size.height - HEIGHT);
        resultController.selectDelegete = self;
        [self.view addSubview:resultController.tableView];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushSearch:(id)sender
{
    
    [searchText resignFirstResponder];
    NSString* query = searchText.text;
    
    AFJSONRequestOperation* ope = [AFJSONRequestOperation JSONRequestOperationWithRequest:[client requestWithMethod:@"GET" path:@"/feeds/api/videos" parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"v",query,@"q",@"json",@"alt",@"20",@"max-results", nil]] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        Logging(@"entries are %@",[JSON objectForKey:@"feed"]);
        id title = [[[[JSON objectForKey:@"feed"] objectForKey:@"entry"] objectAtIndex:0] objectForKey:@"title"];
        Logging(@"First title is %@",[title objectForKey:@"$t"]);
        Logging(@"%d items",[[[JSON objectForKey:@"feed"] objectForKey:@"entry"] count]);
        
        NSMutableArray* list = [NSMutableArray arrayWithCapacity:20];
        for(NSDictionary *d in [[JSON objectForKey:@"feed"] objectForKey:@"entry"]){
            VideoData *data = parseData(d);
            [list addObject:data];
        }
        
        
        [resultController updateCells:list];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        Logging(@"%@",request.URL);
        Logging(@"Fail %@",error);
        ALERT(@"Network error.Please retry.");
    }];
    
    [ope start];
}

- (void)showDetail:(VideoData *)data{
    
    [self performSegueWithIdentifier:@"detail" sender:data];
    
}

- (void)didSelectSearchResult:(VideoData *)data{
    Logging(@"Selected %@",data.title);
    [self showDetail:data];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"detail"]) {
        DetailViewController *viewController = (DetailViewController*)[segue destinationViewController];
        [viewController setData:sender];
    }

}

@end
