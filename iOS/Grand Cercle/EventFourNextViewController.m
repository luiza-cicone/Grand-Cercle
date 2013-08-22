//
//  EventFourNextViewController.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 01/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EventFourNextViewController.h"
#import "EventsParser.h"
#import "Event.h"
#import "EventsDetailViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIScreen.h"

@implementation EventFourNextViewController
@synthesize superController;
@synthesize event, imageCache;
@synthesize titleLabel, dateLabel, placeLabel, hourLabel, eventImageView;
@synthesize vBkgd, bDetail, vText;

int borneSup = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (managedObjectContext == nil) { 
            managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        }
    }
    
    return self;
}

-(void)loadData {
    
    
    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];

    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    
    NSDate *today = [NSDate dateWithDatePart:[NSDate date] andTimePart:[[NSCalendar currentCalendar] dateFromComponents:comps]];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
            
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (author.name = %@) AND (promo = 1)", today, kGrandCercle];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil && array.count > 0 && error == nil) {
        event = [[[array objectAtIndex:0] retain] autorelease];
    }
    else {
        NSLog(@"error %@", error);
        // Deal with error.
    }
    [request release];

    
    [titleLabel setText: [event title]];
    [dateLabel setText: [NSString stringWithFormat:@"%@, %@", [event day], [event dateText]]];
    [hourLabel setText: [NSString stringWithFormat:@"%@", [event time]]];
    [placeLabel setText: [NSString stringWithFormat:@"%@", [event location]]];
        
    if(IS_WIDESCREEN) {
        [eventImageView setFrame:CGRectMake(45, 35, 230, 340)];
        [bDetail setFrame:CGRectMake(45, 35, 230, 340)];
        [eventImageView setImageWithURL:[NSURL URLWithString:event.poster2xWide] placeholderImage:nil];
        [vBkgd setFrame:CGRectMake(0, 0, 320, 450)];
        [vText setFrame:CGRectMake(45, 376, 230, 56)];
        [vBkgd setImage:[UIImage imageNamed:@"home-568h"]];
    } else {
        [eventImageView setFrame:CGRectMake(66, 28, 188, 274)];
        [bDetail setFrame:CGRectMake(66, 28, 188, 274)];
        if ([UIScreen retinaScreen])
            [eventImageView setImageWithURL:[NSURL URLWithString:event.poster2x] placeholderImage:nil];
        else [eventImageView setImageWithURL:[NSURL URLWithString:event.poster] placeholderImage:nil];
        [vBkgd setFrame:CGRectMake(0, 0, 320, 365)];
        [vText setFrame:CGRectMake(66, 302, 188, 48)];
        [vBkgd setImage:[UIImage imageNamed:@"home"]];
    }
    CGRect frame = vText.frame;
    [titleLabel setFrame:CGRectMake(0, 0, frame.size.width, 18)];
    [dateLabel setFrame:CGRectMake(0, frame.size.height/3, frame.size.width, 16)];
    [hourLabel setFrame:CGRectMake(0, frame.size.height/3*2, 60, 14)];
    [placeLabel setFrame:CGRectMake(60, frame.size.height/3*2, frame.size.width-60, 14)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadData];
}

- (void)viewDidUnload
{
    [vBkgd release];
    vBkgd = nil;
    [self setVBkgd:nil];
    [bDetail release];
    bDetail = nil;
    [self setBDetail:nil];
    [vText release];
    vText = nil;
    [self setVText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)imageButtonAction:(id)sender {
        
    EventsDetailViewController *detailEventController = [[EventsDetailViewController alloc] initWithNibName:@"EventsDetailViewController" bundle:nil];
    detailEventController.event = event;
    [self.superController.navigationController pushViewController:detailEventController animated:YES];
    [detailEventController release];
    detailEventController = nil;
}

- (void)dealloc {

    [vBkgd release];
    [bDetail release];
    [vText release];
    [super dealloc];
}
@end
