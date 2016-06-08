//
//  BlackMagic.h
//  hook1
//
//  Created by Sandy wu on 5/20/16.
//
//

#import <Foundation/Foundation.h>

@interface BlackMagic : NSObject

+(void)saveSettingKey:(NSString*)key value:(NSNumber*)value;

+(id)loadSettingValue:(NSString*)key;
@end
