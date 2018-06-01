#import <Foundation/Foundation.h>

#define BASE_URL(path) [NSString stringWithFormat:@"http://localhost:8000/%@", path]

@interface RestClient : NSObject

+(void)post:(NSString *)strURL params:(id)params onSucces:(void(^)(id result))onSucces onFail:(void(^)(NSError *error))onFail;
+(void)get:(NSString *)strURL params:(id)params onSucces:(void(^)(id result))onSucces onFail:(void(^)(NSError *error))onFail;
+(void)appCheck:(void(^)(BOOL isOK))complition;
+(void)sendStatistics;

@end
