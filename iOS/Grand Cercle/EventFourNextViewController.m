//
//  EventFourNextViewController.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 01/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EventFourNextViewController.h"
#import "EvenementsParser.h"
#import "Evenements.h"
#import "EventDetailViewController.h"

@implementation EventFourNextViewController
@synthesize tabImage, tabLabel, superController;

int borneSup = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    EvenementsParser *ep = [EvenementsParser instance];
    borneSup = MIN(4, [ep.arrayEvents count]);
    
    if (self) {
        tabLabel = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
        tabImage = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
        
        for (int i = 0; i < borneSup; i++) {
            [tabImage addObject:[[ep.arrayEvents objectAtIndex:i] image]];
            [tabLabel addObject:[[ep.arrayEvents objectAtIndex:i] date]];
        }
        
        UILabel *label;
        for (int i = 0; i < borneSup; i++) {
            label = (UILabel *)[self.view viewWithTag:i+5];
            [label setText: [tabLabel objectAtIndex:i]];
            UIImageView *imageView;
            UIButton *button;
            imageView = (UIImageView *)[self.view viewWithTag:i+1];
            button = (UIButton *)[self.view viewWithTag:i+9];
            [button setHidden:NO];
            UIImage *myimage = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:(NSString*)[tabImage objectAtIndex:i]]]];
            [imageView setImage:myimage];
            
        }
        for (int i = borneSup; i < 4; i++) {
            label = (UILabel *)[self.view viewWithTag:i+5];
            [label setText: @""];
        }

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)imageButtonAction:(id)sender {
    
    Evenements *selectedEvent = nil;
    if ((UIButton*)sender == (UIButton *)[self.view viewWithTag:9] && borneSup > 0) {
        selectedEvent = [[[EvenementsParser instance] arrayEvents ] objectAtIndex:0];
    } else if ((UIButton*)sender == (UIButton *)[self.view viewWithTag:10] && borneSup > 1) {
        selectedEvent = [[[EvenementsParser instance] arrayEvents ] objectAtIndex:1];
    } else if ((UIButton*)sender == (UIButton *)[self.view viewWithTag:11] && borneSup > 2) {
        selectedEvent = [[[EvenementsParser instance] arrayEvents ] objectAtIndex:2];
    } else if ((UIButton*)sender == (UIButton *)[self.view viewWithTag:12] && borneSup > 3) {
        selectedEvent = [[[EvenementsParser instance] arrayEvents ] objectAtIndex:3];
    }
    
    EventDetailViewController *detailEventController = [[EventDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailEventController.event = selectedEvent;
    [self.superController.navigationController pushViewController:detailEventController animated:YES];
    [detailEventController release];
    detailEventController = nil;
}

- (void)dealloc {

    [super dealloc];
}
@end
