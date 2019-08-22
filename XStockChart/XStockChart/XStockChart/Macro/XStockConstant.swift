//
//  XStockConstant.swift
//  XStockChart
//  常量, 如果要更改图表的显示可以在这里更改数值
//  Created by xiekunpeng on 2019/7/23.
//  Copyright © 2019年 xiekunpeng. All rights reserved.
//

import Foundation
import UIKit





/*-----------------------------------||
||                                   ||
||                                   ||
||----------MARK:分数数据的点数---------||
||                                   ||
||                                   ||
||-----------------------------------*/


/**
 A股分时数据数据点数, 一分钟一个点  上午：9：30----11：30 ，下午13：00——15：00
 数据允许可以多取1个点, 第一个点取昨收价, 放在Y轴上
 */
public let XStock_ATimeChartDataCount : Int = 240 + 1;

/**
 A股五日的点数, 我们的数据源是4分钟一个点, 所以5天(240 / 4) * 5 = 300 个点
 数据允许可以多取5个点, 第一个点取昨收价, 放在Y轴上
 */
public let XStock_AFiveTimeChartDataCount : Int = 300 + 1;

/**
港股分数数据的点数, 一分钟一个点  上午：9：30----12：00 ，下午13：00——16：00
 数据允许可以多取1个点, 第一个点取昨收价, 放在Y轴上
 */
public let XStock_HKTimeChartDataCount : Int = 330 + 1;

/**
 港股五日的点数, 我们的数据源是4分钟一个点, 所以5天(330 / 4) * 5 = 412.5 个点, 实际返回415个点
 数据允许可以多取1个点, 第一个点取昨收价, 放在Y轴上
 */
public let XStock_HKFiveTimeChartDataCount : Int = 415 + 1;


///横屏时默认K线显示数据数量
public let XStock_DefautKLintCount : Int = 100;
///横屏时默认K线显示数据数量
public let XStock_MaxKLineCount : Int = 150;
///横屏时K线最小显示数据数量 (竖屏时, 默认显示这个数量)
public let  XStock_MinKLineCount : Int = 60;





/*-----------------------------------||
||                                   ||
||                                   ||
||---------------MARK:颜色------------||
||                                   ||
||                                   ||
||-----------------------------------*/


///整体背景颜色
public  let XStock_ChartBackColor_Light : UInt32 = 0xffffff;
public  let XStock_ChartBackColor_Dark  : UInt32 = 0x2e2e2e;

///图表中横竖向网格线的颜色
public  let XStock_ChartGridColor_White : UInt32 = 0xe5e5e5;
public  let XStock_ChartGridColor_Dark  : UInt32 = 0xeef3f3;

///主要文字颜色
public let XStock_ChartTextColor_White : UInt32 = 0x333333;
public let XStock_ChartTextColor_Dark  : UInt32 = 0x999999;

///涨跌的颜色相关
public let XStock_RedColor   : UInt32 = 0xfd433f;
public let XStock_GreenColor : UInt32 = 0x1aae60;
public let XStock_GrayColor  : UInt32 = 0x8b8b83;

///标题下方的underLine颜色
public let XStock_ContainViewUnderLineColor : UInt32 = 0xdbdbdb;

///标题按钮选中的颜色
public let XStock_ContainTitleChooseColor : UInt32 = 0x436eee;
///标题按钮未选中的颜色
public let XStock_ContainTitleUnChooseColor : UInt32 = 0x333333;

///分时线的颜色
public let XStock_Time_FiveLineColor : UInt32 = 0x3b2dc9;
///分时线圆圈内的颜色
public let XStock_Time_FiveFillColor : UInt32 = 0x4086d2;
///平均线的颜色
public let XStock_AveLineColor : UInt32 = 0xffa300;
///平均线的颜色圆圈内的颜色
public let XStock_AveFillColor : UInt32 = 0xcece41;


///长按十字交叉线的颜色
public let XStock_CrossCurveColor : UInt32 = 0x999999;

///长按十字线时 时间, 价格, 百分比layer背景色
public  let XStock_CrossInfoBackColor_White : UInt32 = 0x666666;
public  let XStock_CrossInfoBackColor_Dark : UInt32 = 0x111111;






/*-----------------------------------||
||                                   ||
||                                   ||
||----------MARK:其他的一些常量---------||
||                                   ||
||                                   ||
||-----------------------------------*/

///图表中横向网格线数量 图表区域5条, 数量区域2条; 第3条为虚线, 其余实线, 请不要更改这个值;
public let XStock_ChartHorizontalGridCount : Int = 7;
///图表中竖向网格线数量
public let XStock_ChartVerticalGridCount   : Int = 6;
///竖屏状态下图表区域的高度 40titleV+20空隙+chart+20空隙+volumeHeight
public let XStock_ChartHorizontalHeight : CGFloat = 340.0;
///竖屏时成交量View高度 60
public let XStock_VolumePortraitHeight : CGFloat = 60.0;
///竖屏时成交量View高度 100
public let XStock_VolumeLandscapetHeight : CGFloat = 100.0;

///屏幕宽度
public let XScreenWidth : CGFloat = UIScreen.main.bounds.size.width;
///屏幕高度
public let XScreenHeight : CGFloat = UIScreen.main.bounds.size.height;
///图表容器中顶部按钮的高度
public let XStock_ContainViewTitleHeight : CGFloat = 40.0;

///Layer文字显示scale
let  XStockContentScale : CGFloat = UIScreen.main.scale;



















//MARK:Extensions
extension String {
    func getRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
    
    func getNSRange(_ range: Range<String.Index>) -> NSRange {
        guard let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) else {
            return NSMakeRange(0, 0)
        }
        return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from), utf16.distance(from: from, to: to))
    }
}
