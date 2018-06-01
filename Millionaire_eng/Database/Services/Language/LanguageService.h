#import <Foundation/Foundation.h>
#import "Language+CoreDataClass.h"

@interface LanguageService : NSObject

+(Language *)getLanguageByID:(int)lang_id;
+(Language *)getLanguageByName:(NSString *)name;

@end
