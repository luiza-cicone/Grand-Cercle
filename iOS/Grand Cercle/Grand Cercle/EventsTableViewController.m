//
//  EventTableViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 30/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EventsTableViewController.h"
#import "Event.h"
#import "EventsParser.h"
#import "EventsDetailViewController.h"

#import "AppDelegate.h"
#import "Association.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "UIScreen.h"
#import "TapkuLibrary/NSDate+TKCategory.h"

@implementation EventsTableViewController

@synthesize eventCell, eventArray, eventDico, tView;
@synthesize superController;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (managedObjectContext == nil) { 
            managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        }
        
        [self loadData];
    }   

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}
    
- (void)viewDidUnload
{
    [super viewDidUnload];

    [eventDico release];
    eventDico = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [eventDico count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    NSArray *dates  = [[eventDico allKeys] sortedArrayUsingSelector:@selector(compare:)];
    id theDate = [dates objectAtIndex:section];
    id eventList = [eventDico objectForKey:theDate];
    return [eventList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *dates = [[eventDico allKeys] sortedArrayUsingSelector:@selector(compare:)];
    id theDate = [dates objectAtIndex:section];
    id eventList = [eventDico objectForKey:theDate];
    Event *e = [eventList objectAtIndex:0];
    
    NSDate *eventDate = [e date];
    NSDate *curentDate = [NSDate date];

    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* compoNents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:curentDate]; // Get necessary date components
    
    int curMonth = [compoNents month]; //gives you month
    int curDay = [compoNents day]; //gives you day
    int curYear = [compoNents year]; // gives you year
    
    compoNents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:eventDate]; // Get necessary date components

    if (curDay == [compoNents day] && curMonth == [compoNents month] && curYear == [compoNents year]) {
        return @"Aujourd'hui";
    }
    else if (curDay == [compoNents day] - 1 && curMonth == [compoNents month] && curYear == [compoNents year]) {
        return @"Demain";
    }
    else return [NSString stringWithFormat:@"%@, %@", [e day], [e dateText]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"EventCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil];
        cell = eventCell;
        self.eventCell = nil;
    }
    
    NSArray *dates = [[eventDico allKeys] sortedArrayUsingSelector:@selector(compare:)];
    id theDate = [dates objectAtIndex:indexPath.section];

    id eventList = [eventDico objectForKey:theDate];
    Event *event = (Event *)[eventList objectAtIndex:indexPath.row];
    
    // Affichage de l'image de la news
    UIImageView *imageView = nil;
    imageView = (UIImageView *)[cell viewWithTag:1];
    
    NSString *image;
    if (![event.thumbnail2x isEqualToString:@""])
        if([UIScreen retinaScreen])
            image = event.thumbnail2x;
        else image = event.thumbnail;
    else image = event.author.imagePath;
    
    [imageView setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"placeholder80.png"]];
    
    // Title
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    [label setText: [event title]];
    
    // Association
    label = (UILabel *)[cell viewWithTag:3];
    [label setText:[[event author] name]];
    
    CGRect frame = label.frame;
    CGSize s = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(225, MAXFLOAT) lineBreakMode:label.lineBreakMode];
    frame.size.width = s.width + 4;
    label.frame = frame;
    
    UIView *view = (UIView *)[cell viewWithTag:4];
    [view setBackgroundColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate]colorWithHexString:event.author.color]];
    view.frame = frame;

    label = (UILabel *)[cell viewWithTag:5];
    [label setText: [event time]];
    
    label = (UILabel *)[cell viewWithTag:6];
    [label setText:[event location]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *dates = [[eventDico allKeys] sortedArrayUsingSelector:@selector(compare:)];
    id theDate = [dates objectAtIndex:indexPath.section];
    NSArray *listeEvent = [eventDico objectForKey:theDate];
    Event *selectedEvent = [listeEvent objectAtIndex:indexPath.row];
    EventsDetailViewController *detailEventController = [[EventsDetailViewController alloc] initWithNibName:@"EventsDetailViewController" bundle:nil];
    
    detailEventController.event = selectedEvent;
    [self.superController.navigationController pushViewController:detailEventController animated:YES];
    [detailEventController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Load Data

-(void)loadData
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cerclesDico = [defaults objectForKey:@"filtreCercles"];
    
    eventArray = [[NSMutableArray alloc] init];
    
    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    
    NSDate *today = [NSDate dateWithDatePart:[NSDate date] andTimePart:[[NSCalendar currentCalendar] dateFromComponents:comps]];
    
    for (NSString *aCercle in cerclesDico) {
        NSMutableDictionary *typesDico = [cerclesDico objectForKey:aCercle];
        
        NSMutableArray *typesForCercle = [[NSMutableArray alloc] init];
        
        for (NSString *aType in typesDico) {
            if ([[typesDico objectForKey:aType] boolValue]) {
                [typesForCercle addObject:aType];
            }
        }
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (author.name = %@) AND (type in %@)", today, aCercle, typesForCercle];
        
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:entityDescription];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        
        NSError *error = nil;
        
        NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
        if (array != nil && error == nil) {
            [eventArray addObjectsFromArray:array];
        }
        else {
            NSLog(@"error %@", error);
            // Deal with error.
        }
        [typesForCercle release];
        
    }
    NSMutableArray *authors = [[NSMutableArray alloc] initWithCapacity:7];
    
    NSDictionary *clubsArr = [defaults objectForKey:@"filtreClubs"];
    for (NSString *aClub in clubsArr) {

        if ([[clubsArr objectForKey:aClub] boolValue])
            [authors addObject:aClub];
    }
    // ajout du Grand Cercle et elus automatiquemet
    [authors addObject:@"Grand Cercle"];
    [authors addObject:@"Elus étudiants"];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (author.name in %@)", today, authors];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil && error == nil) {
        [eventArray addObjectsFromArray:array];
    }
    else {
        NSLog(@"error %@", error);
        // Deal with error.
    }
    [authors release];
    
    //configure sections
    self.eventDico = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [self.eventArray count]; i++) {
        Event *event = [self.eventArray objectAtIndex:i];
        
        NSMutableArray *eventsOnThisDay = [self.eventDico objectForKey:event.date];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            
            [self.eventDico setObject:eventsOnThisDay forKey:event.date];
        }
        [eventsOnThisDay addObject:event];
        
    }
    
    [self.tView reloadData];
}

#pragma mark - Notifications

//- (void) handleNotification:(NSNotification *) notification
//{
//    if ([[notification name] isEqualToString:@"updateFinished"]){
//        [self loadData];
//    }
//}

@end
