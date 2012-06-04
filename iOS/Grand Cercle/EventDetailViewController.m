//
//  EventDetailViewController.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 31/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EventDetailViewController.h"
#import "NSString+HTML.h"

#define TITRE 0
#define INFOS 1
#define ORGANISATION 2
#define DESCRIPTION 3

@implementation EventDetailViewController
@synthesize event, cellEventTop, cellEventDescription;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = NSLocalizedString(@"Events", @"Events");
}

- (void)viewDidUnload
{
    [cellEventTop release];
    cellEventTop = nil;
    [cellEventDescription release];
    cellEventDescription = nil;
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
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case ORGANISATION:
            return @"Organisateur";
            break;
        case DESCRIPTION:
            return @"Description";
            break;
        default:
            break;
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case INFOS:
            CellIdentifier = @"EventTopCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                [[NSBundle mainBundle] loadNibNamed:@"EventTopCell" owner:self options:nil];
                cell = cellEventTop;
                self.cellEventTop = nil;
            }
            
            UIImageView *imageView;
            imageView = (UIImageView *)[cell viewWithTag:1];
            
            UIImage *myimage = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[event imageSmall]]]];
            [imageView setImage:myimage];
            
            UILabel *label;
            label = (UILabel *)[cell viewWithTag:2];
            [label setText: [event title]];
            
            label = (UILabel *)[cell viewWithTag:3];
            [label setText:[event date]];
            
            label = (UILabel *)[cell viewWithTag:4];
            [label setText:[[[event place] stringByAppendingString: @" - "] stringByAppendingString: event.time]];
            
            break;
            
        case ORGANISATION:
            CellIdentifier = @"Cercle";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell.textLabel setText : event.group];
            UIImage *img2 = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:(NSString*)event.logo]]];
            [cell.imageView setImage: img2];
            break;
            
        case DESCRIPTION:
            CellIdentifier = @"DescriptionCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                [[NSBundle mainBundle] loadNibNamed:@"DescriptionCell" owner:self options:nil];
                cell = cellEventDescription;
                self.cellEventDescription = nil;
            }
            
            UITextView *textView;
            textView = (UITextView *)[cell viewWithTag:1];
            [textView setText: [[event description] stringByConvertingHTMLToPlainText]];
            break;
            
        default:
            break;
    }
        
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case TITRE:
            return 30;
            break;
        case INFOS :
            return 120;
            break;
        
        case ORGANISATION :
            return 30;
            break;
            
        case DESCRIPTION :
            return 155;
            break;
            
        default :
            return 44;
            break;
    }
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)dealloc {
    [cellEventTop release];
    [cellEventDescription release];
    [super dealloc];
}
@end
