//
//  DemoCalendarMonth.m
//  Created by Devin Ross on 10/31/09.
//
/*
 
 tapku.com || https://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "DemoCalendarMonth.h"
#import "EvenementsParser.h"


@implementation DemoCalendarMonth
@synthesize dataArray, dataDictionary;
@synthesize eventCell;

- (void) viewDidLoad{
	[super viewDidLoad];
	[self.monthView selectDate:[NSDate date]];

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
	[self generateRandomDataForStartDate:startDate endDate:lastDate];
	return dataArray;
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	
	// CHANGE THE DATE TO YOUR TIMEZONE
	TKDateInformation info = [date dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDate *myTimeZoneDay = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
	
	NSLog(@"Date Selected: %@",myTimeZoneDay);
	
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
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}
    
- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SmallEventCell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"SmallEventCell" owner:self options:nil];
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
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:(NSString*)[e imageSmall]]];
            UIImage *myimage = [[UIImage alloc] initWithData:imageData];
            [imageView setImage:myimage];
            
            UILabel *label;
            label = (UILabel *)[cell viewWithTag:2];
            [label setText: [e title]];
            
            
            label = (UILabel *)[cell viewWithTag:3];
            [label setText:[e place]];
            
            imageView = (UIImageView *)[cell viewWithTag:4];
            
            imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:(NSString*)[e logo]]];
            myimage = [[UIImage alloc] initWithData:imageData];
            [imageView setImage:myimage];
            
        }
    }
    return cell;
	
}


- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
	// this function sets up dataArray & dataDictionary
	// dataArray: has boolean markers for each day to pass to the calendar view (via the delegate function)
	// dataDictionary: has items that are associated with date keys (for tableview)
	
    NSLog(@"######## enter generate data");
    
    NSMutableArray *theDates = [[EvenementsParser instance] arrayEvenements];
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
