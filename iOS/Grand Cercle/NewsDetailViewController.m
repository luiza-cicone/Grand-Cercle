//
//  NewsDetailViewController.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 01/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NSString+HTML.h"

@implementation NewsDetailViewController
@synthesize news, cellNewsDescription, cellNewsTop;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    self.title = news.group;
}

- (void)viewDidUnload
{
    [cellNewsDescription release];
    cellNewsDescription = nil;
    [cellNewsTop release];
    cellNewsTop = nil;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    
    switch (indexPath.section) {
            
        case 0:
            CellIdentifier = @"NewsTopCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                [[NSBundle mainBundle] loadNibNamed:@"NewsTopCell" owner:self options:nil];
                cell = cellNewsTop;
                self.cellNewsTop = nil;
            }
            
            UIImageView *imageView;
            imageView = (UIImageView *)[cell viewWithTag:1];
            
            UIImage *myimage2 = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:(NSString*)[news logo]]]];
            [imageView setImage:myimage2];
            
            UILabel *label;
            label = (UILabel *)[cell viewWithTag:2];
            [label setText: [news title]];
            
            label = (UILabel *)[cell viewWithTag:3];
            [label setText:[news pubDate]];
            break;
            
//        case 1:
//            CellIdentifier = @"Cercle";
//            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (!cell) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            }
//            [cell.textLabel setText : news.group];
//            UIImage *img = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:(NSString*)news.logo]]];
//            [cell.imageView setImage: img];
//            break;
            
        case 1:
            CellIdentifier = @"NewsDescription";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                [[NSBundle mainBundle] loadNibNamed:@"NewsDescription" owner:self options:nil];
                cell = cellNewsDescription;
                self.cellNewsDescription = nil;
            }
            
            UITextView *textView;
            textView = (UITextView *)[cell viewWithTag:1];
            [textView setText: [[news description] stringByConvertingHTMLToPlainText]];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0 :
            return 121;
            break;
            
//        case 1 :
//            return 44;
//            break;
//            
        case 1 :
            return 165;
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
    [cellNewsDescription release];
    [cellNewsTop release];
    [super dealloc];
}
@end
