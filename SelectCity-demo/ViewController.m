//
//  ViewController.m
//  SelectCity-demo
//
//  Created by 黄海燕 on 16/9/30.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "ViewController.h"
#import "HYCityViewController.h"
@interface ViewController ()<HYCityViewDelegate>

@property (nonatomic,strong) UIBarButtonItem *leftBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(selectCity)];
    [_leftBtn setTintColor:[UIColor colorWithRed:252/255.0f green:74/255.0f blue:132/255.0f alpha:1.0f]];
    self.navigationItem.leftBarButtonItem = _leftBtn;
    
}

- (void)selectCity{
    HYCityViewController *cityVC = [[HYCityViewController alloc]init];
    cityVC.delegate = self;
    [self presentViewController:cityVC animated:YES completion:nil];
}

- (void)sendCityName:(NSString *)name{
    [_leftBtn setTitle:name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
