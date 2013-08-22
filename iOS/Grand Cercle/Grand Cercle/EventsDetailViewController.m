//
//  EventsDetailViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 17/8/13.
//  Copyright (c) 2013 Ensimag. All rights reserved.
//

#import "EventsDetailViewController.h"
#import "NSString+HTML.h"
#import "AppDelegate.h"
#import "Association.h"
#import "UIScreen.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface EventsDetailViewController ()

@end

@implementation EventsDetailViewController

@synthesize event;
@synthesize lTitle, lAuthor, lLocation;
@synthesize wvContent, lDate, ivImage, vAuthorBkgd, vBkgd;

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
    [lDate setText:[NSString stringWithFormat:@"%@, %@ à %@", event.day, event.dateText, event.time]];
    [lLocation setText:event.location];
    [lAuthor setText:event.author.name];
    
    CGRect frame = lAuthor.frame;
    CGSize s = [lAuthor.text sizeWithFont:lAuthor.font constrainedToSize:CGSizeMake(160, MAXFLOAT) lineBreakMode:lAuthor.lineBreakMode];
    frame.size.width = s.width + 4;
    lAuthor.frame = frame;
    vAuthorBkgd.frame = frame;

    [vAuthorBkgd setBackgroundColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate]colorWithHexString:event.author.color]];

}


- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *c = [defaults objectForKey:@"theme"];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
}


-(void) addToCalendar {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Retour" destructiveButtonTitle:nil otherButtonTitles:@"Exporter dans iCal", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.destructiveButtonIndex = 2;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [actionSheet showInView: appDelegate.window];
    [actionSheet release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
    [ivImage release];
    [lTitle release];
    [lLocation release];
    [lAuthor release];
    [wvContent release];
    [lDate release];
    [vAuthorBkgd release];
    [vBkgd release];
    [super dealloc];
}
- (void)viewDidUnload {
    [ivImage release];
    ivImage = nil;
    [self setIvImage:nil];
    [lTitle release];
    lTitle = nil;
    [self setTitle:nil];
    [time release];
    time = nil;
    [self setLLocation:nil];
    [lAuthor release];
    lAuthor = nil;
    [self setLAuthor:nil];
    [wvContent release];
    wvContent = nil;
    [self setWvContent:nil];
    [lDate release];
    lDate = nil;
    [self setLDate:nil];
    [vAuthorBkgd release];
    vAuthorBkgd = nil;
    [self setVAuthorBkgd:nil];
    [vBkgd release];
    vBkgd = nil;
    [self setVBkgd:nil];
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
            imageURL = [NSURL URLWithString:event.image2x];
        else
            imageURL = [NSURL URLWithString:event.image];

        [ivImage setImageWithURL:imageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             if (image)
             {
                 CGRect frame = ivImage.frame;
                 if ([UIScreen retinaScreen])
                     frame.size.height = ivImage.image.size.height/2;
                 else
                     frame.size.height = ivImage.image.size.height;
                 ivImage.frame = frame;
                 
                 frame = vBkgd.frame;
                 frame.size.height = MAX(ivImage.frame.origin.y + ivImage.frame.size.height + 5, self.view.frame.size.height - 10);
                 vBkgd.frame = frame;
                 
                 UIScrollView * sv =  (UIScrollView *)(self.view);
                 sv.contentSize = CGSizeMake(sv.contentSize.width, vBkgd.frame.size.height + 10);
             }
         }];
        CGRect frame = ivImage.frame;
        frame.origin.y = webView.frame.origin.y + webView.frame.size.height + 10;
        ivImage.frame = frame;
        
        frame = vBkgd.frame;
        frame.size.height = MAX(ivImage.frame.origin.y + ivImage.frame.size.height + 5, self.view.frame.size.height - 10);
        vBkgd.frame = frame;
        
        UIScrollView * sv =  (UIScrollView *)(self.view);
        sv.contentSize = CGSizeMake(sv.contentSize.width, vBkgd.frame.size.height + 10);

    }
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    return YES;
}

#pragma mark - ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        EKEventStore *eventStore = [[EKEventStore alloc] init];

        // Choix du calendrier
        /* iOS 6 requires the user grant your application access to the Event Stores */
        if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
        {
            /* iOS Settings > Privacy > Calendars > MY APP > ENABLE | DISABLE */
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
             {
                 if ( granted )
                 {
                     EKEvent *myEvent  = [EKEvent eventWithEventStore:eventStore];
                     myEvent.title     = event.title;
                     myEvent.startDate = event.date;
                     myEvent.endDate   = event.date;
                     myEvent.allDay = YES;
                     myEvent.notes = [event.content stringByConvertingHTMLToPlainText];
                     myEvent.location = event.location;
                     
                     [myEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
                     
                     NSError *err;
                     [eventStore saveEvent:myEvent span:EKSpanThisEvent error:&err];
                     if (err == noErr) {
                         UIAlertView *alert = [[UIAlertView alloc]
                                               initWithTitle:@"Exportation iCal"
                                               message:@"Exportation éffectuée avec succés"
                                               delegate:nil
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
                         [alert show];
                         [alert release];
                     }
                     NSLog(@"User has granted permission!");
                 }
                 else
                 {
                     NSLog(@"User has not granted permission!");
                 }
             }];
        }
    }
}



@end
