
#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults stringForKey:@"localization"]) {
            NSString * lang = [[NSLocale preferredLanguages] objectAtIndex:0];
            
            if ([lang isEqual: @"ru"] || [lang isEqual: @"de"] || [lang isEqual: @"it"] || [lang isEqual: @"es"])
                [defaults setObject:lang forKey:@"localization"];
            else
                [defaults setObject:@"en" forKey:@"localization"];
            
            [defaults synchronize];
        }
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
