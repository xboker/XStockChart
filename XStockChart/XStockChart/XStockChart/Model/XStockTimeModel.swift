//
//  XStockTimeModel.swift
//  XStockChart
//  分时数据模型
//  Created by xiekunpeng on 2019/7/23.
//  Copyright © 2019年 xiekunpeng. All rights reserved.
//

import UIKit

class XStockTimeModel: NSObject {

    ///时间戳
    var timeInterval : TimeInterval?;
    ///现价
    var price : String?;
    ///均价
    var avePrice : String?;
    ///成交量
    var volume : String?;
    ///是否链接, 多个点之间是否是连线的,默认是一条线, 当是5日数据是每天最后一个点和下一天的第一个点, 不连接;
    var broken = false;
    
    
    var timeStr : String {
        get {
            if  timeInterval == nil {
                return "";
            }
            return XStockHelper.getTimeStr(interval: timeInterval!).timeDateStr!;
        }
    }
    
    var monthStr : String {
        get {
            if  timeInterval == nil {
                return "";
            }
            return XStockHelper.getTimeStr(interval: timeInterval!).dayDateStr!;
        }
    }
    
    var yearStr : String {
        get {
            if  timeInterval == nil {
                return "";
            }
            return XStockHelper.getTimeStr(interval: timeInterval!).monthDateStr!;
        }
    }
    
    var fullStr : String {
        get {
            if  timeInterval == nil {
                return "";
            }
            return XStockHelper.getTimeStr(interval: timeInterval!).fullDateStr!;
        }
    }
    
    
    ///初始化方法根据实际情况进行更改封装;
    init(arr:Array<Any>) {
        super.init();
        if arr.count >= 4 {
            self.timeInterval   = (arr[0] as! TimeInterval);
            self.price          = (arr[1] as! String);
            self.avePrice       = (arr[2] as! String);
            self.volume         = (arr[3] as! String);
        }
    }
    
    
    
}
