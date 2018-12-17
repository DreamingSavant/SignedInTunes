//
//  CoreDataManager.m
//  SignedInTunes
//
//  Created by Kevin Yu on 12/17/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

@implementation CoreDataManager

@synthesize persistentContainer = _persistentContainer;


+ (CoreDataManager *)sharedInstance {
    static CoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}


- (Album *)createAlbumWith:(NSString *)artistName
                 albumName:(NSString *)albumName
               releaseDate:(NSDate *)dateOfRelease
                  imageURL:(NSURL *)imageLink
                     genre:(NSString *)genre
                     price:(NSNumber *)price {
    
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    Album *album = [[Album alloc] initWithContext:context];
    album.artist = artistName;
    album.albumName = albumName;
    album.dateOfRelease = dateOfRelease;
    album.imageLink = imageLink;
    album.genre = genre;
    album.price = [price doubleValue];
    
    // [self saveContext];
    
    return album;
}



#pragma mark - Core Data stack

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"SignedInTunes"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
