#import "Initialpopulate.h"
#import <CoreData/CoreData.h>
#import "AccessLayer.h"
#import "Language+CoreDataClass.h"
#import "Difficulty+CoreDataClass.h"
#import "QuestionModel+CoreDataClass.h"
#import "QuestionLang+CoreDataClass.h"


static Initialpopulate *populateObject;

@implementation Initialpopulate

+(Initialpopulate *)startPopulate {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        populateObject = [Initialpopulate new];
    });
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:kFirstTimeLaunch]) {
        [defaults setDouble:1.0 forKey:kDatabaseVersion];
        [populateObject copyDB];
        [defaults setBool:true forKey:kFirstTimeLaunch];
        [defaults synchronize];
    }

//    [populateObject populateLanguages];
//    [populateObject populateDifficulties];
//    [populateObject populateQuestionModel];
//    [populateObject populateQuestionLangs];
    
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSLog(@"👺👺👺👺👺👺👺 %@", url.path);
    return populateObject;
}

-(void)copyDB {
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *sqlUrl = [bundle URLForResource:@"Millionaire" withExtension:@"sqlite"];
//    NSURL *shmUrl = [bundle URLForResource:@"Millionaire" withExtension:@"sqlite-shm"];
//    NSURL *walUrl = [bundle URLForResource:@"Millionaire" withExtension:@"sqlite-wal"];
    
    NSURL *documentsUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *sqlUrlDocs = [documentsUrl URLByAppendingPathComponent:@"Millionaire.sqlite"];
//    NSURL *shmUrlDocs = [documentsUrl URLByAppendingPathComponent:@"Millionaire.sqlite-shm"];
//    NSURL *walUrlDocs = [documentsUrl URLByAppendingPathComponent:@"Millionaire.sqlite-wal"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager copyItemAtURL:sqlUrl toURL:sqlUrlDocs error:nil];
//    [manager copyItemAtURL:shmUrl toURL:shmUrlDocs error:nil];
//    [manager copyItemAtURL:walUrl toURL:walUrlDocs error:nil];
}

-(void)populateLanguages {
    NSArray<NSDictionary*> *languages = [self arrayForFile:@"languages"];
    if (!languages) {return;}
    
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    [languages enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Language *language = [NSEntityDescription insertNewObjectForEntityForName:@"Language" inManagedObjectContext:context];
        language.lang_id = [obj[@"id"] intValue];
        language.name = obj[@"name"];
    }];
    
    [context save:nil];
}

-(void)populateDifficulties {
    NSArray<NSDictionary*> *difficulties = [self arrayForFile:@"difficulties"];
    if (!difficulties) {return;}
    
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    
    [difficulties enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Difficulty *difficulty = [NSEntityDescription insertNewObjectForEntityForName:@"Difficulty" inManagedObjectContext:context];
        difficulty.difficulty_id = [obj[@"id"] intValue];
        difficulty.level = [obj[@"level"] intValue];
        difficulty.remuneration = [obj[@"remuneration"] intValue];
    }];
    
    [context save:nil];
}

-(void)populateQuestionModel {
    NSArray<NSDictionary*> *questions = [self arrayForFile:@"questions_model"];
    if (!questions) {return;}
    
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    
    [questions enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = obj.allKeys[0];
        NSArray<NSDictionary*> *questions = obj[key];
        
        NSFetchRequest<Difficulty*> *formatRequest = [Difficulty fetchRequest];
        formatRequest.predicate = [NSPredicate predicateWithFormat:@"difficulty_id == %d", key.intValue];
        Difficulty *difficulty = [context executeFetchRequest:formatRequest error:nil].firstObject;
        
        [questions enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QuestionModel *questionModel = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionModel" inManagedObjectContext:context];
            questionModel.question_id = [obj[@"id"] intValue];
            questionModel.label = obj[@"label"];
            questionModel.difficulty = difficulty;
        }];
    }];
    
    [context save:nil];
}

-(void)populateQuestionLangs {
    NSArray<NSDictionary*> *questions = [self arrayForFile:@"questions"];
    if (!questions) {return;}
    
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    
    [questions enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QuestionLang *questionLang = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionLang" inManagedObjectContext:context];
        questionLang.question_id = [obj[@"id"] intValue];
        questionLang.text = obj[@"text"];
        questionLang.answer1 = obj[@"answer1"];
        questionLang.answer2 = obj[@"answer2"];
        questionLang.answer3 = obj[@"answer3"];
        questionLang.answer4 = obj[@"answer4"];
        questionLang.correct_answer = obj[@"correct_answer"];

        NSFetchRequest<Language*> *languageFormatRequest = [Language fetchRequest];
        int lang_id = [obj[@"language"] intValue];
        languageFormatRequest.predicate = [NSPredicate predicateWithFormat:@"lang_id == %d", lang_id];
        Language *language = [context executeFetchRequest:languageFormatRequest error:nil].firstObject;
        questionLang.language = language;

        NSFetchRequest<QuestionModel*> *questionFormatRequest = [QuestionModel fetchRequest];
        int question_id = [obj[@"question"] intValue];
        questionFormatRequest.predicate = [NSPredicate predicateWithFormat:@"question_id == %d", question_id];
        QuestionModel *question = [context executeFetchRequest:questionFormatRequest error:nil].firstObject;
        questionLang.question = question;
        
        NSLog(@"%@", obj[@"id"]);
    }];
    
    [context save:nil];
}

-(NSArray<NSDictionary*>*)arrayForFile:(NSString *)fileName {
    NSURL *jsonUrl = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"json"];
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:jsonUrl];
    NSArray<NSDictionary*> *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
        return result;
    }
    return nil;
}

@end
