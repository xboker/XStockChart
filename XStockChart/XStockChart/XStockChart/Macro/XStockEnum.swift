//
//  XStockEnum.swift
//  XStockChart
//  枚举值
//  Created by xiekunpeng on 2019/7/24.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

import Foundation
import UIKit



@objc enum XStockChartType : Int {
    ///分时
    case Time  = 1000
    ///五日
    case Five  = 1001
    ///日K
    case Day   = 1002
    ///周K
    case Week  = 1003
    ///月K
    case Month = 1004
}


@objc enum XStockIndexType : Int {
    ///成交量
    case Volume
    ///指标MACD
    case MACD = 2000
    ///指标KDJ
    case KDJ  = 2001
    ///指标RSI
    case RSI  = 2003
    ///指标BOLL
    case BOLL = 2004
}


@objc enum XStockColorType : Int {
    ///Light颜色主题
    case Light = 3000
    ///Dark颜色主题
    case Dark  = 3001
}


@objc enum XStockUpDownColorType : Int    {
    ///涨红跌绿
    case UpRedDownGreen = 3010
    ///涨绿跌红
    case UpGreenDownRed = 3011
}



@objc enum XStockScreenDirectionType : Int {
    ///横屏
    case LandscapeScreen = 3020
    ///竖屏
    case PortraitScreen  = 3021
}


@objc enum XStockGetDataType : Int {
    ///默认或刷新
    case Default = 3030
    ///获取更多
    case More    = 3031
}




@objc enum XStockLongPressInfoType : Int {
    ///长按图表时提示信息; 在上方出现横向的bar显示
    case UpBar   = 3040
    ///长按图表时提示信息; 在左/右侧出现方形的bar显示
    case SideBar = 3041
}




@objc enum XStockType : Int {
    ///港股
    case HK  = 3050
    ///沪深
    case HS  = 3051
    ///美股
    case US  = 3052
    ///指数
    case IDX = 3053
}




@objc enum XStockKLineColumeType : Int {
    ///空心蜡烛图
    case Hollow = 3060
    ///实心蜡烛图
    case Solid  = 3061
}

















