#import "DataTraveller.h"
#import "GameHistoryService.h"

@implementation DataTraveller {
    NSArray *provideQuestionArray;
}

@synthesize _score = score_total, _correctAnswer = correctAnswer, _id_question = id_question, _currentQuestionCount = currentQuestionCount;

#pragma mark -
#pragma mark Constructor

-(id) initWithFilePath:(NSString *)fpath {
    
    HISTORY_KEY1 = @"id_question";
    HISTORY_KEY2 = @"answer";
    HISTORY_KEY3 = @"score";
    
    gameHistoryDefaultItem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:  @(0),  HISTORY_KEY1, 0,  HISTORY_KEY2, 0,  HISTORY_KEY3,nil];
    return self;
}

#pragma mark - Methods

-(NSMutableArray*) provideQuestion {
    NSMutableArray<NSString*> *result = [NSMutableArray array];
    
    _questionModel = [QuestionLangService getQuestionForDifficulty:difficulty];
    
    [result addObject:_questionModel.answer1];
    [result addObject:_questionModel.answer2];
    [result addObject:_questionModel.answer3];
    [result addObject:_questionModel.answer4];
    [result addObject:_questionModel.text];
    [_questionModel setUsed];
    provideQuestionArray = result;
    
    correctAnswer = (int)[result indexOfObject:_questionModel.correct_answer] + 1;
    
    NSLog(@"CORRECT ANSWER: 👺👺👺👺👺👺👺👺👺👺👺👺 %@", _questionModel.correct_answer);
    return result;
}

-(BOOL) checkAnswer:(int)answer
{
    NSString *answerString = provideQuestionArray[answer-1];
    
    NSDictionary *params = @{@"answer": answerString, @"difficulty": @(difficulty), @"game_play_id": _gamePlayId, @"question": @(_questionModel.question_id), @"datetime": @(_timestamp)};
    [GameHistoryService createEntityFromDict:params];
    
    lastAnswer = answer;
    return lastAnswer == correctAnswer ? YES : NO;
}
-(NSInteger) getTag{
    return lastAnswer;
}
-(BOOL) finalAnswer
{
    BOOL Return = NO;
    score = 0;
    
    if(lastAnswer == correctAnswer)
    {
        Return = YES;
        difficulty++;
        score_total = [self getMyMoney:currentQuestionCount];
        currentQuestionCount++;
    }
    else
    {
        score_total = [self getFinalMoney:[self getMyMoney:currentQuestionCount - 1]];
    }
    //register current question history
    [gameHistory addObject:[self getQuestionHistoryData]];
    
    return Return;
}

-(void) reset
{
    difficulty = 1;
    currentQuestionCount = 1;
    score_total = 0;
    questions_of_type_count = 0;
    help_used[4] = false;
    help_used[5] = false;
    help_used[6] = false;
    //init history array
    gameHistory = [[NSMutableArray alloc] init];
}

-(Boolean) getHelpAt:(int)i
{
    return help_used[i];
}

-(void) setHelpAt:(int)i value:(Boolean)b
{
    help_used[i] = b;
}



-(void) resetHelp
{
    help_used[0] = false;
    help_used[1] = false;
    help_used[2] = false;
}


#pragma mark - Score Methods

-(NSMutableDictionary*) getQuestionHistoryData
{
    NSMutableDictionary* item = [[NSMutableDictionary alloc] initWithDictionary:gameHistoryDefaultItem];
    [item setValue:[[NSNumber alloc] initWithInt: id_question] forKey: HISTORY_KEY1];
    [item setValue:[[NSNumber alloc] initWithInt: lastAnswer] forKey: HISTORY_KEY2];
    [item setValue:[[NSNumber alloc] initWithInt: score] forKey: HISTORY_KEY3];
    return item;
}

- (NSInteger)getMyMoney:(int)nr{
    switch (nr) {
        case 1:
            return 100;
            break;
        case 2:
            return 200;
            break;
        case 3:
            return 300;
            break;
        case 4:
            return 500;
            break;
        case 5:
            return 1000;
            break;
        case 6:
            return 2000;
            break;
        case 7:
            return 4000;
            break;
        case 8:
            return 8000;
            break;
        case 9:
            return 16000;
            break;
        case 10:
            return 32000;
            break;
        case 11:
            return 64000;
            break;
        case 12:
            return 125000;
            break;
        case 13:
            return 250000;
            break;
        case 14:
            return 500000;
            break;
        case 15:
            return 1000000;
            break;
            
        default:
            break;
    }
    return 0;
}

- (int)getFinalMoney:(int)money{
    if(money < 1000)
        return 0;
    if(money < 32000)
        return 1000;
    if(money < 1000000)
        return 32000;
    return money;
}

-(NSInteger) TimeOut{
    score_total = [self getFinalMoney:[self getMyMoney:currentQuestionCount - 1]];
    return score_total;
}

#pragma mark - Record Methods for MILLIONAIRE

-(void) addRecordWithUserName:(NSString *)name
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:name,[NSNumber numberWithInt:score_total], nil] forKeys:[NSArray arrayWithObjects:@"name",@"score", nil]];
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"score"];
    NSMutableArray *marray = nil;
    if(array){
        marray = [NSMutableArray arrayWithArray:array];
    }else {
        marray = [NSMutableArray array];
    }
    [marray addObject:dict];
    NSSortDescriptor *aSortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSSortDescriptor *aSortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [marray sortUsingDescriptors:[NSArray arrayWithObjects:aSortDescriptor1,aSortDescriptor2,nil]];
    for(int i = 0; i < [marray count];i++ ){
        if(i>19)
            @try {
                [marray removeObjectAtIndex:i];
            }
        @catch (NSException *exception) {
            
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:marray forKey:@"score"];
}

@end
