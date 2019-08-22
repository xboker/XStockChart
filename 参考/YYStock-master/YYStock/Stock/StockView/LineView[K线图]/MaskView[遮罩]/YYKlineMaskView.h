//
//  YYKlineMaskView.h
//  YYStock  ( https://github.com/WillkYang )
//
//  Created by WillkYang on 16/10/9.
//  Copyright © 2016年 WillkYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYStockDataProtocol.h"
#import "YYLinePositionModel.h"
@interface YYKlineMaskView : UIView

//当前长按选中的model
@property (nonatomic, strong) id<YYLineDataModelProtocol> selectedModel;

//当前长按选中的位置model
@property (nonatomic, strong) YYLinePositionModel *selectedPositionModel;

//当前的滑动scrollview
@property (nonatomic, strong) UIScrollView *stockScrollView;

@end
