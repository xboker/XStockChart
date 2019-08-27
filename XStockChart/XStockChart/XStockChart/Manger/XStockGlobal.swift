//
//  XStockGlobal.swift
//  XStockChart
//  关于图表显示的整体设置
//  Created by xiekunpeng on 2019/7/24.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

import UIKit

fileprivate var model = XStockGlobal();


class XStockGlobal: NSObject {
    //MARK:Private
    fileprivate override init() {
    }
    
    @objc class var share: XStockGlobal {
        return model;
    }

    override func copy() -> Any {
        return model;
    }
    
    override func mutableCopy() -> Any {
        return model;
    }
    
    
    
    //MARK: GlobalSetting
    ///当前颜色主题
    public var globalColorType : XStockColorType = .Light;
    ///涨红跌绿  或者 涨绿跌红
    public var upDownColorType : XStockUpDownColorType = .UpRedDownGreen;
    ///需要展示的图标列表, 例如下面: 依次显示分时, 五日, 日K, 周K, 月K
    public var chartShowTypeArr : Array<XStockChartType> = [.Time, .Five, .Day, .Week, .Month];
    ///需要展示的图标列表对应的标题, 一定要跟上面数组对应
    public var chartShowTitleArr : Array<String> = ["分时", "五日", "日K", "周K", "月K"];
    ///长按图表时出现的提示信息view, 默认在左右出现--------后续删掉
    public var infoBarType : XStockLongPressInfoType = .SideBar;
    ///默认情况下竖屏时不显示成交量的描述
    public var alwaysShowVolumeDes : Bool = true;
    ///K线图的柱子类型 实心或者空心
    public var kLineColumeType = XStockKLineColumeType.Solid;
    
    ///实际的成交量视图的高度
    public var volumeHeihgt : CGFloat {
        get {
            if XStockHelper.getScreenDeriction() == .LandscapeScreen {
                return XStock_VolumeLandscapetHeight;
            }else {
                return XStock_VolumePortraitHeight;
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:formatter
    lazy var dateFomatter: DateFormatter = {
        let fmt = DateFormatter.init();
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        fmt.timeZone = TimeZone.init(secondsFromGMT: 8 * 3600);
        return fmt;
    }()
    
    
    lazy var calendar: Calendar = {
        let c = Calendar.current;
        return c;
    }()
    
    
    
    
}
