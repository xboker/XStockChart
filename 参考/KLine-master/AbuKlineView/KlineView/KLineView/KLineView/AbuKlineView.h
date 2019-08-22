//
//  AbuKlineView.h
//  AbuKlineView
//
//  Created by Jefferson.zhang on 2017/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AbuKlineView : UIView


@property (nonatomic,strong) NSMutableArray<__kindof KLineModel*> *dataArray;

- (void)refreshFSKlineView:(KLineModel *)model;

@end
