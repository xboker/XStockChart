//
//  XStockTimeModelRequest.swift
//  XStockChart
//  实际运用中在这里进行 分时数据XStockTimeModel的封装;
//  Created by xiekunpeng on 2019/7/25.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

import UIKit

typealias TimeGetDataBlock = (_ success:Bool)->();

class XStockTimeModelRequest: NSObject {

    ///分时数据
    @objc var timeChartDataArr    : Array<XStockTimeModel>    = [] {
        willSet {
            print("分时数据数组被赋新值: \(newValue)");
            ///最大最小值分别放大缩小1个百分点, 防止绘制时绘制到顶部;
            self.maxTimePrice = getDigitalFromArr(arr: newValue).maxPrice! * 1.01;
            self.minTimePrice = getDigitalFromArr(arr: newValue).minPirce! * 0.99;
            self.maxTimeVolume = getDigitalFromArr(arr: newValue).maxVolume!;
            self.aveTimePrice = (self.maxTimePrice + self.minTimePrice) / 2.0;
        }
    };
    
    ///五日数据
    @objc var fiveChartDataArr    : Array<XStockTimeModel>    = [] {
        willSet {
            print("五日数据数组被赋新值: \(newValue)");
            ///最大最小值分别放大缩小1个百分点, 防止绘制时绘制到顶部;
            self.maxFivePrice = getDigitalFromArr(arr: newValue).maxPrice! * 1.01;
            self.minFivePrice = getDigitalFromArr(arr: newValue).minPirce! * 0.99;
            self.maxFiveVolume = getDigitalFromArr(arr: newValue).maxVolume!;
            self.aveFivePrice = (self.maxFivePrice + self.minFivePrice) / 2.0;
        }
    };
    
    ///当前分时数组中最大价格
    var maxTimePrice : Float = 0;
    ///当前分时数组中最小价格
    var minTimePrice : Float = 0;
    ///当前分时数组中的均价
    var aveTimePrice : Float = 0;
    ///当前分时数组中的最大成交量
    var maxTimeVolume : Float = 0;
    
    ///当前五日数组中最大价格
    var maxFivePrice : Float = 0;
    ///当前五日数组中最小价格
    var minFivePrice : Float = 0;
    ///当前五日数组中的均价
    var aveFivePrice : Float = 0;
    ///当前五日数组中的最大成交量
    var maxFiveVolume : Float = 0;
    ///回调
    var callB : TimeGetDataBlock?;
    ///五日数据的数据
    var fiveDayStrArr : Array<String> = [];
    
    
    ///获取分时数据----实际使用应该是HTTP请求
    func getTimeData(callB:TimeGetDataBlock)  {
        let path = Bundle.main.path(forResource: "time", ofType: "json");
        let resultData = NSData.init(contentsOfFile: path!);
        if resultData != nil {
            let arr  = try! JSONSerialization.jsonObject(with:resultData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Any>;
            if arr != nil {
                timeChartDataArr.removeAll();
                var tempArr : Array<XStockTimeModel> = [];
                for itemArr in arr! {
                    tempArr.append(XStockTimeModel.init(arr: itemArr as! Array))
                }
                timeChartDataArr.append(contentsOf: tempArr);
                callB(true);
                return;
            }
        }
        timeChartDataArr.removeAll();
        callB(false);
    }
    
    ///获取五日数据----实际使用应该是HTTP请求
    func getFiveTimeData(callB:TimeGetDataBlock)  {
        let path = Bundle.main.path(forResource: "five", ofType: "json");
        let resultData = NSData.init(contentsOfFile: path!);
        if resultData != nil {
            let arr  = try! JSONSerialization.jsonObject(with:resultData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Any>;
            if arr != nil {
                fiveChartDataArr.removeAll();
                fiveDayStrArr.removeAll();
                var tempArr : Array<XStockTimeModel> = [];
                for idx in 0...arr!.count - 1 {
                    let model = XStockTimeModel.init(arr: arr![idx] as! Array);
                    let preModel : XStockTimeModel?;
                    let modelDay = XStockHelper.getTimeStr(interval: model.timeInterval).dayDateStr;
                    if tempArr.count > 0 {
                        preModel = tempArr.last;
                        let preModelDay = XStockHelper.getTimeStr(interval: preModel!.timeInterval).dayDateStr;
                        if modelDay! != preModelDay! {
                            model.broken = true;
                        }
                    }
                    if fiveDayStrArr.contains(modelDay!) == false {
                        fiveDayStrArr.append(modelDay!);
                    }
                    tempArr.append(model);
                }
                fiveChartDataArr.append(contentsOf: tempArr);
                callB(true);
                return;
            }
        }
        fiveChartDataArr.removeAll();
        callB(false);
    }
    
    
    ///从数据中获取一些关键值
    func getDigitalFromArr(arr:Array<XStockTimeModel>) -> (maxPrice:Float?, minPirce:Float?, maxVolume : Float?) {
        var maxN : Float = 0.0;
        var minN : Float = MAXFLOAT;
        var maxV : Float = 0;
        guard arr.count > 0 else {
            return (maxN,min(maxN, minN), maxV);
        }
        var i = 0;
        var j = arr.count - 1;
        while j >= i {
            let iPV = Float(arr[i].price ?? "0");
            let jPV = Float(arr[j].price ?? "0");
            let iVV = Float(arr[i].volume ?? "0");
            let jVV = Float(arr[j].volume ?? "0");
            maxN = max(iPV!, max(jPV!, maxN));
            minN = min(iPV!, min(jPV!, minN));
            maxV = max(iVV!, max(jVV!, maxV));
            i += 1;
            j -= 1;
        }
        return (maxN, minN, maxV);
    }
    
    
    
    
    
    
    
}
