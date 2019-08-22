//
//  YYVolumePositionModel.h
//  YYStock  ( https://github.com/WillkYang )
//
//  Created by WillkYang on 16/10/5.
//  Copyright © 2016年 WillkYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface YYVolumePositionModel : NSObject
/**
 *  开始点
 */
@property (nonatomic, assign) CGPoint StartPoint;

/**
 *  结束点
 */
@property (nonatomic, assign) CGPoint EndPoint;

/**
 *  日期
 */
@property (nonatomic, copy) NSString *DayDesc;

/**
 *  工厂方法
 */
+ (instancetype) modelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint dayDesc:(NSString *)dayDesc;
@end
