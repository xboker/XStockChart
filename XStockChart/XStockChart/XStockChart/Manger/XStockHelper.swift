//
//  XStockHelper.swift
//  XStockChart
//  通用的方法设置
//  Created by xiekunpeng on 2019/7/24.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

import UIKit

class XStockHelper: NSObject {

    class func getScreenDeriction() -> XStockScreenDirectionType {
        if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeLeft || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeRight  {
            return .LandscapeScreen;
        }
        return .PortraitScreen;
    }
    
    
    
    class func getStkType(stkCode:String!) -> XStockType {
        if stkCode.uppercased().hasSuffix(String(".HK")) {
            return .HK;
        }
        if stkCode.uppercased().hasSuffix(String("US")) {
            return .US;
        }
        if stkCode.uppercased().hasSuffix(String("SH")) ||  stkCode.uppercased().hasSuffix(String("SZ")) {
            return .HS;
        }
        return .IDX;
    }

    ///特殊case: 港股价格:3位小数  沪深价格:2位小数  美股价格:>=1两位小数 <14位小数
    class func getFormatNumStr(num:CGFloat?, dotCount:UInt8!) -> String {
        if num == nil {
            return "0.00";
        }
        let formatStr = "%."+String(dotCount)+"f";
        let str = String(format: formatStr, num!);
        return str;  
    }
    
    
    ///string? 转成CGFloat,如果不合规则或者转换失败返回0.00;
    class func getCGFloat(str : String?) -> CGFloat {
        guard str != nil else {
            return 0.00;
        }
        let strF = Float(str!);
        return CGFloat(strF ?? 0.00);
    }
    
    
    
    /// 获取分时, 五日, 日K, 周K, 月K中一个价格在坐标系中相对左上角的Y向偏移量
    ///
    ///   - Parameters:
    ///   - price: 价格
    ///   - minPrice: 最低价
    ///   - maxPrice: 最高价
    ///   - height: 最低--最高价之间的距离
    /// - Returns: 实际的偏移量
    class func getOffsetY(price:CGFloat, minPrice:CGFloat, maxPrice:CGFloat, height:CGFloat) -> CGFloat {
        let pct = (maxPrice - price) / (maxPrice - minPrice);
        return height * pct;
    }
    
    
    
    class func getTimeStr(interval:TimeInterval?) -> (timeDateStr:String?, dayDateStr:String?, monthDateStr:String?, fullDateStr:String?) {
        if interval == nil {
            return ("", "", "", "");
        }
        let realInterval : TimeInterval = formatterInterval(interval: interval);
        var timeS : String = "";
        var monthS : String = "";
        var yearS : String = "";
        var fullS : String = "";
        let date = Date.init(timeIntervalSince1970: realInterval);
        let fmt = XStockGlobal.share.dateFomatter;
        fmt.dateFormat = "yyyy/MM/dd EEE";
        fullS = fmt.string(from: date);
        fmt.dateFormat = "HH:mm";
        timeS = fmt.string(from: date);
        fmt.dateFormat = "MM-dd";
        monthS = fmt.string(from: date);
        fmt.dateFormat = "yyyy-MM";
        yearS = fmt.string(from: date);
        return (timeS, monthS, yearS, fullS);
    }
    
    
    
    class func isSameDay(interval1:TimeInterval? , interval2:TimeInterval?) -> Bool {
        guard interval1 != nil && interval2 != nil else {
            return false;
        }
        let date1 = Date.init(timeIntervalSince1970: formatterInterval(interval: interval1));
        let date2 = Date.init(timeIntervalSince1970: formatterInterval(interval: interval2));
        let isSameDay = XStockGlobal.share.calendar.isDate(date1, equalTo: date2, toGranularity: Calendar.Component.day);
        return isSameDay;
        
    }
    
    class func formatterInterval(interval:TimeInterval?) -> TimeInterval! {
        if interval == nil {
            return 0;
        }
        var realInterval : TimeInterval = 0.0;
        if String(Int(interval!)).count == 10 {
            realInterval = interval!;
        }else if String(Int(interval!)).count == 13 {
            realInterval = interval! / 1000.0;
        }else {
            realInterval = interval!;
        }
        return realInterval;
    }
    
    
    
    
    
    class func getStrSize(str:String?, fontSize:CGFloat) -> CGSize {
        if str == nil {
            return CGSize.zero;
        }
        return str!.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size;
    }
    
    
    
}
