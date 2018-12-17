//
//  CoreDataManager.h
//  SignedInTunes
//
//  Created by Kevin Yu on 12/17/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SignedInTunes-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataManager : NSObject

+ (CoreDataManager *)sharedInstance;

- (Album *)createAlbumWith:(NSString *)artistName
                 albumName:(NSString *)albumName
               releaseDate:(NSDate *)dateOfRelease
                  imageURL:(NSURL *)imageLink
                     genre:(NSString *)genre
                     price:(NSNumber *)price;

@end

NS_ASSUME_NONNULL_END
