//
//  BonsPlans.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 30/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Items.h"

@interface BonsPlans : Items {
    // Résumé de l'offre
    NSString *summary;
}

@property (nonatomic, retain) NSString *summary; 

@end
