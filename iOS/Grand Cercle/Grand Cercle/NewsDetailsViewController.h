//
//  NewsDetailsViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 19/8/13.
//  Copyright (c) 2013 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsDetailsViewController : UIViewController <UIWebViewDelegate>
{
    
    IBOutlet UILabel *lTitle;
    IBOutlet UILabel *lAuthor;
    IBOutlet UILabel *lPubDate;
    IBOutlet UIWebView *wvContent;
    IBOutlet UIImageView *ivImage;
    IBOutlet UIView *vAuthorBkgd;
    IBOutlet UIView *vBkgd;
    News *event;
    
}
@property (retain, nonatomic) IBOutlet UILabel *lTitle;
@property (retain, nonatomic) IBOutlet UILabel *lAuthor;
@property (retain, nonatomic) IBOutlet UILabel *lPubDate;
@property (retain, nonatomic) IBOutlet UIWebView *wvContent;
@property (retain, nonatomic) IBOutlet UIImageView *ivImage;
@property (retain, nonatomic) IBOutlet UIView *vAuthorBkgd;
@property (retain, nonatomic) IBOutlet UIView *vBkgd;
@property (retain, nonatomic) News *event;
@end
