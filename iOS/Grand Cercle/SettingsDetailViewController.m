//
//  SettingsDetailViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 4/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "SettingsDetailViewController.h"
#import "FilterParser.h"
#import "EvenementsParser.h"

#define FILTER_CERCLES 0
#define FILTER_CLUBS 1
#define FILTER_TYPE 2
#define PERSO_COLOR 0
#define EVENTS 0
#define NEWS 2
#define PERSO 1

@implementation SettingsDetailViewController

@synthesize cerclesArray, clubsArray, typesArray, themesArray;
@synthesize clubsChoice, cerclesChoice, typesChoice, themeChoice;
@synthesize filter;

NSMutableDictionary *themesDico;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}
BOOL changed = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CERCLES) {
        
        cerclesArray = [[FilterParser instance] arrayCercles];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        NSMutableDictionary *cerclesDico = [defaults objectForKey:@"filtreCercles"];
        cerclesChoice = [[NSMutableArray alloc] initWithCapacity:[cerclesArray count]];
        for (NSString *cercle in cerclesArray) {
            [cerclesChoice addObject:[cerclesDico objectForKey:cercle]];
        }
        
    } else if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CLUBS) {
        
        clubsArray = [[FilterParser instance] arrayClubs];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        NSMutableDictionary *clubsDico  = [defaults objectForKey:@"filtreClubs"];
        clubsChoice = [[NSMutableArray alloc] initWithCapacity:[clubsArray count]];
        for (NSString *club in clubsArray) {
            [clubsChoice addObject:[clubsDico objectForKey:club]];
            
        }
        
    } else if (filter.section == EVENTS && filter.row == FILTER_TYPE) {
        typesArray = [[FilterParser instance] arrayTypes];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        NSMutableDictionary *typesDico = [defaults objectForKey:@"filtreTypes"];
        typesChoice = [[NSMutableArray alloc] initWithCapacity:[typesArray count]];
        for (NSString *type in typesArray) {
            [typesChoice addObject:[typesDico objectForKey:type]];
        }
        
    } else if (filter.section == PERSO && filter.row == PERSO_COLOR) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        NSArray *c = [defaults objectForKey:@"theme"];
        themeChoice = [[UIColor alloc] initWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1];
        UIColor *blackColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1];
        UIColor *redColor = [[UIColor alloc] initWithRed:.75 green:.08 blue:.12 alpha:1];
        UIColor *greenColor = [[UIColor alloc] initWithRed:.59 green:.74 blue:.06 alpha:1];
        UIColor *blueColor = [[UIColor alloc] initWithRed:0 green:0.59 blue:0.83 alpha:1];
        UIColor *darkBlueColor = [[UIColor alloc] initWithRed:0 green:.29 blue:.61 alpha:1];
        UIColor *yellowColor = [[UIColor alloc] initWithRed:1 green:.80 blue:0 alpha:1];
        UIColor *orangeColor = [[UIColor alloc] initWithRed:.94 green:.59 blue:0 alpha:1];
        UIColor *purpleColor = [[UIColor alloc] initWithRed:.59 green:.08 blue:0.49 alpha:1];
        themesDico = [[NSMutableDictionary alloc] initWithCapacity:8];
        [themesDico setObject:blackColor forKey:@"Noir Grand Cercle"];
        [themesDico setObject:darkBlueColor forKey:@"Bleu Ense3"];
        [themesDico setObject:greenColor forKey:@"Vert Ensimag"];
        [themesDico setObject:blueColor forKey:@"Bleu GI"];
        [themesDico setObject:redColor forKey:@"Rouge Phelma"];
        [themesDico setObject:orangeColor forKey:@"Orange Pagora"];
        [themesDico setObject:purpleColor forKey:@"Violet Esisar"];
        [themesDico setObject:yellowColor forKey:@"Jaune CPP"];
        themesArray = [[NSArray alloc] initWithObjects:@"Noir Grand Cercle", @"Bleu Ense3", @"Vert Ensimag", @"Bleu GI", @"Rouge Phelma", @"Orange Pagora", @"Violet Esisar", @"Jaune CPP", nil];
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
    if (filter.section == EVENTS || filter.section == NEWS || filter.section == PERSO) {
        return 1;
    } else  {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CERCLES) {
        return [cerclesArray count];
    } else if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CLUBS) {
        return [clubsArray count];
    } else if (filter.section == EVENTS && filter.row == FILTER_TYPE) {
        return [typesArray count];
    } else if (filter.section == PERSO && filter.row == PERSO_COLOR) {
        return [themesArray count];
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CERCLES) {
        return @"Cercles";
    } else if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CLUBS) {
            return @"Clubs & Associations";
    } else if (filter.section == EVENTS && filter.row == FILTER_TYPE) {
        return @"Types d'événements";
    } else if (filter.section == PERSO && filter.row == PERSO_COLOR) {
        return @"Thèmes";
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
    if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CERCLES) {
            [cell.textLabel setText:(NSString *)[cerclesArray objectAtIndex:indexPath.row]];
             checked = [[cerclesChoice objectAtIndex:indexPath.row] boolValue];
    } else if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CLUBS) {
            [cell.textLabel setText:[clubsArray objectAtIndex:indexPath.row]];
            checked = [[clubsChoice objectAtIndex:indexPath.row] boolValue];
    } else if (filter.section == EVENTS && filter.row == FILTER_TYPE) {
        [cell.textLabel setText:(NSString *)[typesArray objectAtIndex:indexPath.row]];
        checked = [[typesChoice objectAtIndex:indexPath.row] boolValue];
    } else if (filter.section == PERSO && filter.row == PERSO_COLOR) {
        
        [cell.textLabel setText:(NSString *)[themesArray objectAtIndex:indexPath.row]];
        checked = ([themeChoice isEqual:[themesDico objectForKey:(NSString *)[themesArray objectAtIndex:indexPath.row]]]);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        NSArray *c = [defaults objectForKey:@"theme"];
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
//        [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:0.18]]; 
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
    if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CERCLES) {
        BOOL value = [[cerclesChoice objectAtIndex:indexPath.row] boolValue];
        value = 1 - value;
        [cerclesChoice replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:value]];
    } else if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CLUBS) {
        BOOL value = [[clubsChoice objectAtIndex:indexPath.row] boolValue];
        value = 1 - value;
        [clubsChoice replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:value]];
    } else if (filter.section == EVENTS && filter.row == FILTER_TYPE) {
        BOOL value = [[typesChoice objectAtIndex:indexPath.row] boolValue];
        value = 1 - value;
        [typesChoice replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:value]];
    } else if (filter.section == PERSO && filter.row == PERSO_COLOR) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        themeChoice = [themesDico objectForKey:(NSString *)[themesArray objectAtIndex:indexPath.row]];
        CGFloat* colors = (CGFloat *)CGColorGetComponents(themeChoice.CGColor);
        NSArray *c = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:colors[0]], [NSNumber numberWithFloat:colors[1]], [NSNumber numberWithFloat:colors[2]], nil];
        [defaults setObject:c forKey:@"theme"];
        [c release];
    }
    changed = 1;
    [tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  

    if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CERCLES) {
        NSMutableDictionary *cerclesDico = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"filtreCercles"]];
        for (int i = 0; i < [cerclesArray count]; i++) {
            [cerclesDico setObject:[cerclesChoice objectAtIndex:i] forKey:[cerclesArray objectAtIndex:i]];
        }        
        [defaults setObject:cerclesDico forKey:@"filtreCercles"];
        
    } else if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CLUBS) {

        NSMutableDictionary *clubsDico = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"filtreClubs"]];
        for (int i = 0; i < [clubsArray count]; i++) {
            [clubsDico setObject:[clubsChoice objectAtIndex:i] forKey:[clubsArray objectAtIndex:i]];
        }
        [defaults setObject:clubsDico forKey:@"filtreClubs"];

    } else if (filter.section == EVENTS && filter.row == FILTER_TYPE) {
        NSMutableDictionary *typesDico = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"filtreTypes"]];
        for (int i = 0; i < [typesArray count]; i++) {
            [typesDico setObject:[typesChoice objectAtIndex:i] forKey:[typesArray objectAtIndex:i]];
        }
        [defaults setObject:typesDico forKey:@"filtreTypes"];
    }
    if (changed == 1) {
        [[EvenementsParser instance] loadEventsFromFile];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"changedEvents"];
    }
    changed = 0;

    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self viewDidUnload];
}

@end
