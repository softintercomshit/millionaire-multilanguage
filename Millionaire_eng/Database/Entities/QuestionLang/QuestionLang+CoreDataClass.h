#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Language, QuestionModel;

NS_ASSUME_NONNULL_BEGIN

@interface QuestionLang : NSManagedObject

-(void)setUsed;

@end

NS_ASSUME_NONNULL_END

#import "QuestionLang+CoreDataProperties.h"
