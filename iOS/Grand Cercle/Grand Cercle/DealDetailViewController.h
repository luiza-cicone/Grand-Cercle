//
//  DealDetailViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 19/8/13.
//  Copyright (c) 2013 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface DealDetailViewController : UIViewController <UIWebViewDelegate>
{

    IBOutlet UILabel *lTitle;
    IBOutlet UILabel *lSubtitle;
    IBOutlet UIWebView *wvContent;
    IBOutlet UIView *vBkgd;
    Deal *event;
    IBOutlet UIImageView *ivImage;
    
}
@property (retain, nonatomic) IBOutlet UILabel *lSubtitle;
@property (retain, nonatomic) IBOutlet UILabel *lTitle;
@property (retain, nonatomic) IBOutlet UIWebView *wvContent;
@property (retain, nonatomic) IBOutlet UIView *vBkgd;
@property (retain, nonatomic) Deal *event;
@property (retain, nonatomic) IBOutlet UIImageView *ivImage;

@end
