//
//  XStockContainHandler.swift
//  XStockChart
//  配合XStockContainView使用的数据源工具, 实际使用中网络回来的数据封装后, 跟新到这里;
//  Created by xiekunpeng on 2019/7/24.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

import UIKit

//typealias getChartDataBlock = (_ type:XStockChartType)->();

protocol XStockContainHandlerDelegate {
    func getChartDataSuccess(chartType:XStockChartType, success:Bool) ;
}


class XStockContainHandler: NSObject {
    
    var delegate : XStockContainHandlerDelegate?;
    
    @objc lazy var timeManager: XStockTimeModelRequest = {
        let model = XStockTimeModelRequest();
        return model;
    }()
    
    @objc lazy var kLineManager: XStockKLineModelRequest = {
        let model = XStockKLineModelRequest();
        return model;
    }()
    
    
    
    
    
    
    
    
    
    func getChartData(dataType:XStockGetDataType, showType:XStockChartType)  {
        switch showType {
        case .Time: do {
            getTimeData();
            break;
            }
        case .Five: do {
            getFiveData();
            break;
            }
        case .Day: do {
            getDayData(type: dataType);
            break;
            }
        case .Week: do {
            getWeekData(type: dataType);
            break;
            }
        case .Month: do {
            getMontData(type: dataType);
            break;
            }
        default:
            break;
        }
        
        
        
        
    }
    
    
    
    func getTimeData()  {
        timeManager.getTimeData {[weak self] (success:Bool) in
            self?.delegate?.getChartDataSuccess(chartType: XStockChartType.Time, success: success);
        }
    }
    
    
    
    func getFiveData()  {
        timeManager.getFiveTimeData {[weak self] (success:Bool) in
            self?.delegate?.getChartDataSuccess(chartType: XStockChartType.Five, success: success);
        }
    }
    
    
    func getDayData(type : XStockGetDataType)  {
        kLineManager.getDayData(type: type) {[weak self] (success:Bool) in
            self?.delegate?.getChartDataSuccess(chartType: XStockChartType.Day, success: success);
        }
    }
    
    func getWeekData(type : XStockGetDataType)  {
        kLineManager.getWeekData(type: type) {[weak self] (success:Bool) in
            self?.delegate?.getChartDataSuccess(chartType: XStockChartType.Week, success: success);
        }
    }
    
    
    func getMontData(type : XStockGetDataType)  {
        kLineManager.getMonthData(type: type) {[weak self] (success:Bool) in
            self?.delegate?.getChartDataSuccess(chartType: XStockChartType.Month, success: success);
        }
    }
    
    
    
    
    
}
