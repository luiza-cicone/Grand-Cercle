//
//  SecondViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    // La cellule customize
    IBOutlet UITableViewCell *newsCell;
    
    // Tableau contenant les news
    NSArray *newsArray;
        
    // Tableview contenant la liste des cellule
    IBOutlet UITableView *tView;
   
    NSManagedObjectContext *managedObjectContext;
}

@property (assign, nonatomic) IBOutlet UITableViewCell *newsCell;
@property (assign, nonatomic) NSArray *newsArray;
@property (assign, nonatomic) IBOutlet UITableView *tView;

@end
