//
//  FirstViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EventsViewController.h"
#import "EvenementsParser.h"
#import "DealsViewController.h"

@interface EventsViewController ()

@end

@implementation EventsViewController
@synthesize eventCell, eventArray, dico;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Events", @"Evenements");
        self.tabBarItem.image = [UIImage imageNamed:@"events"];
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
    for (id key in dico) {
        NSLog(@"key: %@, value: %@", key, [dico objectForKey:key]);
    }
    
    
    return self;
}
	
-(void)viewDidAppear:(BOOL)animated {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setEventCell:nil];
    [eventCell release];
    eventCell = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [dico count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *keys = [dico allKeys];
    id aKey = [keys objectAtIndex:[keys count] - section - 1];
    id anObject = [dico objectForKey:aKey];
    return [anObject count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *keys = [dico allKeys];
    id aKey = [keys objectAtIndex:[keys count] - section - 1];
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
    id aKey = [keys objectAtIndex:[keys count] - 1 - [indexPath section]];
    id anObject = [dico objectForKey:aKey];
    Evenements *e = (Evenements *)[anObject objectAtIndex:[indexPath row]];
    
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:1];
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:(NSString*)[e imageSmall]]];
    UIImage *myimage = [[UIImage alloc] initWithData:imageData];
    [imageView setImage:myimage];
    
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
    
    imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:(NSString*)[e logo]]];
    myimage = [[UIImage alloc] initWithData:imageData];
    [imageView setImage:myimage];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected");
    // Navigation logic may go here. Create and push another view controller.
    
    DealsViewController *detailViewController = [[DealsViewController alloc] initWithNibName:@"DealsViewController" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
}

- (void)dealloc {
    [eventCell release];
    [super dealloc];
}
@end
