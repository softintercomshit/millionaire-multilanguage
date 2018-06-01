//
//  NSString+StringAccess.m
//  Millionaire_rus


#import "NSString+StringAccess.h"

@implementation NSString (StringAccess)

-(int) indexOf:(NSString *)str
{
    for(int i = 0; i <= self.length - str.length; i++)
    {
        BOOL gotIt = YES;
        for(int j = 0; j < str.length; j++)
            if([self characterAtIndex:j + i] != [str characterAtIndex:j])
            {
                gotIt = NO;
                break;
            }
        if(gotIt) return i;
    }
    return -1;
}

-(int) lastIndexOf:(NSString *)str
{
    for(int i = self.length - str.length; i >=0; i--)
    {
        BOOL gotIt = YES;
        for(int j = 0; j < str.length; j++)
            if([self characterAtIndex:j + i] != [str characterAtIndex:j])
            {
                gotIt = NO;
                break;
            }
        if(gotIt) return i;
    }
    return -1;
}

@end
