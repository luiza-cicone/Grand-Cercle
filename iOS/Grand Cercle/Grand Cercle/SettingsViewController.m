//
//  PreferencesViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 4/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsDetailViewController.h"

#define FILTER_EVENT 0
#define FILTER_NEWS 2
#define PERSO 1

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Settings", @"Settings");
        self.tabBarItem.image = [UIImage imageNamed:@"settings"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release]; 
    
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

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    NSArray *c = [defaults objectForKey:@"theme"];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
    
//    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:.18]];
    
    if ([[c objectAtIndex:0] floatValue] == 0.0 && [[c objectAtIndex:1] floatValue] == 0.0 && [[c objectAtIndex:2] floatValue] == 0.0) {
    
       [self.tableView setSeparatorColor: [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.18]];
        
    } else {
        
        [self.tableView setSeparatorColor:[[UIColor alloc] initWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:0.5]];
    
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == FILTER_EVENT) {
        return 3;
    } else if (section == FILTER_NEWS) {
        return 2;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == FILTER_EVENT) {
        return @"Filtrer les événements par";
    } else if (section == FILTER_NEWS) {
        return @"Filtrer les news par";
    } else if (section == PERSO) {
        return @"Personnaliser l'interface";
    } else return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == FILTER_EVENT) { 
    
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Cercles"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Clubs & Associations"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        } else if (indexPath.row == 2) {
            [cell.textLabel setText:@"Type"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }
        
    } else if (indexPath.section == FILTER_NEWS) {
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Cercles"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Clubs & Associations"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    } else if (indexPath.section == PERSO) {
        [cell.textLabel setText:@"Thème"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }    
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
    SettingsDetailViewController *detailViewController = [[SettingsDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailViewController.filter = indexPath;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

@end
