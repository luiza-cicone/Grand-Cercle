//
//  Association.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 6/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Association : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * logo;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *news;
@end

@interface Association (CoreDataGeneratedAccessors)

- (void)addEventsObject:(NSManagedObject *)value;
- (void)removeEventsObject:(NSManagedObject *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;
- (void)addNewsObject:(NSManagedObject *)value;
- (void)removeNewsObject:(NSManagedObject *)value;
- (void)addNews:(NSSet *)values;
- (void)removeNews:(NSSet *)values;
@end
