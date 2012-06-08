//
//  InfosViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 7/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "InfosViewController.h"

#define GC 0

#define EXTERN 1
#define MAIL 0
#define SITE 1
#define FB 2

#define INFOS 2

@interface InfosViewController ()

@end

@implementation InfosViewController

@synthesize topCell, descriptionCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Infos", @"Infos");
        self.tabBarItem.image = [UIImage imageNamed:@"infos"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
//    if (section == CONTACTS) {
//        return 4;
//    }
    if (section == GC) {
        return 1;
    }
    else if (section == EXTERN) {
        return 3;
    }
    else if (section == INFOS) {
        return 1;
    }
    else {
        return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == CONTACTS) {
//        return @"Contacts";
//    }
//    else 
    if (section == EXTERN) {
        return @"Contact";
    }
    else if (section == INFOS) {
        return @"Détails";
    }
    else {
        return @"";
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case GC :
            return 60;
            break;
            
        case EXTERN :
            return 40;
            break;
            
        case INFOS :
            return 650;
            break;
            
        default :
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
//    if (indexPath.section == CONTACTS) {
//        if (indexPath.row == GC) {
//            [cell.textLabel setText:@"Grand Cercle"];
//        }
//        else if (indexPath.row == ELUS) {
//            [cell.textLabel setText:@"Elus étudiants"];
//        }
//        else if (indexPath.row == CERCLES) {
//            [cell.textLabel setText:@"Cercles"];
//        }
//        else if (indexPath.row == CLUBS) {
//            [cell.textLabel setText:@"Clubs & associations"];
//        }
//    }
    if (indexPath.section == GC) {
        CellIdentifier = @"InfosTopCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            [[NSBundle mainBundle] loadNibNamed:@"InfosTopCell" owner:self options:nil];
            cell = topCell;
            self.topCell = nil;
        }
    }
    if (indexPath.section == EXTERN) {
        CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == SITE) {
            [cell.textLabel setText:@"Site Web"];
        }
        else if (indexPath.row == FB) {
            [cell.textLabel setText:@"Page Facebook"];
        }
        else if (indexPath.row == MAIL) {
            [cell.textLabel setText:@"E-mail"];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if (indexPath.section == INFOS) {
        CellIdentifier = @"DescriptionCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            [[NSBundle mainBundle] loadNibNamed:@"InfosDescriptionCell" owner:self options:nil];
            cell = descriptionCell;
            self.descriptionCell = nil;
        }
        
        UIWebView *tv = (UIWebView *)[cell viewWithTag:1];
        [tv sizeToFit];
        [tv loadHTMLString:@"<p>Le Grand Cercle, c'est l'un des plus grands BDE de France, à votre service, pour vous offrir des moments inoubliables !</p>\
         <p>Le GC, c'est une cinquantaine d'étudiants de toutes les écoles de Grenoble INP qui s'occupent d'organiser les plus gros événements de votre année : la soirée d'intégration, la soirée d'Automne, le Gala, et tant d'autres !</p>\
         <p>Mais son rôle, c'est aussi d'assurer le lien entre les différentes écoles et BDE, les élus et les étudiants de Grenoble INP. N'hésitez pas à nous contacter pour toute information !</p>\
         <p>Le GC, c'est aussi une représentation nationale grâce au Bureau National des Élèves Ingénieurs (BNEI), en tant qu'administrateur, nous pouvons faire remonter vos idées ou questions !</p>\
         <p>Enfin, et surtout, le GC, ce sont des gens toujours prêts à vous aider, en toutes circonstances : pour demander un renseignement, pour un coup de pouce sur un projet, ou tout simplement pour faire la fête ;)</p>" baseURL:nil];
        
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
    if (indexPath.section == EXTERN) {
        if (indexPath.row == SITE) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://grandcercle.org"]];
        }
        else if (indexPath.row == FB) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/grandcercle"]];
        }
        else if (indexPath.row == MAIL) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:grandcercle@grandcercle.org"]];            

        }

    }
}

@end
