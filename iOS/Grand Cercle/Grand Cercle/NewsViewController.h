//
//  SecondViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableViewCell *newsCell;
    NSMutableArray *newsArray;
}
@property (assign, nonatomic) IBOutlet UITableViewCell *newsCell;
@property (assign, nonatomic) NSMutableArray *newsArray;
@end
