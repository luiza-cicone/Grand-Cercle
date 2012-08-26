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
@synthesize arrayEvents, imageCache;

int borneSup = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (managedObjectContext == nil) { 
            managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        }

        
        self.imageCache = [[[TKImageCache alloc] initWithCacheDirectoryName:@"images/events/normal"] autorelease];
        self.imageCache.notificationName = @"newEventImage";
    
        [self loadData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved:) name:@"newEventImage" object:nil];
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTestNotification:) 
                                                     name:@"ReloadData"
                                                   object:nil];
    }
    
    return self;
}

- (void) newImageRetrieved:(NSNotification*)sender{
    
	NSDictionary *dict = [sender userInfo];
    NSInteger tag = [[dict objectForKey:@"tag"] intValue];
    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:tag];        

    if(imageView.image == nil){
        imageView.image = [dict objectForKey:@"image"];
    }
}

-(void)loadData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cerclesDico = [defaults objectForKey:@"filtreCercles"];
    
    arrayEvents = [[NSMutableArray alloc] init];
    
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
        
        NSError *error = nil;
        
        NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
        if (array != nil && error == nil) {
            [arrayEvents addObjectsFromArray:array];
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
    
    NSError *error = nil;
    
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil && error == nil) {
        [arrayEvents addObjectsFromArray:array];
    }
    else {
        NSLog(@"error %@", error);
        // Deal with error.
    }
    [authors release];
    NSArray *sortedArray;
    sortedArray = [arrayEvents sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Event*)a date];
        NSDate *second = [(Event*)b date];
        return [first compare:second];
    }];
    arrayEvents = [NSMutableArray arrayWithArray:sortedArray];
    [arrayEvents retain];
    borneSup = MIN(4, [arrayEvents count]);
    
    for (int i = 0; i < borneSup; i++) {
        
        UILabel *label = (UILabel *)[self.view viewWithTag:i+5];
        [label setText: [[arrayEvents objectAtIndex:i] dateText]];
        
        UIButton *button = (UIButton *)[self.view viewWithTag:i+9];
        [button setHidden:NO];
        
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:i+1];        
        
        Event *e = [arrayEvents objectAtIndex:i];
        NSLog(@"%@", e);
        if (![e.image isEqualToString:@""]) {
            // test si c'est dans le cache
            NSString *imageKey = [NSString stringWithFormat:@"%x", [e.image hash]];
            
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *imagePath = [[documentsDirectory stringByAppendingPathComponent:@"images/events/normal"] stringByAppendingPathComponent:imageKey];
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
            
            if (!fileExists) {
                // download img async
                UIImage *img = [imageCache imageForKey:imageKey url:[NSURL URLWithString:e.image] queueIfNeeded:YES tag:i+1];
                [imageView setImage:img];
            }
            else {
                [imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
            }
        } else 
            [imageView setImage:nil];
        
        
    }
    for (int i = borneSup; i < 4; i++) {
        UILabel *label = (UILabel *)[self.view viewWithTag:i+5];
        [label setText: @""];
        
    }
}

- (void) receiveTestNotification:(NSNotification *) notification
{    
    if ([[notification name] isEqualToString:@"ReloadData"]){
        [self loadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    Event *selectedEvent = nil;
    if ((UIButton*)sender == (UIButton *)[self.view viewWithTag:9] && borneSup > 0) {
        selectedEvent = [arrayEvents objectAtIndex:0];
    } else if ((UIButton*)sender == (UIButton *)[self.view viewWithTag:10] && borneSup > 1) {
        selectedEvent = [arrayEvents objectAtIndex:1];
    } else if ((UIButton*)sender == (UIButton *)[self.view viewWithTag:11] && borneSup > 2) {
        selectedEvent = [arrayEvents objectAtIndex:2];
    } else if ((UIButton*)sender == (UIButton *)[self.view viewWithTag:12] && borneSup > 3) {
        selectedEvent = [arrayEvents objectAtIndex:3];
    }
    
    EventDetailViewController *detailEventController = [[EventDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailEventController.event = selectedEvent;
    [self.superController.navigationController pushViewController:detailEventController animated:YES];
    [detailEventController release];
    detailEventController = nil;
}

- (void)dealloc {

    [super dealloc];
}
@end
