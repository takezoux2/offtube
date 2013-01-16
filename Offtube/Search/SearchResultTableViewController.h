//
//  SearchResultTableViewController.h
//  Offtube
//
//  Created by Takeshita Yoshiteru on 13/01/16.
//  Copyright (c) 2013年 Takezoux2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoData.h"

@protocol SelectSerachResult 

- (void)didSelectSearchResult:(VideoData *)data;

@end

@interface SearchResultTableViewController : UITableViewController


@property (strong,nonatomic) id<SelectSerachResult> selectDelegete;

- (void)updateCells:(NSArray *)results;

@end
