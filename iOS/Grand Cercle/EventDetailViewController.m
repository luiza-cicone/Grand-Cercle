//
//  EventDetailViewController.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 31/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EventDetailViewController.h"
#import "NSString+HTML.h"
#import "AppDelegate.h"
#import "Association.h"

#define TITRE 0
#define INFOS 1
#define DESCRIPTION 2

@implementation EventDetailViewController
@synthesize event, cellEventTop, cellEventDescription, cellEventInfo;

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
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(addToCalendar)];
    self.navigationItem.rightBarButtonItem = plusButton;
    
    self.title = NSLocalizedString(@"Events", @"Events");

    [[NSBundle mainBundle] loadNibNamed:@"DescriptionCell" owner:self options:nil];

    webViewHeight = 0;
    
    UIWebView *webView;
    webView = (UIWebView *)[cellEventDescription viewWithTag:1];
    webView.delegate = self;
    [webView loadHTMLString:event.description baseURL:nil];
    [plusButton release];

}

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    NSArray *c = [defaults objectForKey:@"theme"];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
}

-(void) addToCalendar {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Retour" destructiveButtonTitle:nil otherButtonTitles:@"Exporter dans iCal", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.destructiveButtonIndex = 2;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [actionSheet showInView: appDelegate.window];
    [actionSheet release]; 
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        EKEventStore *eventDB = [[[EKEventStore alloc] init] autorelease];    
        EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB];
    
        myEvent.title     = event.title;
        myEvent.startDate = event.date;
        myEvent.endDate   = event.date;
        myEvent.allDay = YES;
        myEvent.notes = [event.description stringByConvertingHTMLToPlainText];
        myEvent.location = event.location;
    
        // Choix du calendrier
        [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
    
        NSError *err;
        [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err];
        if (err == noErr) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Exportation iCal"
                                  message:@"Exportation éffectuée avec succés"
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
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
    switch (section) {
        case INFOS:
            return 3;
            break;
        default:
            break;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    switch (section) {
//        case DESCRIPTION:
//            return @"Détails";
//            break;
//        default:
//            break;
//    }
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell = nil;
    UIImageView *imageView;
    UILabel *label;

    switch (indexPath.section) {
        case TITRE:
            CellIdentifier = @"EventTopCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                [[NSBundle mainBundle] loadNibNamed:@"EventTopCell" owner:self options:nil];
                cell = cellEventTop;
                self.cellEventTop = nil;
            }
            
            
            imageView = (UIImageView *)[cell viewWithTag:1];
            
            if (![event.thumbnail isEqualToString:@""]) {
                // test si c'est dans le cache
                NSString *imageKey = [NSString stringWithFormat:@"%x", [event.thumbnail hash]];
                
                NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *imagePath = [[documentsDirectory stringByAppendingPathComponent:@"images/events/thumb"] stringByAppendingPathComponent:imageKey];
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
                
                if (fileExists) {
                    [imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
                } else {
                    [imageView setImage:nil];
                }
            }
            
//           
//            UIWebView *wv = (UIWebView *)[cell viewWithTag:7];
//            
//            [wv loadHTMLString:[NSString stringWithFormat:@"<p style=\"font-family : Helvetica;\"><b>%@</b></p><p>%@</p>", [event title], [[event author] name]] baseURL:nil];
            
            
            label = (UILabel *)[cell viewWithTag:2];
            [label setText: [event title]];
            
            label = (UILabel *)[cell viewWithTag:3];
            [label setText : event.author.name];
            
            imageView = (UIImageView *)[cell viewWithTag:4];
 
            
            NSString *imageKey = [NSString stringWithFormat:@"%x", [event.author.imagePath hash]];
            
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *imagePath = [[documentsDirectory stringByAppendingPathComponent:@"images/assos"] stringByAppendingPathComponent:imageKey];
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
            
            if (!fileExists) {
                [imageView setImage:nil];
            }
            else {
                [imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
            }
            
            break;
        
        case INFOS:          
            CellIdentifier = @"EventInfoCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                [[NSBundle mainBundle] loadNibNamed:@"EventInfoCell" owner:self options:nil];
                cell = cellEventInfo;
                self.cellEventInfo = nil;
            }
            UILabel *label2;
            label = (UILabel *)[cell viewWithTag:1];
            label2 = (UILabel *)[cell viewWithTag:2];
            if (indexPath.row == 0 ) {
                [label setText:@"Date"];
                [label2 setText:[NSString stringWithFormat:@"%@, %@", [event day], [event dateText]]];
            }
            else if (indexPath.row == 1) {
                [label setText:@"Heure"];
                [label2 setText:[event time]];
            }
            else if (indexPath.row == 2) {
                [label setText:@"Lieu"];
                [label2 setText:[event location]];
            }
                        
            break;
//        case ORGANISATION:
//            CellIdentifier = @"Cercle";
//            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (!cell) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            }
//            [cell.textLabel setText : event.group];
//            UIImage *img2 = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:(NSString*)event.logo]]];
//            [cell.imageView setImage: img2];
//            break;
            
        case DESCRIPTION:
            CellIdentifier = @"DescriptionCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                [[NSBundle mainBundle] loadNibNamed:@"DescriptionCell" owner:self options:nil];
                cell = cellEventDescription;
                self.cellEventDescription = nil;
            }

            UIWebView *webView;
            webView = (UIWebView *)[cell viewWithTag:1];
            webView.delegate = self;
            [webView loadHTMLString:event.content baseURL:nil];
            [webView sizeToFit];
            
            break;
            
        default:
            break;
    }
        
    return cell;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [[NSBundle mainBundle] loadNibNamed:@"DescriptionCell" owner:self options:nil];
    NSString *output = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    [webView setFrame:CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, [output intValue])];
    if (webViewHeight == 0) {
        webViewHeight = [output intValue];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    webViewHeight = 0;
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case TITRE:
            return 80;
            break;
        case INFOS :
            return 28;
            break;
        
//        case ORGANISATION :
//            return 28;
//            break;
            
        case DESCRIPTION : 
            return webViewHeight + 10;
            break;
            
        default :
            return 0;
            break;
    }
    return 0;
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
