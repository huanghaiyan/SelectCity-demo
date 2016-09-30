//
//  HYCityViewController.m
//  SelectCity-demo
//
//  Created by 黄海燕 on 16/9/30.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "HYCityViewController.h"

#define kScreen_width [UIScreen mainScreen].bounds.size.width
#define kScreen_height [UIScreen mainScreen].bounds.size.height

@interface HYCityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *cityTableView;

/**
 *  当前城市数据源
 */
@property (nonatomic,strong) NSMutableArray *dataSourceArr;

/**
 *  索引数据源
 */
@property (nonatomic,strong) NSMutableArray *indexSourceArr;

@end

@implementation HYCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNav];
    [self initDataSource];
    [self initTableView];
}

- (void)initNav
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 64)];
    bgView.backgroundColor = [UIColor colorWithRed:241/255.0f green:241/255.0f  blue:241/255.0f  alpha:1.0f];
    [self.view addSubview:bgView];
    
    //取消按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(20, 30, 20, 20);
    [closeBtn setImage:[UIImage imageNamed:@"icon_nav_quxiao_normal"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_width/2-50, 30, 100, 25)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = @"选择城市";
    [bgView addSubview:titleLabel];
}

-(void)initTableView
{
    self.cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height - 64) style:UITableViewStylePlain];
    self.cityTableView.dataSource = self;
    self.cityTableView.delegate = self;
    self.cityTableView.sectionIndexColor = [UIColor colorWithRed:252/255.0f green:74/255.0f blue:132/255.0f alpha:1.0f];
    [self.view addSubview:self.cityTableView];
}

-(void)initDataSource
{
    self.dataSourceArr = [[NSMutableArray alloc]init];
    self.indexSourceArr = [[NSMutableArray alloc]init];
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist"];
    NSMutableArray *cityArr = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    _dataSourceArr = [self sortArray:cityArr];
}



- (NSMutableArray *)sortArray:(NSMutableArray *)originalArray
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    //根据拼音对数组排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES]];
    //排序
    [originalArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *tempArray = nil;
    BOOL flag = NO;
    
    //分组
    for (int i = 0;i < originalArray.count; i++) {
        NSString *pinyin = [originalArray[i] objectForKey:@"pinyin"];
        NSString *firstChar = [pinyin substringToIndex:1];
        if (![_indexSourceArr containsObject:[firstChar uppercaseString]]) {
            [_indexSourceArr addObject:[firstChar uppercaseString]];
            tempArray = [[NSMutableArray alloc]init];
            flag = NO;
        }
        if ([_indexSourceArr containsObject:[firstChar uppercaseString]]) {
            [tempArray addObject:originalArray[i]];
            if (flag == NO) {
                [array addObject:tempArray];
                flag = YES;
            }
        }
    }
    return array;
}

#pragma mark dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSourceArr[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_indexSourceArr objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexSourceArr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.textLabel.text = [[self.dataSourceArr[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate != nil) {
        [self.delegate sendCityName:[[self.dataSourceArr[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"]];
         [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)closeBtn:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
