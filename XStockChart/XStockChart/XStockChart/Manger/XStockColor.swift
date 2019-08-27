//
//  XStockColor.swift
//  XStockChart
//  颜色工具, 把需要换肤功能的颜色在这里添加, 其余的根据喜好
//  Created by xiekunpeng on 2019/7/24.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

import UIKit

class XStockColor: NSObject {

    //MARK:Private
    class func getColor(hex:UInt32) -> UIColor {
        return getColor(hex: hex, alpha: 1.0);
    }
    
    class func getColor(hex:UInt32, alpha:CGFloat) -> UIColor {
        let r = (hex >> 16) & 0xFF;
        let g = (hex >> 8) & 0xFF;
        let b = (hex) & 0xFF;
        return UIColor.init(red: CGFloat(r) / 255.0, green:  CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha);
    }
    

    //MARK:Public
    
    ///整体背景色
    class func xStock_BackColor() -> UIColor {
        if XStockGlobal.share.globalColorType == .Light {
            return getColor(hex: XStock_ChartBackColor_Light, alpha: 1);
        }
        return getColor(hex: XStock_ChartBackColor_Dark, alpha: 0.8);
    }
    
    ///网格线颜色
    class func xStock_GridColor() -> UIColor {
        if XStockGlobal.share.globalColorType == .Light {
            return getColor(hex: XStock_ChartGridColor_White, alpha: 0.6);
        }
        return getColor(hex: XStock_ChartGridColor_Dark, alpha: 0.5);
    }
    
    ///文字颜色
    class func xStock_TextColor() -> UIColor {
        if XStockGlobal.share.globalColorType == .Light {
            return getColor(hex: XStock_ChartTextColor_White, alpha: 1);
        }
        return getColor(hex: XStock_ChartTextColor_Dark, alpha: 1);
    }
    
    ///涨色
    class  func upColor() -> UIColor  {
        if XStockGlobal.share.upDownColorType == .UpGreenDownRed {
            return getColor(hex: XStock_GreenColor, alpha: 1);
        }
        return getColor(hex: XStock_RedColor, alpha: 1);
    }
    
    ///跌色
    class  func downColor() -> UIColor  {
        if XStockGlobal.share.upDownColorType == .UpRedDownGreen {
            return getColor(hex: XStock_GreenColor, alpha: 1);
        }
        return getColor(hex: XStock_RedColor, alpha: 1);
    }
    
    ///平价色
    class func getFairColor() -> UIColor {
        return getColor(hex: XStock_GrayColor);
    }

    ///分时/五日线的颜色
   class  func  getTimeLineColor() -> UIColor  {
        return getColor(hex: XStock_Time_FiveLineColor);
    }
    
    ///均价线的颜色
    class  func getAveLineColor() -> UIColor {
        return getColor(hex: XStock_AveLineColor);
    }
    
    ///长按十字线颜色
    class func getCrossCurveColor() -> UIColor {
        return getColor(hex: XStock_CrossCurveColor);
    }
    
    ///长按InfoBar背景色
    class func getTimeInfoLayerBackColor() -> UIColor {
        if XStockGlobal.share.globalColorType == .Light {
            return getColor(hex: XStock_CrossInfoBackColor_White, alpha: 1);
        }
        return getColor(hex: XStock_CrossInfoBackColor_Dark, alpha: 0.8);
    }
    
    
}
