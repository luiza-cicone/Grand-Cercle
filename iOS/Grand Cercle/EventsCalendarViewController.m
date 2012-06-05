//
//  EventsCalendarViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 30/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EventsCalendarViewController.h"
#import "EvenementsParser.h"
#import "EventDetailViewController.h"


@implementation EventsCalendarViewController
@synthesize dataArray, dataDictionary;
@synthesize eventCell;
@synthesize imageCache, imageCache2;
@synthesize superController;

- (void) viewDidLoad{
	[super viewDidLoad];
    
	[self.monthView selectDate:[NSDate date]];
    
    // Préparation du cache
	
	imageCache = [[TKImageCache alloc] initWithCacheDirectoryName:@"images"];
	imageCache.notificationName = @"newImageSmallCacheCalendar";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newCalendarImageRetrieved:) name:@"newImageSmallCacheCalendar" object:nil];
	
	imageCache2 = [[TKImageCache alloc] initWithCacheDirectoryName:@"images"];
	imageCache2.notificationName = @"newLogoCacheCalendar";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newCalendarImageRetrieved:) name:@"newLogoCacheCalendar" object:nil];
    
}

- (void) newCalendarImageRetrieved:(NSNotification*)sender{
	NSDictionary *dict = [sender userInfo];
    NSInteger tag = [[dict objectForKey:@"tag"] intValue];
    
    NSArray *paths = [self.tableView indexPathsForVisibleRows];
    for(NSIndexPath *path in paths) {
        NSInteger index = path.section * 1000 + path.row;
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];

        UIImageView *imageView;
        if ([[(NSNotification *) sender name] isEqualToString:@"newLogoCacheCalendar"]) {
            imageView = (UIImageView *)[cell viewWithTag:4];
        }
        else if ([[(NSNotification *) sender name] isEqualToString:@"newImageSmallCacheCalendar"]) {
            imageView = (UIImageView *)[cell viewWithTag:1];
        }
        else return;
    	if(imageView.image == nil && tag == index){
            
            imageView.image = [dict objectForKey:@"image"];
            [cell setNeedsLayout];
        }
    }
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
    //[dateFormatter setDateFormat:@"dd.MM.yy"]; 
    //NSDate *d = [dateFormatter dateFromString:@"02.05.11"]; 
    //[dateFormatter release];
    //[self.monthView selectDate:d];
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	[self generateDataForStartDate:startDate endDate:lastDate];
	return dataArray;
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	
	// CHANGE THE DATE TO YOUR TIMEZONE
	TKDateInformation info = [date dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600]];
	NSDate *myTimeZoneDay = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
	
	NSLog(@"Date Selected: %@", myTimeZoneDay);
	
	[self.tableView reloadData];
}
- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated{
	[super calendarMonthView:mv monthDidChange:d animated:animated];
	[self.tableView reloadData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
	
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
    NSArray *ar = [dataDictionary allKeys];
    for (NSDate * date in ar) {
        if ([date isEqualToDate:[self.monthView dateSelected]] ) {
            return [[dataDictionary objectForKey:[self.monthView dateSelected]] count];
        }
    }    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}
    
- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EventSmallCell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"EventSmallCell" owner:self options:nil];
        cell = eventCell;
        self.eventCell = nil;
    }
    
    NSArray *ar = [dataDictionary allKeys];
    [(UIImageView *)[cell viewWithTag:1] setImage:nil];
    [(UILabel *)[cell viewWithTag:2] setText:nil];
    [(UILabel *)[cell viewWithTag:3] setText:nil];
    [(UIImageView *)[cell viewWithTag:4] setImage:nil];
    
    for (NSDate * date in ar) {
        if ([date isEqualToDate:[self.monthView dateSelected]] ) {
            Evenements *e  = [[dataDictionary objectForKey:[self.monthView dateSelected]] objectAtIndex:indexPath.row];
            
            UIImageView *imageView;
            imageView = (UIImageView *)[cell viewWithTag:1];
            
            UIImage *img;
            if (![e.imageSmall isEqualToString:@""]) {
                img = [imageCache imageForKey:[NSString stringWithFormat:@"%d", [e.imageSmall hash]] url:[NSURL URLWithString:e.imageSmall] queueIfNeeded:YES tag: indexPath.section * 1000 + indexPath.row];
                [imageView setImage:img];
            }
            else {
                [imageView setImage:nil];
            }
                        
            
            UILabel *label;
            label = (UILabel *)[cell viewWithTag:2];
            [label setText: [e title]];
            
            
            label = (UILabel *)[cell viewWithTag:3];
            [label setText:[[[e time] stringByAppendingString:@" - "] stringByAppendingString : [e place]]];
            
            imageView = (UIImageView *)[cell viewWithTag:4];
            
            img = [imageCache2 imageForKey:[NSString stringWithFormat:@"%d", [e.logo hash]] url:[NSURL URLWithString: e.logo] queueIfNeeded:YES tag: indexPath.section * 1000 + indexPath.row];
            [imageView setImage:img];

            
        }
    }
    return cell;
	
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Evenements *selectedEvent  = [[dataDictionary objectForKey:[self.monthView dateSelected]] objectAtIndex:indexPath.row];
    EventDetailViewController *detailEventController = [[EventDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    
    detailEventController.event = selectedEvent;
    [self.superController.navigationController pushViewController:detailEventController animated:YES];
    
    [detailEventController release];
    detailEventController = nil;
}


- (void) generateDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
	// this function sets up dataArray & dataDictionary
	// dataArray: has boolean markers for each day to pass to the calendar view (via the delegate function)
	// dataDictionary: has items that are associated with date keys (for tableview)
	    
    NSArray *theDates = [[EvenementsParser instance] arrayEvents];     
    theDates = [theDates arrayByAddingObjectsFromArray:[[EvenementsParser instance] arrayOldEvents]];

    
//	self.dataArray = [NSMutableArray array];
	self.dataDictionary = [NSMutableDictionary dictionary];
    
    //configure sections
    self.dataDictionary = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [theDates count]; i++) {
        Evenements *event = [theDates objectAtIndex:i];
        
        NSMutableArray *eventsOnThisDay = [self.dataDictionary objectForKey:event.eventDate];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            
            [self.dataDictionary setObject:eventsOnThisDay forKey:event.eventDate];
        }
        [eventsOnThisDay addObject:event];
        
    }
}


@end
