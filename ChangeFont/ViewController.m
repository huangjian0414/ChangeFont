//
//  ViewController.m
//  ChangeFont
//
//  Created by huangjian on 2019/10/17.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"
#import <Masonry.h>
#import "UILabel+ChangeFont.h"
#import "FMFontManager.h"
#import "UIFont+Addtion.h"
#import "ChangeFontManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
}
-(void)btnAction:(UIButton *)btn{
    [self presentViewController:[NextViewController new] animated:YES completion:nil];
}

-(void)setUpUI{
    UILabel *label1 = [[UILabel alloc]init];
    label1.backgroundColor = [UIColor lightGrayColor];
    label1.textColor = [UIColor blueColor];
    label1.font = [UIFont my_font:20];
    label1.text = @"这是第一个label";
    [self.view addSubview:label1];
    
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = [UIColor purpleColor];
    label2.backgroundColor = [UIColor lightGrayColor];
    label2.font = [UIFont my_font:20];
    label2.text = @"这是第二个label这是第二个label这是第二个label这是第二个label这是第二个label这是第二个label这是第二个label这是第二个label这是第二个label这是第二个label这是第二个label";
    label2.numberOfLines = 0;
    NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc]initWithString:label2.text];
    label2.attributedText = mutString;
    [self.view addSubview:label2];
    
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(100);
        make.left.mas_offset(40);
        make.right.mas_offset(-40);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label1.mas_bottom).mas_offset(20);
        make.left.right.mas_equalTo(label1);
    }];
    
    UIButton *goNext = [UIButton buttonWithType:UIButtonTypeCustom];
    goNext.backgroundColor = [UIColor greenColor];
    [goNext setTitle:@"去下一个页面" forState:UIControlStateNormal];
    [goNext setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    goNext.titleLabel.font = [UIFont my_font:20];
    [goNext addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goNext];
    
    [goNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_offset(-60);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
}

@end
