//
//  FMFontManager.m
//
//  Created by huangjian on 2019/9/29.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import "FMFontManager.h"
#import "UILabel+ChangeFont.h"

NSString *const kLocalTextFont = @"kLocalTextFont";
NSString *const kPreLocalTextFont = @"kPreLocalTextFont";


@implementation FMFontManager
//MARK: - 检测默认字体
+(void)checkDefaultFont{
    //设置默认的字号
    if (![[NSUserDefaults standardUserDefaults]objectForKey:kPreLocalTextFont]) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",2] forKey:kPreLocalTextFont];
    }
    if (![[NSUserDefaults standardUserDefaults]objectForKey:kLocalTextFont]) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",2] forKey:kLocalTextFont];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//MARK: - 切换字体刷新单个界面
+(void)refreshFontWithView:(UIView *)view{
    [self TraverseAllSubviews:view];
}
+(void)TraverseAllSubviews:(UIView *)v{
    
    NSString *preFont = [[NSUserDefaults standardUserDefaults]objectForKey:kPreLocalTextFont];
    NSString *currentFont = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalTextFont];
    for (UIView *subView in v.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            UIFont *oldFont = label.font;
            CGFloat fontSize = oldFont.pointSize + [currentFont integerValue] - [preFont integerValue];
            NSString *fontName = label.font.fontName;
            label.font = [UIFont fontWithName:fontName size:fontSize];
            NSLog(@"UILabel %@-- %@",subView,label.text);
        }
        if (subView.subviews.count) {
            [self TraverseAllSubviews:subView];
        }
    }
    
}
//MARK: - 保存上一次和当前选择的字体
+(void)savePreFont:(FMChooseFont)preFont currentFont:(FMChooseFont)currentFont{
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",preFont] forKey:kPreLocalTextFont];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",currentFont] forKey:kLocalTextFont];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
//MARK: - 当前字体
+(FMChooseFont)currentFont{
    return [[[NSUserDefaults standardUserDefaults]objectForKey:kLocalTextFont]integerValue];
}
@end
