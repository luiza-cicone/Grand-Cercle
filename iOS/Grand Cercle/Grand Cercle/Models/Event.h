//
//  Event.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 7/8/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Association;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * dateText;
@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSNumber * idEvent;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) Association *author;

@end
