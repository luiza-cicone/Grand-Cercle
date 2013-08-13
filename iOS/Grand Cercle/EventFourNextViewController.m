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
#import "EventDetailViewController.h"
#import "AppDelegate.h"

@implementation EventFourNextViewController
@synthesize superController;
@synthesize event, imageCache;
@synthesize titleLabel, dateLabel, placeLabel, eventImageView;

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
    
    NSMutableArray *authors = [[NSMutableArray alloc] initWithCapacity:2];
    
    [authors addObject:@"Grand Cercle"];
    [authors addObject:@"Elus étudiants"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (author.name in %@)", today, authors];
    
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
    [placeLabel setText: [NSString stringWithFormat:@"à %@, %@", [event time], [event location]]];
        
    if (![event.image isEqualToString:@""]) {
        // test si c'est dans le cache
        
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:event.image]]];

        [eventImageView setImage:img];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)imageButtonAction:(id)sender {
        
    EventDetailViewController *detailEventController = [[EventDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailEventController.event = event;
    [self.superController.navigationController pushViewController:detailEventController animated:YES];
    [detailEventController release];
    detailEventController = nil;
}

- (void)dealloc {

    [super dealloc];
}
@end
