#import "RestClient.h"
#import "JSONKit.h"
#import "AFNetworking.h"
#import "GameHistory+Serializer.h"
#import "GameHistoryService.h"
#import "AccessLayer.h"


@implementation RestClient

+(void)post:(NSString *)strURL params:(id)params onSucces:(void(^)(id result))onSucces onFail:(void(^)(NSError *error))onFail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:strURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!responseObject) {
            onFail([NSError errorWithDomain:@"milionaire domain" code:-357 userInfo:@{@"info": @"response object is not json"}]);
        }else{
            onSucces(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (onFail) {onFail(error);}
    }];
}

+(void)get:(NSString *)strURL params:(id)params onSucces:(void(^)(id result))onSucces onFail:(void(^)(NSError *error))onFail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:strURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!responseObject) {
            onFail([NSError errorWithDomain:@"milionaire domain" code:-357 userInfo:@{@"info": @"response object is not json"}]);
        }else{
            onSucces(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (onFail) {onFail(error);}
    }];
}

+(void)sendStatistics {
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    NSFetchRequest<GameHistory*> *formatRequest = [GameHistory fetchRequest];
    NSArray<GameHistory *> *games = [context executeFetchRequest:formatRequest error:nil];

    if (games.count) {
        NSMutableArray *params = [NSMutableArray array];

        for (GameHistory *game in games) {
            [params addObject:game.toDict];
        }
        
        NSError *error;
        
        if ([NSJSONSerialization isValidJSONObject:params]) {
            NSData *json = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
            if (!error)
            {
                NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
                
                [manager POST:BASE_URL(@"api/appendbulkstatistics/") parameters:jsonString progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [GameHistoryService clearHistory];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
            }
        }
    }
}

+(void)appCheck:(void(^)(BOOL isOK))complition{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"checked"]) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"miilionaireModeWasChanched"]) {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"miilionaireMode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if (complition) {
            complition(true);
        }
        return;
    }
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *appBundleString = [[NSBundle mainBundle] bundleIdentifier];
    NSString *appVersionString = [info objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleAndVersionString = [appBundleString stringByAppendingString:appVersionString];
    //    bundleAndVersionString = @"test";
    NSString *urlString = [NSString stringWithFormat:@"http://secret.zemralab.com/api/%@/version",bundleAndVersionString];
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([responseString isEqualToString:bundleAndVersionString]) {
            [defaults setBool:true forKey:@"checked"];
            [defaults synchronize];
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"miilionaireModeWasChanched"]) {
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"miilionaireMode"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            if (complition) {
                complition(true);
            }
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"miilionaireMode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (complition) {
                complition(false);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"miilionaireMode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (complition) {
            complition(false);
        }
    }];
}

@end
