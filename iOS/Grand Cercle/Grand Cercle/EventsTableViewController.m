//
//  EventTableViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 30/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EventsTableViewController.h"
#import "Evenements.h"
#import "EvenementsParser.h"
#import "EventDetailViewController.h"


@implementation EventsTableViewController

@synthesize eventCell, eventArray, dico, tView, urlArray, urlArray2, imageCache, imageCache2;
@synthesize superController;

//- (id)initWithStyle:(UITableViewStyle)style {
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }    
    
    eventArray = [[EvenementsParser instance] arrayEvenements];
    
    
    //configure sections
    dico = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [eventArray count]; i++) {
        Evenements *event = [eventArray objectAtIndex:i];
        
        NSMutableArray *eventsOnThisDay = [dico objectForKey:event.eventDate];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            
            [dico setObject:eventsOnThisDay forKey:event.eventDate];
        }
        [eventsOnThisDay addObject:event];
        
    }
    
    // print
//    for (id key in dico) {
//        NSLog(@"key: %@, value: %@", key, [dico objectForKey:key]);
//    }
    
    // Préparation du cache
    
    urlArray = [[NSMutableArray alloc] initWithCapacity:[eventArray count]];
    
    for (int i = 0; i < [eventArray count]; i++) {
        Evenements *e = [eventArray objectAtIndex:i];
        [urlArray addObject:[e imageSmall]];
    }
	
	imageCache = [[TKImageCache alloc] initWithCacheDirectoryName:@"imageSmall"];
	imageCache.notificationName = @"newImageSmallCache";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved:) name:@"newImageSmallCache" object:nil];
    
    urlArray2 = [[NSMutableArray alloc] initWithCapacity:[eventArray count]];
    
    for (int i = 0; i < [eventArray count]; i++) {
        Evenements *e = [eventArray objectAtIndex:i];
        [urlArray2 addObject:[e logo]];
    }
	
	imageCache2 = [[TKImageCache alloc] initWithCacheDirectoryName:@"logoEvent"];
	imageCache2.notificationName = @"newLogoEventCache";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved:) name:@"newLogoEventCache" object:nil];

    return self;

}

- (void) newImageRetrieved:(NSNotification*)sender{
    
	NSDictionary *dict = [sender userInfo];
    NSInteger tag = [[dict objectForKey:@"tag"] intValue];
    
    NSArray *paths = [self.tView indexPathsForVisibleRows];
    
    for(NSIndexPath *path in paths) {
        
        NSInteger index = path.row;

        UITableViewCell *cell = [self.tView cellForRowAtIndexPath:path];
        UIImageView *imageView;
        if ([[(NSNotification *) sender name] isEqualToString:@"newLogoEventCache"]) {
            imageView = (UIImageView *)[cell viewWithTag:6];
        }
        else {
            imageView = (UIImageView *)[cell viewWithTag:1];
        }
    	if(imageView.image == nil && tag == index){
            
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

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [dico count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    NSArray *dates = [dico allKeys];
    id theDate = [dates objectAtIndex:[dates count] - section - 1];
    id eventList = [dico objectForKey:theDate];
    return [eventList count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *keys = [dico allKeys];
    id aKey = [keys objectAtIndex:section];
    id anObject = [dico objectForKey:aKey];
    Evenements *e = [anObject objectAtIndex:0];
    
    NSDate *curentDate = [NSDate date];
    NSDate *eventDate = [e eventDate];
    
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
    else return [e date];
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
    NSArray *keys = [dico allKeys];
    id aKey = [keys objectAtIndex:[keys count] - 1 - indexPath.section];

    id anObject = [dico objectForKey:aKey];
    Evenements *e = (Evenements *)[anObject objectAtIndex:indexPath.row];
    
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:1];
    
    UIImage *img = [imageCache imageForKey:[NSString stringWithFormat:@"%d", indexPath.row] url:[NSURL URLWithString:[urlArray objectAtIndex: indexPath.row]] queueIfNeeded:YES tag: indexPath.row];
    [imageView setImage:img];
    
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:2];
    [label setText: [e title]];
    
    label = (UILabel *)[cell viewWithTag:3];
    [label setText:[e group]];
    
    label = (UILabel *)[cell viewWithTag:4];
    [label setText:[e time]];
    
    label = (UILabel *)[cell viewWithTag:5];
    [label setText:[e place]];
    
    imageView = (UIImageView *)[cell viewWithTag:6];
    
    img = [imageCache2 imageForKey:[NSString stringWithFormat:@"%d", indexPath.row] url:[NSURL URLWithString:[urlArray2 objectAtIndex: indexPath.row]] queueIfNeeded:YES tag: indexPath.row];
    [imageView setImage:img];
    
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
    
    NSLog(@"event selected");
    Evenements *selectedEvent = [eventArray objectAtIndex:indexPath.row];
    EventDetailViewController *detailEventController = [[EventDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
    
    detailEventController.event = selectedEvent;
    [self.superController.navigationController pushViewController:detailEventController animated:YES];

    [detailEventController release];
    detailEventController = nil;
}

@end
