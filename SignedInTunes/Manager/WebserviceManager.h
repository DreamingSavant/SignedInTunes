//
//  WebserviceManager.h
//  SignedInTunes
//
//  Created by Kevin Yu on 12/17/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebserviceManager : NSObject

+ (WebserviceManager *)sharedInstance;

- (void)getAlbums:(void (^)(NSDictionary *))completion;

@end

NS_ASSUME_NONNULL_END
