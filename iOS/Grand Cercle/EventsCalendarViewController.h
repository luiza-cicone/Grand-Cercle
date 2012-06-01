//
//  EventsCalendarViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 30/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <TapkuLibrary/TapkuLibrary.h>
#import <UIKit/UIKit.h>


@interface EventsCalendarViewController : TKCalendarMonthTableViewController {
	NSMutableArray *dataArray; 
	NSMutableDictionary *dataDictionary;
    
    IBOutlet UITableViewCell *eventCell;
}

@property (retain,nonatomic) NSMutableArray *dataArray;
@property (retain,nonatomic) NSMutableDictionary *dataDictionary;
@property (retain,nonatomic) IBOutlet UITableViewCell *eventCell;


- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end;

@end
