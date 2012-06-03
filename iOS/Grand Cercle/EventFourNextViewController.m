//
//  EventFourNextViewController.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 01/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EventFourNextViewController.h"
#import "EvenementsParser.h"

@implementation EventFourNextViewController
@synthesize tabImage, tabLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    EvenementsParser *ep = [EvenementsParser instance];
    int borneSup = MIN(4, [ep.arrayEvents count]);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tabLabel = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
        tabImage = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
        
        for (int i = 0; i < borneSup; i++) {
            [tabImage addObject:[[ep.arrayEvents objectAtIndex:i] image]];
            [tabLabel addObject:[[ep.arrayEvents objectAtIndex:i] date]];
        }
    }
    
    UILabel *label;
    for (int i = 0; i < borneSup; i++) {
        label = (UILabel *)[self.view viewWithTag:i+5];
        [label setText: [tabLabel objectAtIndex:i]];
        UIImageView *imageView;
        imageView = (UIImageView *)[self.view viewWithTag:i+1];
        
        UIImage *myimage = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:(NSString*)[tabImage objectAtIndex:i]]]];
        
//        UIImage *img = [imageCache imageForKey:[NSString stringWithFormat:@"%d", indexPath.row] url:[NSURL URLWithString:[urlArray objectAtIndex: indexPath.row]] queueIfNeeded:YES tag: indexPath.row];
        [imageView setImage:myimage];
        
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

@end
