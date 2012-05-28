//
//  FirstViewController.m
//  GrandCercle
//
//  Created by Luiza Cicone on 22/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "CalendarViewController.h"

@implementation CalendarViewController
@synthesize sv;
@synthesize laPage;

  // Implémentation de l'interface UIScrollViewDelegate, permettant la mise à jour du page control
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat largeurPage = sv.frame.size.width;
    int page = floor((sv.contentOffset.x - largeurPage / 2) / largeurPage) + 1;
    laPage.currentPage = page;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /* Bout de code du site du zéro, permettant l'affichage de différentes pages de couleurs à scroller */
    NSArray *couleurs = [NSArray arrayWithObjects:[UIColor blackColor], [UIColor blackColor], [UIColor blackColor],nil];
    for (int i = 0; i < couleurs.count; i++) 
    {
        // Définition d'un rectangle
        CGRect rectangle;
        rectangle.origin.x = sv.frame.size.width * i;
        rectangle.origin.y = 0;
        rectangle.size = sv.frame.size; //Le rectangle a la même dimension que le UIScrollView
        
        // Ajout de la vue correspondante
        UIView *subview = [[UIView alloc] initWithFrame:rectangle];
        subview.backgroundColor = [couleurs objectAtIndex:i];
        [sv addSubview:subview];
    }
    
    sv.contentSize = CGSizeMake(sv.frame.size.width * couleurs.count, sv.frame.size.height);
}

- (void)viewDidUnload
{
    [self setSv:nil];
    [self setLaPage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Implémentation de l'action du page control
- (IBAction)changePage:(id)sender {
    CGRect frame;
    frame.origin.x = sv.frame.size.width * laPage.currentPage;
    frame.origin.y = 0;
    frame.size = sv.frame.size;
    [sv scrollRectToVisible:frame animated:YES];
}
@end
