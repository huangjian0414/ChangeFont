//
//  ChangeFontManager.h
//
//  Created by huangjian on 2019/9/25.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ChangeFontManager : NSObject
+(instancetype)shareManager;
@property(nonatomic,strong)NSMutableDictionary *controls;

//添加控件
-(void)addControls:(UIView*)control;
//删除控件
-(void)removeControlWithHash:(NSUInteger)hash;
//获取控件
-(id)fetchControlWithHash:(NSUInteger)hash;

//修改存储所有控件的字体
-(void)switchLanguageFontCompletionBlock:(void(^)(BOOL success))completionBlock;
@end

NS_ASSUME_NONNULL_END
