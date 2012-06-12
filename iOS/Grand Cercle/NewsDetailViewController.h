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
    // News de la vue détaillée
    News *news;
    // Cellule titre de la news
    IBOutlet UITableViewCell *cellNewsTop;
    // Cellule description de la news
    IBOutlet UITableViewCell *cellNewsDescription;
    // Hauteur de la cellule de description
    int webViewHeight;
}

@property (retain, nonatomic) News *news;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellNewsDescription, *cellNewsTop;
@end