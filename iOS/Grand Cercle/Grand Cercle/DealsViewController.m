//
//  SecondViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "DealsViewController.h"
#import "BonsPlansParser.h"

@implementation DealsViewController
@synthesize tview;
@synthesize bonsPlansCell, arrayBonsPlans, urlArray, imageCache;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Deals", @"");
        self.tabBarItem.image = [UIImage imageNamed:@"deals"];
    }
    
    arrayBonsPlans = [[BonsPlansParser instance] arrayBonsPlans];

    // configure image cache
    
    urlArray = [[NSMutableArray alloc] initWithCapacity:[arrayBonsPlans count]];
    
    for (int i = 0; i < [arrayBonsPlans count]; i++) {
        BonsPlans *bp = [arrayBonsPlans objectAtIndex:i];
        [urlArray addObject:[bp logo]];
    }
	
	imageCache = [[TKImageCache alloc] initWithCacheDirectoryName:@"logos"];
	imageCache.notificationName = @"newLogoCache";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved:) name:@"newLogoCache" object:nil];

    return self;
}

- (void) newImageRetrieved:(NSNotification*)sender{
    
	NSDictionary *dict = [sender userInfo];
    NSInteger tag = [[dict objectForKey:@"tag"] intValue];
    
    NSArray *paths = [self.tview indexPathsForVisibleRows];
    
    
    for(NSIndexPath *path in paths) {
        
    	NSInteger index = path.row;
    
        UITableViewCell *cell = [self.tview cellForRowAtIndexPath:path];
        UIImageView *imageView;
        imageView = (UIImageView *)[cell viewWithTag:1];
    	if(imageView.image == nil && tag == index){
            
            imageView.image = [dict objectForKey:@"image"];
            [cell setNeedsLayout];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [bonsPlansCell release];
    bonsPlansCell = nil;
    [self setBonsPlansCell:nil];
    [tview release];
    tview = nil;
    [self setTview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayBonsPlans count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DealCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"DealCell" owner:self options:nil];
        cell = bonsPlansCell;
        self.bonsPlansCell = nil;
    }
    
    BonsPlans *b = (BonsPlans *)[arrayBonsPlans objectAtIndex:[indexPath row]];
    
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:1];
    
    UIImage *img = [imageCache imageForKey:[NSString stringWithFormat:@"%d", [indexPath row]] url:[NSURL URLWithString:[urlArray objectAtIndex: indexPath.row]] queueIfNeeded:YES tag: indexPath.row]; 
    [imageView setImage:img];

    UILabel *label;
    label = (UILabel *)[cell viewWithTag:2];
    [label setText: [b title]];
    
    label = (UILabel *)[cell viewWithTag:3];
    [label setText: [b description]];
    
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

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [bonsPlansCell release];
    [bonsPlansCell release];
    [tview release];
    [tview release];
    [super dealloc];
}
@end

