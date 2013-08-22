//
//  Association.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 15/8/13.
//  Copyright (c) 2013 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, News;

@interface Association : NSManagedObject

@property (nonatomic, retain) NSNumber * idAssos;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *news;
@end

@interface Association (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addNewsObject:(News *)value;
- (void)removeNewsObject:(News *)value;
- (void)addNews:(NSSet *)values;
- (void)removeNews:(NSSet *)values;

@end
