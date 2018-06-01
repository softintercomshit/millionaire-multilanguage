#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//Database entities

@interface AccessLayer : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (AccessLayer *)shared;

- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectContext *)managedObjectContext;

- (void)saveContext;
- (void)resetDatabase;

@end
