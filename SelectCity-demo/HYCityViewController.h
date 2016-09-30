//
//  HYCityViewController.h
//  SelectCity-demo
//
//  Created by 黄海燕 on 16/9/30.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYCityViewDelegate <NSObject>

- (void)sendCityName:(NSString *)name;

@end

@interface HYCityViewController : UIViewController

@property (nonatomic,weak)id <HYCityViewDelegate> delegate;

@end
