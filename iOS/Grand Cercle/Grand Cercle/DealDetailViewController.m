//
//  DealDetailViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 19/8/13.
//  Copyright (c) 2013 Ensimag. All rights reserved.
//

#import "DealDetailViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIScreen.h"

@interface DealDetailViewController ()

@end

@implementation DealDetailViewController

@synthesize lTitle, lSubtitle, wvContent, vBkgd, event, ivImage;

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
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(addToCalendar)];
    self.navigationItem.rightBarButtonItem = plusButton;
    
    self.title = NSLocalizedString(@"Events", @"Events");
    
    [wvContent setFrame:CGRectMake(wvContent.frame.origin.x, wvContent.frame.origin.y, wvContent.frame.size.width, 0)];
    wvContent.scrollView.scrollEnabled = NO;
    
    NSString *htmlHead = @"<style type=\"text/css\">\
    body {\
    font-family: \"Helvetica Neue\", Helvetica, Arial, \"Lucida Grande\", sans-serif;\
    font-size: 14px;\
    color : #505050;\
    }\
    iframe {\
    max-width:290px;\
    height : *;\
    }\
    </style>";
    [wvContent loadHTMLString:[NSString stringWithFormat:@"%@ %@", htmlHead, event.content] baseURL:nil];
    [plusButton release];
    
    [lTitle setText:event.title];
    [lSubtitle setText:event.subtitle];
    
}


- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *c = [defaults objectForKey:@"theme"];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [lTitle release];
    [lSubtitle release];
    [wvContent release];
    [vBkgd release];
    [ivImage release];
    [super dealloc];
}
- (void)viewDidUnload {
    [lTitle release];
    lTitle = nil;
    [lSubtitle release];
    lSubtitle = nil;
    [self setLSubtitle:nil];
    [self setLTitle:nil];
    [self setWvContent:nil];
    [wvContent release];
    wvContent = nil;
    [vBkgd release];
    vBkgd = nil;
    [self setVBkgd:nil];
    [ivImage release];
    ivImage = nil;
    [self setIvImage:nil];
    [super viewDidUnload];
}


#pragma mark - Webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView == wvContent) {
        NSString *output = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
        
        
        [webView setFrame:CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, [output intValue])];
        
        NSURL *imageURL;
        if ([UIScreen retinaScreen])
            imageURL = [NSURL URLWithString:event.image];
        else
            imageURL = [NSURL URLWithString:event.image];
        
        [ivImage setImageWithURL:imageURL placeholderImage:nil];
//    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
//         {
//             if (image)
//             {
//                 CGRect frame = ivImage.frame;
//                 frame.size.height = ivImage.image.size.height/2;
//                 ivImage.frame = frame;
//                 
//                 frame = vBkgd.frame;
//                 frame.size.height = MAX(ivImage.frame.origin.y + ivImage.frame.size.height + 5, self.view.frame.size.height - 10);
//                 vBkgd.frame = frame;
//                 
//                 UIScrollView * sv =  (UIScrollView *)(self.view);
//                 sv.contentSize = CGSizeMake(sv.contentSize.width, vBkgd.frame.size.height + 10);
//             }
//         }];
//        CGRect frame = ivImage.frame;
//        frame.origin.y = webView.frame.origin.y + webView.frame.size.height + 10;
//        ivImage.frame = frame;
        
        CGRect frame = vBkgd.frame;
        frame.size.height = MAX(webView.frame.origin.y + webView.frame.size.height + 5, self.view.frame.size.height - 10);
        vBkgd.frame = frame;
        
        UIScrollView * sv =  (UIScrollView *)(self.view);
        sv.contentSize = CGSizeMake(sv.contentSize.width, vBkgd.frame.size.height + 10);
        
    }
}

@end
