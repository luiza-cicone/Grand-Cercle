//
//  SecondViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "NewsViewController.h"
#import "DealsViewController.h"
#import "NewsParser.h"

@implementation NewsViewController
@synthesize newsCell;
@synthesize tView;
@synthesize newsArray, urlArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"News", @"News");
        self.tabBarItem.image = [UIImage imageNamed:@"news"];
    }
    
    newsArray = [[NewsParser instance] arrayNews];
    
    // configure image cache

    urlArray = [[NSMutableArray alloc] initWithCapacity:[newsArray count]];
    
    for (int i = 0; i < [newsArray count]; i++) {
        News *n = [newsArray objectAtIndex:i];
        [urlArray addObject:[n logo]];
    }
	
	imageCache = [[TKImageCache alloc] initWithCacheDirectoryName:@"images"];
	imageCache.notificationName = @"newImageCache";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved:) name:@"newImageCache" object:nil];

    
    return self;
}

- (void) newImageRetrieved:(NSNotification*)sender{
    
	NSDictionary *dict = [sender userInfo];
    NSInteger tag = [[dict objectForKey:@"tag"] intValue];
    
    NSArray *paths = [self.tView indexPathsForVisibleRows];

    
    for(NSIndexPath *path in paths) {
        
    	NSInteger index = path.row;
    
        UITableViewCell *cell = [self.tView cellForRowAtIndexPath:path];
        UIImageView *imageView;
        imageView = (UIImageView *)[cell viewWithTag:1];
    	if(imageView.image == nil && tag == index){
            
            imageView.image = [dict objectForKey:@"image"];
            [cell setNeedsLayout];
        }
    }
}

	
- (void)viewDidAppear:(BOOL)animated {    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [self setNewsCell:nil];
    [newsCell release];
    [urlArray release];
    [newsArray release];
	[imageCache release];
    [tView release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        cell = newsCell;
        self.newsCell = nil;
    }
    
    News *n = (News *)[newsArray objectAtIndex:[indexPath row]];
    
    
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:1];
    
//    UIImage *myimage = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:(NSString*)[n logo]]]];

    UIImage *img = [imageCache imageForKey:[NSString stringWithFormat:@"%d", indexPath.row] url:[NSURL URLWithString:[urlArray objectAtIndex: indexPath.row]] queueIfNeeded:YES tag: indexPath.row];

    [imageView setImage:img];
    
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:2];
    [label setText: [n title]];
    
    label = (UILabel *)[cell viewWithTag:3];
    [label setText:[n pubDate]];
    
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
    NSLog(@"selected");
    // Navigation logic may go here. Create and push another view controller.
    
     DealsViewController *detailViewController = [[DealsViewController alloc] initWithNibName:@"DealsViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
}


- (void)dealloc {
    [newsCell release];
    [urlArray release];
    [newsArray release];
	[imageCache release];
    [super dealloc];
}
@end
