//
//  Association.h
//  TapkuLibrary
//
//  Created by Luiza Cicone on 21/7/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Association : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet *news;
@property (nonatomic, retain) NSSet *events;
@end

@interface Association (CoreDataGeneratedAccessors)

- (void)addNewsObject:(NSManagedObject *)value;
- (void)removeNewsObject:(NSManagedObject *)value;
- (void)addNews:(NSSet *)values;
- (void)removeNews:(NSSet *)values;
- (void)addEventsObject:(NSManagedObject *)value;
- (void)removeEventsObject:(NSManagedObject *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;
@end
