//
//  XStockKLineModel.swift
//  XStockChart
//
//  Created by xiekunpeng on 2019/7/24.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

import UIKit

class XStockKLineModel: NSObject {

    ///时间戳
    var timeInterval : TimeInterval?;
    ///今开
    var open : String?;
    ///最高
    var high : String?;
    ///最低
    var low : String?;
    ///收盘
    var close : String?;
    ///成交量
    var volume : String?;
    ///换手率
    var turnOver : String?
    ///MA5
    var MA5 : CGFloat?;
    ///MA10
    var MA10 : CGFloat?;
    ///MA20
    var MA20 : CGFloat?;
    ///MA30
    var MA30 : CGFloat?;
    ///MA60
    var MA60 : CGFloat?;
    ///昨收
    var preClose : String?;
    
    
    ///初始化数据封装方法, 根据实际使用情况更改
    init(arr:Array<Any>) {
        super.init();
        if arr.count >= 13 {
            self.timeInterval   = arr[0] as? TimeInterval;
            self.open           = arr[1] as? String;
            self.high           = arr[2] as? String;
            self.low            = arr[3] as? String;
            self.close          = arr[4] as? String;
            self.volume         = arr[5] as? String;
            self.turnOver       = arr[6] as? String;
            self.MA5            = arr[7] as? CGFloat;
            self.MA10           = arr[8] as? CGFloat;
            self.MA20           = arr[9] as? CGFloat;
            self.MA30           = arr[10] as? CGFloat;
            self.MA60           = arr[11] as? CGFloat;
            self.preClose       = arr[12] as? String;
        }
    }
    
    
    
    
}
