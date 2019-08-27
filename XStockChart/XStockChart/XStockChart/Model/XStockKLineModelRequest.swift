//
//  XStockKLineModelRequest.swift
//  XStockChart
//  实际运用中在这里进行 K线数据XStockKLineModel的封装;
//  Created by xiekunpeng on 2019/7/25.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

import UIKit

typealias KLineGetDataBlock = (_ success:Bool)->();


class XStockKLineModelRequest: NSObject {

    ///日K数据, 所有
    @objc var dayKChartDataArr    : Array<XStockKLineModel>   = [];
    ///周K数据, 所有
    @objc var weekKChartDataArr   : Array<XStockKLineModel>   = [];
    ///月K数据, 所有
    @objc var monthKChartDataArr  : Array<XStockKLineModel>   = [];
    
    ///最后一根蜡烛数据在数组中倒序所在位置
    var lastPoint = 0;
    ///实际在屏幕中显示的蜡烛数
    var showItemCount : Int?;
    ///指标线位置显示内容, 默认显示成交量
    var idxShowType = XStockIndexType.Volume;
    
    
    override init() {
        super.init();
        if XStockHelper.getScreenDeriction() == .LandscapeScreen {
            self.showItemCount = XStock_DefautKLintCount;
        }else {
            self.showItemCount = XStock_MinKLineCount;
        }
    }
    
    ///获取日K数据
    func getDayData(type:XStockGetDataType, callB:TimeGetDataBlock)  {
        if  type == .Default && dayKChartDataArr.count > 0 {
            lastPoint = dayKChartDataArr.count - 1;
            callB(true);
            return;
        }
        let path = Bundle.main.path(forResource: "day", ofType: "json");
        let resultData = NSData.init(contentsOfFile: path!);
        if resultData != nil {
            let arr  = try! JSONSerialization.jsonObject(with:resultData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Any>;
            if arr != nil {
                if type == .Default {
                    dayKChartDataArr.removeAll();
                    for itemArr in arr! {
                        dayKChartDataArr.append(XStockKLineModel.init(arr: itemArr as! Array))
                    }
                    lastPoint = dayKChartDataArr.count - 1;
                }else {
                    
                }
                callB(true);
                return;
            }
        }
        dayKChartDataArr.removeAll();
        callB(false);
    }
    
    ///获取周K数据
    func getWeekData(type:XStockGetDataType, callB:TimeGetDataBlock)  {
        if  type == .Default && weekKChartDataArr.count > 0 {
            lastPoint = weekKChartDataArr.count - 1;
            callB(true);
            return;
        }
        let path = Bundle.main.path(forResource: "week", ofType: "json");
        let resultData = NSData.init(contentsOfFile: path!);
        if resultData != nil {
            let arr  = try! JSONSerialization.jsonObject(with:resultData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Any>;
            if arr != nil {
                if type == .Default {
                    weekKChartDataArr.removeAll();
                    for itemArr in arr! {
                        weekKChartDataArr.append(XStockKLineModel.init(arr: itemArr as! Array))
                    }
                    lastPoint = weekKChartDataArr.count - 1;
                }else {
                    
                }
                callB(true);
                return;
            }
        }
        weekKChartDataArr.removeAll();
        callB(false);
    }
    
    ///获取月K数据
    func getMonthData(type:XStockGetDataType, callB:TimeGetDataBlock)  {
        if  type == .Default && monthKChartDataArr.count > 0 {
            lastPoint = monthKChartDataArr.count - 1;
            callB(true);
            return;
        }
        let path = Bundle.main.path(forResource: "month", ofType: "json");
        let resultData = NSData.init(contentsOfFile: path!);
        if resultData != nil {
            let arr  = try! JSONSerialization.jsonObject(with:resultData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Any>;
            if arr != nil {
                if type == .Default {
                    monthKChartDataArr.removeAll();
                    for itemArr in arr! {
                        monthKChartDataArr.append(XStockKLineModel.init(arr: itemArr as! Array))
                    }
                    lastPoint = monthKChartDataArr.count - 1;
                }else {
                    
                }
                callB(true);
                return;
            }
        }
        monthKChartDataArr.removeAll();
        callB(false);
    }
    
   
    
}
