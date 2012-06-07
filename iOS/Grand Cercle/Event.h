//
//  Event.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 6/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Association;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * hour;
@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Association *createur;

@end
