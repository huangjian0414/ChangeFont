//
//  FMChooseFontView.h
//
//  Created by huangjian on 2019/9/25.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMFontManager.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^ChooseFontResponse)(FMChooseFont currentFont,NSInteger tag);
@interface FMChooseFontView : UIView
//选中默认字号
-(void)setDefaultFont:(FMChooseFont)font;

+(void)showChooseFontViewWith:(ChooseFontResponse)state completion:(ChooseFontResponse)completion;
@end

NS_ASSUME_NONNULL_END
