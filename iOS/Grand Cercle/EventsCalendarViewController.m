//
//  EventsCalendarViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 30/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EventsCalendarViewController.h"
#import "EventsParser.h"
#import "EventDetailViewController.h"
#import "AppDelegate.h"
#import "Association.h"

@implementation EventsCalendarViewController
@synthesize dataArray, dataDictionary;
@synthesize eventCell;
@synthesize imageCache, imageCache2;
@synthesize superController;

- (void) viewDidLoad{
	[super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newAssosImageRetrieved:) name:@"newAssosImage" object:nil];

	[self.monthView selectDate:[NSDate date]];
    
    // Préparation du cache
	
	imageCache = [[TKImageCache alloc] initWithCacheDirectoryName:@"images/events/thumb"];
	imageCache.notificationName = @"newCalendarImage";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newCalendarImageRetrieved:) name:@"newCalendarImage" object:nil];
    
}

- (void) newAssosImageRetrieved:(NSNotification*)sender {
    
    // Définition des structures
	NSDictionary *dict = [sender userInfo];
    NSInteger tag = [[dict objectForKey:@"tag"] intValue];
    
    NSArray *paths = [self.tableView indexPathsForVisibleRows];
    // Pour chaque row de la table view
    for(NSIndexPath *path in paths) {
        
        // On charche l'image dans le cache
    	NSInteger index = path.row;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:6];
        
        Event *event = [[dataDictionary objectForKey:[self.monthView dateSelected]] objectAtIndex:index];
        // Si il n'y a pas d'image on l'affiche
    	if(imageView.image == nil && tag == [[[event author] idAssos] intValue]){
            imageView.image = [dict objectForKey:@"image"];
            [cell setNeedsLayout];
        }
    }
}

- (void) newCalendarImageRetrieved:(NSNotification*)sender{
	NSDictionary *dict = [sender userInfo];
    NSInteger tag = [[dict objectForKey:@"tag"] intValue];
    
    NSArray *paths = [self.tableView indexPathsForVisibleRows];
    for(NSIndexPath *path in paths) {
        NSInteger index = path.section * 1000 + path.row;
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];

        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        
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
//	TKDateInformation info = [date dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600]];
//	NSDate *myTimeZoneDay = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
	
//	NSLog(@"Date Selected: %@", myTimeZoneDay);
	
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
    return 40;
}

-(void)reloadData {
    [self.monthView reload];
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
            Event *e  = [[dataDictionary objectForKey:[self.monthView dateSelected]] objectAtIndex:indexPath.row];
            
            UILabel *label;
            label = (UILabel *)[cell viewWithTag:2];
            [label setText: [e title]];
            
            label = (UILabel *)[cell viewWithTag:3];
            [label setText:[[[e time] stringByAppendingString:@" - "] stringByAppendingString : [e location]]];
            
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
                    UIImage *img = [imageCache imageForKey:imageKey url:[NSURL URLWithString:e.thumbnail] queueIfNeeded:YES tag: indexPath.row];
                    [imageView setImage:img];
                }
                else {
                    [imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
                }
            } else 
                [imageView setImage:nil];


            imageView = (UIImageView *)[cell viewWithTag:4];
            
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
        }
    }
    return cell;
	
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Event *selectedEvent  = [[dataDictionary objectForKey:[self.monthView dateSelected]] objectAtIndex:indexPath.row];
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
	    
    
    if (managedObjectContext == nil) { 
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    
    
    NSMutableArray *theDates = [[NSMutableArray alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cerclesDico = [defaults objectForKey:@"filtreCercles"]; 
    
    for (NSString *aCercle in cerclesDico) {
        NSMutableDictionary *typesDico = [cerclesDico objectForKey:aCercle];
        
        NSMutableArray *typesForCercle = [[NSMutableArray alloc] init];
        
        for (NSString *aType in typesDico) {
            if ([[typesDico objectForKey:aType] boolValue]) {
                [typesForCercle addObject:aType];
            }
        }
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (author.name = %@) AND (type in %@)", start, end, aCercle, typesForCercle];
        
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:entityDescription];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        
        NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
        if (array != nil && error == nil) {
            [theDates addObjectsFromArray:array];
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (author.name in %@)", start, end, authors];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil && error == nil) {
        [theDates addObjectsFromArray:array];
    }
    else {
        NSLog(@"error %@", error);
        // Deal with error.
    }
    [authors release];
	self.dataArray = [NSMutableArray array];
	self.dataDictionary = [NSMutableDictionary dictionary];
    
    //configure sections
    self.dataDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSDate *d = start;
	while(YES){
        [self.dataArray addObject:[NSNumber numberWithBool:NO]];
		
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:end]==NSOrderedDescending) break;
	}
    
    
    for (int i = 0; i < [theDates count]; i++) {
        Event *event = [theDates objectAtIndex:i];
        
        NSMutableArray *eventsOnThisDay = [self.dataDictionary objectForKey:event.date];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            
            [self.dataDictionary setObject:eventsOnThisDay forKey:event.date];
        }
        [eventsOnThisDay addObject:event];

        
        int numDays, numDays2;
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSUInteger unitFlags = NSDayCalendarUnit;
        NSDateComponents *components = [gregorian components:unitFlags fromDate:start toDate:event.date options:0];
        NSDateComponents *components2 = [gregorian components:unitFlags fromDate:event.date toDate:end options:0];

        numDays = [components day];
        numDays2 = [components2 day];

        if (numDays2 > 0 && numDays > 0 && [[self.dataArray objectAtIndex:numDays] boolValue] == 0) {
            [self.dataArray removeObjectAtIndex:numDays];
            [self.dataArray insertObject:[NSNumber numberWithBool:YES] atIndex:numDays];
        }
        [gregorian release];
    }
    [theDates release];
}
-(void)dealloc {
    [super dealloc];
    [dataDictionary release];
    dataDictionary = nil;
}


@end
