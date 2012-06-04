//
//  SettingsDetailViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 4/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "SettingsDetailViewController.h"
#import "AssociationParser.h"

#define FILTER_ASSOS 0
#define FILTER_TYPE 1
#define CERCLES 0
#define CLUBS 1

@interface SettingsDetailViewController ()

@end

@implementation SettingsDetailViewController

@synthesize cerclesArray, clubsArray, typeArray;
@synthesize clubsChoice, cerclesChoice;
@synthesize filter;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        if (filter == FILTER_ASSOS) {
            cerclesArray = [[AssociationParser instance] arrayCercles];
            clubsArray = [[AssociationParser instance] arrayClubs];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
            NSMutableDictionary *cerclesDico = [defaults objectForKey:@"filtreCercles"];
            NSMutableDictionary *clubsDico  = [defaults objectForKey:@"filtreClubs"];

            
            cerclesChoice = [[NSMutableArray alloc] initWithCapacity:[cerclesArray count]];
            clubsChoice = [[NSMutableArray alloc] initWithCapacity:[clubsArray count]];
            for (NSString *cercle in cerclesArray) {
                [cerclesChoice addObject:[cerclesDico objectForKey:cercle]];
            }
            for (NSString *club in clubsArray) {
                [clubsChoice addObject:[clubsDico objectForKey:club]];
            }
            NSLog(@"%@", [cerclesChoice objectAtIndex:2]);
            NSLog(@"%@", [clubsChoice objectAtIndex:2]);
            
        }
    }
    return self;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (filter == FILTER_ASSOS) {
        return 2;
    }
    else if (filter == FILTER_TYPE) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (filter == FILTER_ASSOS) {
        if (section == CERCLES) {
            return [cerclesArray count];
        }
        else if (section == CLUBS){
            return [clubsArray count];
        }
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (filter == FILTER_ASSOS) {
        if (section == 0) {
            return @"Cercles";
        }
        else {
            return @"Clubs et associations";
        }
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
    if (filter == FILTER_ASSOS) {
        if (indexPath.section == CERCLES) {
            [cell.textLabel setText:(NSString *)[cerclesArray objectAtIndex:indexPath.row]];
             checked = [[cerclesChoice objectAtIndex:indexPath.row] boolValue];
        }
        else if (indexPath.section == CLUBS){
            [cell.textLabel setText:[clubsArray objectAtIndex:indexPath.row]];
            checked = [[clubsChoice objectAtIndex:indexPath.row] boolValue];
        }
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
    if (filter == FILTER_ASSOS) {
        if (indexPath.section == CERCLES) {
            BOOL value = [[cerclesChoice objectAtIndex:indexPath.row] boolValue];
            value = 1 - value;
            [cerclesChoice replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:value]];
        }
        else if (indexPath.section == CLUBS) {
            BOOL value = [[clubsChoice objectAtIndex:indexPath.row] boolValue];
            value = 1 - value;
            [clubsChoice replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:value]];
        }
    }
    [tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    NSMutableDictionary *cerclesDico = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"filtreCercles"]];
    NSMutableDictionary *clubsDico = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"filtreClubs"]];
    
    for (int i = 0; i < [cerclesArray count]; i++) {
        [cerclesDico setObject:[cerclesChoice objectAtIndex:i] forKey:[cerclesArray objectAtIndex:i]];
    }
    for (int i = 0; i < [clubsArray count]; i++) {
        [clubsDico setObject:[clubsChoice objectAtIndex:i] forKey:[clubsArray objectAtIndex:i]];
    }
    [defaults setObject:cerclesDico forKey:@"filtreCercles"];
    [defaults setObject:clubsDico forKey:@"filtreClubs"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end