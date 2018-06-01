#import "QuestionLang+CoreDataClass.h"
#import "AccessLayer.h"

@implementation QuestionLang

//-(NSString *)description {
//    return [NSString stringWithFormat:@"\nid----->%d\ntext------>%@", self.question_id, self.text];
//}

-(void)setUsed{
    self.used = true;
    [[AccessLayer shared] saveContext];
}

@end
