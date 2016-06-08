//
//  BlackMagic.m
//  hook1
//
//  Created by Sandy wu on 5/20/16.
//
//
#import "BlackMagic.h"


@implementation BlackMagic

+(void)saveSettingKey:(NSString*)key value:(NSNumber*)value{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    if (!docDir){ return;}
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *path = [docDir stringByAppendingPathComponent:@"HBPluginSettings.txt"];
    [dict setObject:value forKey:key];
    [dict writeToFile:path atomically:YES];
}

+(id)loadSettingValue:(NSString*)key{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    if (!docDir) {
        NSLog(@"docDic 空值");
        return [NSNumber numberWithInt:0];
    }
    
    NSString *path = [docDir stringByAppendingPathComponent:@"HBPluginSettings.txt"]; \
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];\
    if(!dict){
        NSLog(@"docDic 空值");
        return [NSNumber numberWithInt:0];
    }
    NSNumber *number = [dict objectForKey:key]; \
    return number;
}


@end
