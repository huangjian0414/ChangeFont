//
//  UILabel+ChangeFont.m
//
//  Created by huangjian on 2019/9/25.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import "UILabel+ChangeFont.h"
#import "ChangeFontManager.h"
#import <objc/runtime.h>
#import "FMFontManager.h"

static NSString *nameKey = @"IsSetAttributedText";

@implementation UILabel (ChangeFont)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelectorDidAppear = @selector(didMoveToSuperview);
        SEL swizzledSelectorDidAppear = @selector(fm_didMoveToSuperview);
        
        [self swapMethodWithOriginalMethod:originalSelectorDidAppear swizzledMethod:swizzledSelectorDidAppear];
        
        
        SEL originalSelectorSetAttr = @selector(setAttributedText:);
        SEL swizzledSelectorSetAttr = @selector(fm_setAttributedText:);
        
        [self swapMethodWithOriginalMethod:originalSelectorSetAttr swizzledMethod:swizzledSelectorSetAttr];

        SEL originalSelectorRemove = @selector(removeFromSuperview);
        SEL swizzledSelectorRemove = @selector(fm_removeFromSuperview);
        
        [self swapMethodWithOriginalMethod:originalSelectorRemove swizzledMethod:swizzledSelectorRemove];
    });
}


+(void)swapMethodWithOriginalMethod:(SEL)originalSel swizzledMethod:(SEL)swizzledSel{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSel);
    
    BOOL willAddMethod =
    class_addMethod(class,
                    originalSel,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (willAddMethod) {
        class_replaceMethod(class,
                            swizzledSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


-(void)fm_setAttributedText:(NSAttributedString *)attributedText{
    [self fm_setAttributedText:attributedText];
    self.isSetAttributedText = attributedText != nil;
}
//MARK: - 改变字体
-(void)switchLanguageFont{

    if (self.isSetAttributedText) {
        NSRange range1 = NSMakeRange(0, self.attributedText.string.length);
        NSMutableAttributedString *mutString = [self.attributedText mutableCopy];
        [mutString enumerateAttribute:NSFontAttributeName
                              inRange:range1
                              options:(NSAttributedStringEnumerationReverse) usingBlock:^(UIFont *value, NSRange range, BOOL * _Nonnull stop){
                                  if (value) {
                                      *stop = YES;
                                      [mutString addAttribute:NSFontAttributeName value:[self getNewFontWithOld:value] range:range];
                                      
                                  }else{
                                      [mutString addAttribute:NSFontAttributeName value:[self getNewFontWithOld:self.font] range:range];
                                  }
                              }];
        self.attributedText = mutString;
        
    }else{
        self.font = [self getNewFontWithOld:self.font];
    }
}
//MARK: - 通过老font 获取新font
-(UIFont *)getNewFontWithOld:(UIFont *)font{
    NSString *preFont = [[NSUserDefaults standardUserDefaults]objectForKey:kPreLocalTextFont];
    NSString *currentFont = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalTextFont];
    
    UIFont *oldFont = font;
    CGFloat newfontSize = oldFont.pointSize + [currentFont integerValue] - [preFont integerValue];
    NSString *fontName = oldFont.fontName;
    
    return [UIFont fontWithName:fontName size:newfontSize];
}


-(void)fm_didMoveToSuperview{
    [self fm_didMoveToSuperview];
    [[ChangeFontManager shareManager] addControls:self];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFontNotification:) name:@"ChangeFontNotification" object:nil];
}
-(void)fm_removeFromSuperview{
    [self fm_removeFromSuperview];
    [[ChangeFontManager shareManager]removeControlWithHash:self.hash];

}
//MARK: - 通知的方式
-(void)changeFontNotification:(NSNotification *)noti{
    [self switchLanguageFont];
}

//MARK: - isSetAttributedText
-(void)setIsSetAttributedText:(BOOL)isSetAttributedText
{
    objc_setAssociatedObject(self, &nameKey, @(isSetAttributedText), OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)isSetAttributedText
{
    return [objc_getAssociatedObject(self, &nameKey) boolValue];
}
@end
