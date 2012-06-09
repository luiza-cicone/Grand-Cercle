//
//  NewsDetailViewController.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 01/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsDetailViewController : UITableViewController <UIWebViewDelegate> {
    News *news;
    IBOutlet UITableViewCell *cellNewsTop;
    IBOutlet UITableViewCell *cellNewsDescription;
    int webViewHeight;

}

@property (retain, nonatomic) News *news;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellNewsDescription, *cellNewsTop;
@end
