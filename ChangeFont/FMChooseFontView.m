//
//  FMChooseFontView.m
//
//  Created by huangjian on 2019/9/25.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import "FMChooseFontView.h"
#import <Masonry.h>
@interface FMChooseFontView ()
@property(nonatomic,strong)UISlider *slider;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,assign)FMChooseFont currentFont;

@property(nonatomic,assign)FMChooseFont oldFont;

@property(nonatomic,copy)ChooseFontResponse state;
@property(nonatomic,copy)ChooseFontResponse completion;

@property(nonatomic,strong)UIView *bgView;
@end
@implementation FMChooseFontView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self setUpUI];
    }
    return self;
}
//MARK: - 点击背景区域消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    point = [self.bgView convertPoint:point fromView:self];
    if (![self.bgView pointInside:point withEvent:event]) {
        [self hiddenChooseFontView];
    }
}

-(void)hiddenChooseFontView{
    [UIView animateWithDuration:0.33 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [self saveFont:self.oldFont];
    !self.completion?:self.completion(self.currentFont,1);
}
//MARK: - 设置默认字体
-(void)setDefaultFont:(FMChooseFont)font{
    [self.slider setValue:font];
    self.currentFont = font;
    [FMFontManager savePreFont:[FMFontManager currentFont] currentFont:font];
}
//MARK: - Action
-(void)clickBtn:(UIButton *)btn{
    [UIView animateWithDuration:0.33 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if (btn.tag == 1) {
        [self saveFont:self.oldFont];
    }
    !self.completion?:self.completion(self.currentFont,btn.tag);

}
//MARK: - 存储选择的字号
-(void)saveFont:(FMChooseFont)font{
    [FMFontManager savePreFont:self.currentFont currentFont:font];
    self.currentFont = font;
}
//MARK: - 滑动slider修改
- (void)valueChanged:(UISlider *)sender
{
    //只取整数值，固定间距
    NSString *tempStr = [self numberFormat:sender.value];
    if (tempStr.floatValue ==sender.value) {
        return;
    }
    [sender setValue:tempStr.integerValue];
    if (tempStr.integerValue != self.currentFont) {
        [self saveFont:tempStr.integerValue];
        !self.state?:self.state(self.currentFont,0);
    }
}
//MARK: - 点击slider修改
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    //取得点击点
    CGPoint p = [sender locationInView:sender.view];
    //计算处于背景图的几分之几，并将之转换为滑块的值（1~4）
    float tempFloat = (p.x-15 ) / (_slider.frame.size.width-30) * 3 + 1;
    NSString *tempStr = [self numberFormat:tempFloat];
    [_slider setValue:tempStr.floatValue];
    if (tempStr.integerValue != self.currentFont) {
        [self saveFont:tempStr.integerValue];
        !self.state?:self.state(self.currentFont,0);
    }
}
//MARK: - Slider Action
- (void)sliderTouchDown:(UISlider *)sender {
    self.tap.enabled = NO;
}

- (void)sliderTouchUp:(UISlider *)sender {
    self.tap.enabled = YES;
}
- (NSString *)numberFormat:(float)num
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0"];
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
}
//MARK: - UI
-(void)setUpUI{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    self.bgView = bgView;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelBtn.tag = 1;
    [cancelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    UIButton *conformBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [conformBtn setTitle:@"完成" forState:UIControlStateNormal];
    [conformBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    conformBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    conformBtn.tag = 2;
    [conformBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:conformBtn];
    
    UIImageView *sliderBgImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_detail_sliderBgImg"]];
    [bgView addSubview:sliderBgImgView];
    
    UISlider *slider = [[UISlider alloc] init];
    slider.minimumValue = 1;
    slider.maximumValue = 4;
    slider.minimumTrackTintColor = [UIColor clearColor];
    slider.maximumTrackTintColor = [UIColor clearColor];
    slider.multipleTouchEnabled = NO;
    [slider setThumbImage:[UIImage imageNamed:@"icon_detail_slider_thum"] forState:UIControlStateNormal];
    [bgView addSubview:slider];
    self.slider = slider;
    
    NSString *font = [[NSUserDefaults standardUserDefaults]objectForKey:kLocalTextFont];
    self.currentFont = [font integerValue];
    self.oldFont = [font integerValue];
    
    [slider setValue:self.currentFont];
    
    [slider addTarget:self
                action:@selector(valueChanged:)
      forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self
                action:@selector(sliderTouchDown:)
      forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self
                action:@selector(sliderTouchUp:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [slider addGestureRecognizer:tap];
    self.tap = tap;
    
    UILabel *smallLabel = [[UILabel alloc]init];
    smallLabel.font = [UIFont systemFontOfSize:14];
    smallLabel.textColor = [UIColor lightGrayColor];
    smallLabel.text = @"A";
    [bgView addSubview:smallLabel];
    
    UILabel *normalLabel = [[UILabel alloc]init];
    normalLabel.font = [UIFont systemFontOfSize:16];
    normalLabel.textColor = [UIColor lightGrayColor];
    normalLabel.text = @"标准";
    [bgView addSubview:normalLabel];
    
    UILabel *bigLabel = [[UILabel alloc]init];
    bigLabel.font = [UIFont systemFontOfSize:20];
    bigLabel.textColor = [UIColor lightGrayColor];
    bigLabel.text = @"A";
    [bgView addSubview:bigLabel];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(128+20);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_offset(10);
    }];
    [conformBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-15);
        make.centerY.mas_equalTo(cancelBtn);
    }];
    [sliderBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.bottom.mas_offset(-(20+20));
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(10);
    }];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(sliderBgImgView);
        make.height.mas_equalTo(sliderBgImgView);
        make.width.mas_equalTo(330);
    }];
    [smallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(sliderBgImgView.mas_top).mas_offset(-20);
        make.centerX.mas_equalTo(sliderBgImgView.mas_left);
    }];
    [normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(smallLabel);
        make.centerX.mas_equalTo(sliderBgImgView.mas_left).mas_offset(100);
    }];
    [bigLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(normalLabel);
        make.centerX.mas_equalTo(sliderBgImgView.mas_right);
    }];
}

+(void)showChooseFontViewWith:(ChooseFontResponse)state completion:(ChooseFontResponse)completion{
    FMChooseFontView *v = [[FMChooseFontView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    v.state = state;
    v.completion = completion;
    [[UIApplication sharedApplication].keyWindow addSubview:v];
}
@end
