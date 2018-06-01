//
//  DataTraveller.h
//  Millionaire_rus
//


#import <Foundation/Foundation.h>
#import "NSString+StringAccess.h"
#import "QuestionLangService.h"


#define QUESTIONS_MAX 15    //number of quetions
#define SCORE_RECORD_MAX 20 //limit of score registration

@interface DataTraveller : NSObject
{
@private NSString* HISTORY_KEY1;
@private NSString* HISTORY_KEY2;
@private NSString* HISTORY_KEY3;
    
@private int questions_of_type_count;
@private int currentQuestionCount;
@private int id_question;
    
@private int difficulty;
@private int correctAnswer;
@private int lastAnswer;
@private int score;
@private int score_total;
@private Boolean help_used[7];
    
@private NSMutableDictionary* gameHistoryDefaultItem;
@private NSMutableArray* gameHistory;
}

@property (readonly,nonatomic) int _id_question;
@property (readonly,nonatomic) int _correctAnswer;
@property (readwrite,nonatomic) int _score;
@property (readonly,nonatomic) int _timeBonus;
@property (readwrite,nonatomic) int _currentQuestionCount;
@property (readwrite,nonatomic) int _correctAnswerSequence;
@property (strong, nonatomic, readonly) QuestionLang *questionModel;
@property (strong, nonatomic, nonnull) NSString *gamePlayId;
@property (nonatomic) NSTimeInterval timestamp;

-(id) initWithFilePath:(NSString*) fpath;
-(NSMutableArray*) provideQuestion;//four answer + question
-(BOOL) checkAnswer: (int) answer;
-(BOOL) finalAnswer;
-(void) reset;//new game started!

-(Boolean) getHelpAt: (int) i;
-(void) setHelpAt: (int) i value:(Boolean) b;
-(void) resetHelp;
-(NSInteger) TimeOut;
-(NSDictionary*) getQuestionHistoryData;

- (NSInteger)getMyMoney:(int)nr;
- (NSInteger) getTag;

-(void) addRecordWithUserName: (NSString*) name;

@end
