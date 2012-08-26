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
#import "EventDetailViewController.h"

#import "AppDelegate.h"
#import "Association.h"

@implementation EventsTableViewController

@synthesize eventCell, eventArray, eventDico, tView, imageCache;
@synthesize superController;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (managedObjectContext == nil) { 
            managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        }
        
        [self loadData];
        
        // Préparation du cache
        
        self.imageCache = [[[TKImageCache alloc] initWithCacheDirectoryName:@"images/events/thumb"] autorelease];
        self.imageCache.notificationName = @"newEventImageSmall";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newTableImageRetrieved:) name:@"newEventImageSmall" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newAssosImageRetrieved:) name:@"newAssosImage" object:nil];
    }   

    return self;
}

- (void) newTableImageRetrieved:(NSNotification*)sender{
    
	NSDictionary *dict = [sender userInfo];
    NSInteger tag = [[dict objectForKey:@"tag"] intValue];
    
    NSArray *paths = [self.tView indexPathsForVisibleRows];
    
    for(NSIndexPath *path in paths) {
        
        NSInteger index = path.section * 1000 + path.row;

        UITableViewCell *cell = [self.tView cellForRowAtIndexPath:path];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    	if(imageView.image == nil && tag == index){
            
            imageView.image = [dict objectForKey:@"image"];
            [cell setNeedsLayout];
        }
    }
}


- (void) newAssosImageRetrieved:(NSNotification*)sender {
    
    // Définition des structures
	NSDictionary *dict = [sender userInfo];
    NSInteger tag = [[dict objectForKey:@"tag"] intValue];
    
    NSArray *paths = [self.tView indexPathsForVisibleRows];
    // Pour chaque row de la table view
    for(NSIndexPath *path in paths) {
        
        // On charche l'image dans le cache
    	NSInteger index = path.row;
        UITableViewCell *cell = [self.tView cellForRowAtIndexPath:path];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:6];

        
        // Si il n'y a pas d'image on l'affiche
    	if(imageView.image == nil && tag == [[[[eventArray objectAtIndex:index] author] idAssos] intValue] ){
            imageView.image = [dict objectForKey:@"image"];
            [cell setNeedsLayout];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:) 
                                                 name:@"ReloadData"
                                               object:nil];
}


- (void) receiveTestNotification:(NSNotification *) notification
{    
    if ([[notification name] isEqualToString:@"ReloadData"]){
        [self loadData];
    }
}

-(void)loadData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cerclesDico = [defaults objectForKey:@"filtreCercles"];
    
    eventArray = [[NSMutableArray alloc] init];
    
    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
//    [comps setDay:6];
//    [comps setMonth:9];
//    [comps setYear:2012];
    
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    
//    NSDate *today = [[NSCalendar currentCalendar] dateFromComponents:comps];  
    
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
    self.eventDico = [[[NSMutableDictionary alloc] init] autorelease];
    
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
    
- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [imageCache release];
    imageCache = nil;
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
    return 72;
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    Event *e = (Event *)[eventList objectAtIndex:indexPath.row];
    
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:1];
    
    if (![e.thumbnail isEqualToString:@""]) {
        // test si c'est dans le cache
        NSString *imageKey = [NSString stringWithFormat:@"%x", [e.thumbnail hash]];
        
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *imagePath = [[documentsDirectory stringByAppendingPathComponent:@"images/events/thumb"] stringByAppendingPathComponent:imageKey];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
        
        if (!fileExists) {
            // download img async
            UIImage *img = [imageCache imageForKey:imageKey url:[NSURL URLWithString:e.thumbnail] queueIfNeeded:YES tag: 1000 * indexPath.section + indexPath.row];
            [imageView setImage:img];
        }
        else {
            [imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
        }
    } else 
        [imageView setImage:nil];

    
    
    
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:2];
    [label setText: [e title]];
    
    label = (UILabel *)[cell viewWithTag:3];
    [label setText:[[e author] name] ];
      
    imageView = (UIImageView *)[cell viewWithTag:6];
    
    NSString *imageKey = [NSString stringWithFormat:@"%x", [e.author.imagePath hash]];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagePath = [[documentsDirectory stringByAppendingPathComponent:@"images/assos"] stringByAppendingPathComponent:imageKey];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
    
    
    if (!fileExists) {
        [imageView setImage:nil];
    }
    else {
        [imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
    }

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *dates = [[eventDico allKeys] sortedArrayUsingSelector:@selector(compare:)];
    id theDate = [dates objectAtIndex:indexPath.section];
    NSArray *listeEvent = [eventDico objectForKey:theDate];
    Event *selectedEvent = [listeEvent objectAtIndex:indexPath.row];
    EventDetailViewController *detailEventController = [[EventDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    detailEventController.event = selectedEvent;
    [self.superController.navigationController pushViewController:detailEventController animated:YES];
    [detailEventController release];
}

@end
