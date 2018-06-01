//
//  LocalNotification.h
//  LocalNotification
//
//  Created by Roman Cebotari on 12/24/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotification : NSObject

+ (LocalNotification *)sharedNotification;

//- (void)registerForDate:(NSDate *)date alertBody:(NSString *)body;

- (void)registerNotification:(id)notification forDate:(NSDate *)date withDelay:(NSTimeInterval)delay;
- (NSArray *)getRegisteredNotification;
- (void)cancelAllNotifications;

@end
