//
//  InfosViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 7/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfosViewController : UITableViewController {
    IBOutlet UITableViewCell *topCell, *descriptionCell;

}

@property (nonatomic, retain) IBOutlet UITableViewCell *topCell, *descriptionCell;

@end
