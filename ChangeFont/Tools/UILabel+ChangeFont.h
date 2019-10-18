//
//  UILabel+ChangeFont.h
//
//  Created by huangjian on 2019/9/25.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ChangeFont)
//是否主动设置富文本
@property (nonatomic,assign)BOOL isSetAttributedText;//主动赋值
//改变字体
-(void)switchLanguageFont;

@end

NS_ASSUME_NONNULL_END
