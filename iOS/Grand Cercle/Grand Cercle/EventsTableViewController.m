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

@synthesize eventCell, eventArray, eventDico, tView, imageCache, imageCache2;
@synthesize superController;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }    
    
    eventArray = [[EvenementsParser instance] arrayEvents];
    
    //configure sections
    eventDico = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [eventArray count]; i++) {
        Evenements *event = [eventArray objectAtIndex:i];
        
        NSMutableArray *eventsOnThisDay = [eventDico objectForKey:event.eventDate];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            
            [eventDico setObject:eventsOnThisDay forKey:event.eventDate];
        }
        [eventsOnThisDay addObject:event];
        
    }
    
    // print
//    for (id key in eventDico) {
//        NSLog(@"key: %@, value: %@", key, [eventDico objectForKey:key]);
//    }
    
    // Préparation du cache
	
	imageCache = [[TKImageCache alloc] initWithCacheDirectoryName:@"images"];
	imageCache.notificationName = @"newImageSmallCache";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newTableImageRetrieved:) name:@"newImageSmallCache" object:nil];
	
	imageCache2 = [[TKImageCache alloc] initWithCacheDirectoryName:@"images"];
	imageCache2.notificationName = @"newLogoCache";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newTableImageRetrieved:) name:@"newLogoCache" object:nil];

    return self;

}

- (void) newTableImageRetrieved:(NSNotification*)sender{
    
	NSDictionary *dict = [sender userInfo];
    NSInteger tag = [[dict objectForKey:@"tag"] intValue];
    
    NSArray *paths = [self.tView indexPathsForVisibleRows];
    
    for(NSIndexPath *path in paths) {
        
        NSInteger index = path.section * 1000 + path.row;

        UITableViewCell *cell = [self.tView cellForRowAtIndexPath:path];
        UIImageView *imageView;
        if ([[(NSNotification *) sender name] isEqualToString:@"newLogoCache"]) {
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
    [imageCache release];
    imageCache = nil;
    [imageCache2 release];
    imageCache2 = nil;
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

    NSArray *dates = [[eventDico allKeys] sortedArrayUsingSelector:@selector(compare:)];
    id theDate = [dates objectAtIndex:section];
    id eventList = [eventDico objectForKey:theDate];
    return [eventList count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *dates = [[eventDico allKeys] sortedArrayUsingSelector:@selector(compare:)];
    id theDate = [dates objectAtIndex:section];
    id eventList = [eventDico objectForKey:theDate];
    Evenements *e = [eventList objectAtIndex:0];
    
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
    NSArray *dates = [[eventDico allKeys] sortedArrayUsingSelector:@selector(compare:)];
    id theDate = [dates objectAtIndex:indexPath.section];

    id eventList = [eventDico objectForKey:theDate];
    Evenements *e = (Evenements *)[eventList objectAtIndex:indexPath.row];
    
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:1];
    
    UIImage *img;
    img = [imageCache imageForKey:[NSString stringWithFormat:@"%d", [e.imageSmall hash]] url:[NSURL URLWithString:e.imageSmall] queueIfNeeded:YES tag: indexPath.section * 1000 + indexPath.row];
    [imageView setImage:img];
    
    
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:2];
    [label setText: [e title]];
    
    label = (UILabel *)[cell viewWithTag:3];
    [label setText:[e group]];
    
    label = (UILabel *)[cell viewWithTag:4];
    [label setText:[[[e time] stringByAppendingString: @" - "] stringByAppendingString : [e place]]];
    
    imageView = (UIImageView *)[cell viewWithTag:6];
    
    img = [imageCache2 imageForKey:[NSString stringWithFormat:@"%d", [e.logo hash]] url:[NSURL URLWithString: e.logo] queueIfNeeded:YES tag: indexPath.section * 1000 + indexPath.row];

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
    
    NSArray *dates = [[eventDico allKeys] sortedArrayUsingSelector:@selector(compare:)];
    id theDate = [dates objectAtIndex:indexPath.section];
    NSArray *listeEvent = [eventDico objectForKey:theDate];
    Evenements *selectedEvent = [listeEvent objectAtIndex:indexPath.row];
    EventDetailViewController *detailEventController = [[EventDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    detailEventController.event = selectedEvent;
    [self.superController.navigationController pushViewController:detailEventController animated:YES];

}

@end
