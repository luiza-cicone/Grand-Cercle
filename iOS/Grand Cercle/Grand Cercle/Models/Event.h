//
//  Event.h
//  TapkuLibrary
//
//  Created by Luiza Cicone on 21/7/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Association;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * idEvent;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * pubDate;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Association *author;

@end
