//
//  SettingsDetailViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 4/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "SettingsDetailViewController.h"
#import "FilterParser.h"

#define FILTER_CERCLES 0
#define FILTER_CLUBS 1
#define FILTER_TYPE 2
#define CERCLES 0
#define CLUBS 1

@interface SettingsDetailViewController ()

@end

@implementation SettingsDetailViewController

@synthesize cerclesArray, clubsArray, typesArray;
@synthesize clubsChoice, cerclesChoice, typesChoice;
@synthesize filter;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (filter == FILTER_CERCLES) {
        cerclesArray = [[FilterParser instance] arrayCercles];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        NSMutableDictionary *cerclesDico = [defaults objectForKey:@"filtreCercles"];
        
        cerclesChoice = [[NSMutableArray alloc] initWithCapacity:[cerclesArray count]];
        for (NSString *cercle in cerclesArray) {
            [cerclesChoice addObject:[cerclesDico objectForKey:cercle]];
        }
        
    } else if (filter == FILTER_CLUBS) {
        clubsArray = [[FilterParser instance] arrayClubs];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        NSMutableDictionary *clubsDico  = [defaults objectForKey:@"filtreClubs"];
        clubsChoice = [[NSMutableArray alloc] initWithCapacity:[clubsArray count]];
        for (NSString *club in clubsArray) {
            [clubsChoice addObject:[clubsDico objectForKey:club]];
            
        }
        
    }
    else if (filter == FILTER_TYPE) {
        typesArray = [[FilterParser instance] arrayTypes];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        NSMutableDictionary *typesDico = [defaults objectForKey:@"filtreTypes"];
        
        for (NSString * n in typesArray) {
        
        }
        
        typesChoice = [[NSMutableArray alloc] initWithCapacity:[typesArray count]];
        for (NSString *type in typesArray) {
            [typesChoice addObject:[typesDico objectForKey:type]];
        }
        
    }

    self.title = NSLocalizedString(@"Settings", @"Settings");


    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (filter == FILTER_CERCLES || filter == FILTER_CLUBS || filter == FILTER_TYPE) {
        return 1;
    } else return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (filter == FILTER_CERCLES) {
        return [cerclesArray count];
    } else if (filter == FILTER_CLUBS) {
        return [clubsArray count];
    } else if (filter == FILTER_TYPE) {
        return [typesArray count];
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (filter == FILTER_CERCLES) {
        return @"Cercles";
    } else if (filter == FILTER_CLUBS) {
            return @"Clubs & Associations";
    } else if (filter == FILTER_TYPE) {
        return @"Types d'événements";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    BOOL checked;
    if (filter == FILTER_CERCLES) {
            [cell.textLabel setText:(NSString *)[cerclesArray objectAtIndex:indexPath.row]];
             checked = [[cerclesChoice objectAtIndex:indexPath.row] boolValue];
    } else if (filter == FILTER_CLUBS) {
            [cell.textLabel setText:[clubsArray objectAtIndex:indexPath.row]];
            checked = [[clubsChoice objectAtIndex:indexPath.row] boolValue];
    } else if (filter == FILTER_TYPE) {
        [cell.textLabel setText:(NSString *)[typesArray objectAtIndex:indexPath.row]];
        checked = [[typesChoice objectAtIndex:indexPath.row] boolValue];
    }
    
    cell.accessoryType = (checked) ? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
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
    if (filter == FILTER_CERCLES) {
            BOOL value = [[cerclesChoice objectAtIndex:indexPath.row] boolValue];
            value = 1 - value;
            [cerclesChoice replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:value]];
    } else if (filter == FILTER_CLUBS) {
            BOOL value = [[clubsChoice objectAtIndex:indexPath.row] boolValue];
            value = 1 - value;
            [clubsChoice replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:value]];
    } else if (filter == FILTER_TYPE) {
        BOOL value = [[typesChoice objectAtIndex:indexPath.row] boolValue];
        value = 1 - value;
        [typesChoice replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:value]];
    }
    
    [tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    NSMutableDictionary *cerclesDico = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"filtreCercles"]];
    NSMutableDictionary *clubsDico = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"filtreClubs"]];
    NSMutableDictionary *typesDico = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"filtreTypes"]];
    
    for (int i = 0; i < [cerclesArray count]; i++) {
        [cerclesDico setObject:[cerclesChoice objectAtIndex:i] forKey:[cerclesArray objectAtIndex:i]];
    }
    for (int i = 0; i < [clubsArray count]; i++) {
        [clubsDico setObject:[clubsChoice objectAtIndex:i] forKey:[clubsArray objectAtIndex:i]];
    }
    for (int i = 0; i < [typesArray count]; i++) {
        [typesDico setObject:[typesChoice objectAtIndex:i] forKey:[typesArray objectAtIndex:i]];
    }
    [defaults setObject:cerclesDico forKey:@"filtreCercles"];
    [defaults setObject:clubsDico forKey:@"filtreClubs"];
    [defaults setObject:typesDico forKey:@"filtreTypes"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self viewDidUnload];
}

@end
