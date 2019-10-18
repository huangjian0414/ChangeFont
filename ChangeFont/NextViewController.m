//
//  NextViewController.m
//  ChangeFont
//
//  Created by huangjian on 2019/10/17.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import "NextViewController.h"
#import <Masonry.h>
#import "FMChooseFontView.h"
#import "ChangeFontManager.h"
#import "UIFont+Addtion.h"
@interface NextViewController ()

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
    
}
-(void)btnAction:(UIButton *)btn{
    if (btn.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (btn.tag == 2){
        [FMChooseFontView showChooseFontViewWith:^(FMChooseFont currentFont, NSInteger tag) {
//            [FMFontManager refreshFontWithView:self.view];
            [[ChangeFontManager shareManager]switchLanguageFontCompletionBlock:^(BOOL success) {

            }];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeFontNotification" object:nil];
        } completion:^(FMChooseFont currentFont, NSInteger tag) {
            if (tag == 1) {
//                [FMFontManager refreshFontWithView:self.view];
                [[ChangeFontManager shareManager]switchLanguageFontCompletionBlock:^(BOOL success) {

                }];
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeFontNotification" object:nil];
            }else if (tag == 2){
                
            }
        }];
    }
}
-(void)setUpUI{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont my_font:20];
    backBtn.backgroundColor = [UIColor greenColor];
    [backBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag =1;
    [self.view addSubview:backBtn];
    
    UIButton *changeFontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeFontBtn setTitle:@"修改字体" forState:UIControlStateNormal];
    [changeFontBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    changeFontBtn.titleLabel.font = [UIFont my_font:20];
    changeFontBtn.backgroundColor = [UIColor greenColor];
    [changeFontBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    changeFontBtn.tag =2;
    [self.view addSubview:changeFontBtn];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.backgroundColor = [UIColor lightGrayColor];
    label1.textColor = [UIColor blueColor];
    label1.numberOfLines = 0;
    label1.font = [UIFont my_font:20];
    label1.text = @"如果我是DJ，你会爱我吗？如果我是DJ，你会爱我吗？如果我是DJ，你会爱我吗？如果我是DJ，你会爱我吗？";
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = [UIColor purpleColor];
    label2.backgroundColor = [UIColor lightGrayColor];
    label2.font = [UIFont my_font:20];
    label2.text = @"我的天啦 这是什么啊我的天啦 这是什么啊我的天啦 这是什么啊我的天啦 这是什么啊我的天啦 这是什么啊我的天啦 这是什么啊我的天啦 这是什么啊我的天啦 这是什么啊我的天啦 这是什么啊我的天啦 这是什么啊";
    label2.numberOfLines = 0;
    [self.view addSubview:label2];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(100);
        make.left.mas_offset(30);
    }];
    [changeFontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-30);
        make.centerY.mas_equalTo(backBtn);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backBtn).mas_offset(50);
        make.left.mas_offset(40);
        make.right.mas_offset(-40);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label1.mas_bottom).mas_offset(20);
        make.left.right.mas_equalTo(label1);
    }];
}

@end
