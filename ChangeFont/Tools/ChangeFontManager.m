//
//  ChangeFontManager.m
//
//  Created by huangjian on 2019/9/25.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import "ChangeFontManager.h"
#import "UILabel+ChangeFont.h"
@interface  ChangeFontManager ()
@end
@implementation ChangeFontManager

+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    static ChangeFontManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[ChangeFontManager alloc] init];
        manager.controls = [NSMutableDictionary dictionary];
    });
    return manager;
}

-(void)switchLanguageFontCompletionBlock:(void(^)(BOOL success))completionBlock{
    __block NSInteger index = 0;
    [self.controls enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        @autoreleasepool {
            UILabel *label = (UILabel*)obj;
            [label switchLanguageFont];
            if (index == self.controls.allKeys.count-1) {
                if (completionBlock) {
                    completionBlock(YES);
                }
            }
            index++;
        }
    }];
}


-(void)addControls:(UIView*)control{
    NSString *hashKey = [NSString stringWithFormat:@"%ld",control.hash];
    id exist_control = [self.controls objectForKey:hashKey];
    if (!exist_control) {
        [self.controls setObject:control forKey:hashKey];
    }
}

-(void)removeControlWithHash:(NSUInteger)hash
{
    NSString *hasKey = [NSString stringWithFormat:@"%ld",hash];
    id exist_control = [self.controls objectForKey:hasKey];
    if (exist_control) {
        [self.controls removeObjectForKey:hasKey];
    }
}

-(id)fetchControlWithHash:(NSUInteger)hash{
    NSString *hasKey = [NSString stringWithFormat:@"%ld",hash];
    id exist_control = [self.controls objectForKey:hasKey];
    return exist_control;
}



@end
