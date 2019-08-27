//
//  XStockTimeInfoBar.swift
//  XStockChart
//  宽度为80 高度为100
//  Created by xiekunpeng on 2019/8/12.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

import UIKit

class XStockTimeInfoBar: CALayer {
   
    ///每个控件的高度
    var  controlHeight : CGFloat {
        get {
            return (self.bounds.height - 4.0) / 7.0;
        }
    };
    
    lazy var left1: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2, y: 2, width: 30, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.backgroundColor = UIColor.white.cgColor;
        layer.fontSize = 9.0;
        layer.string = "时间";
        return layer;
    }()
    
    lazy var left2: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2, y: 2 + controlHeight , width: 30, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.string = "价格";
        return layer;
    }()
    
    lazy var left3: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2, y: 2 + controlHeight * 2 , width: 30, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.string = "均价";
        return layer;
    }()
    
    lazy var left4: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2, y: 2 + controlHeight * 3 , width: 30, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.string = "涨跌额";
        return layer;
    }()
    
    lazy var left5: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2, y: 2 + controlHeight * 4 , width: 30, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.string = "涨跌幅";
        return layer;
    }()
    
    lazy var left6: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2, y: 2 + controlHeight * 5 , width: 30, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.string = "成交量";
        return layer;
    }()
    
    lazy var left7: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2, y: 2 + controlHeight * 6 , width: 30, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.string = "成交额";
        return layer;
    }()
    
    lazy var right1: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 31, y: 2  , width: 47, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var right2: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 42, y: 2 + controlHeight  , width: 36, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var right3: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 42, y: 2 + controlHeight * 2  , width: 36, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var right4: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 42, y: 2 + controlHeight * 3 , width: 36, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var right5: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 42, y: 2 + controlHeight * 4  , width: 36, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var right6: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 42, y: 2 + controlHeight * 5  , width: 36, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var right7: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 42, y: 2 + controlHeight * 6 , width: 36, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var upBarLayer: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 1, y: 1 , width: self.bounds.width - 2, height: self.bounds.height - 2);
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.fontSize = 9.0;
        layer.isWrapped = true;
        return layer;
    }()
    
    
    init(frame:CGRect) {
        super.init();
        self.frame = frame;
        if XStockGlobal.share.infoBarType == .SideBar {
            self.addSublayer(left1);
            self.addSublayer(left2);
            self.addSublayer(left3);
            self.addSublayer(left4);
            self.addSublayer(left5);
            self.addSublayer(left6);
            self.addSublayer(left7);
            self.addSublayer(right1);
            self.addSublayer(right2);
            self.addSublayer(right3);
            self.addSublayer(right4);
            self.addSublayer(right5);
            self.addSublayer(right6);
            self.addSublayer(right7);
            self.backgroundColor = XStockColor.xStock_BackColor().cgColor;
            self.borderWidth = 1.0;
            self.borderColor = UIColor.lightGray.cgColor;
            self.cornerRadius = 2.0;
        }else {
            self.backgroundColor = XStockColor.xStock_BackColor().cgColor;
            self.addSublayer(upBarLayer);
        }
    }
    
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///传入一个分时/五日数据进行展示
    func setupTimeContents(data:XStockTimeModel?, preClose:String?, priceDot:UInt8)  {
        guard data != nil && preClose != nil else {
            return;
        }
        
        let change = XStockHelper.getCGFloat(str: data?.price) - XStockHelper.getCGFloat(str: preClose);
        let changePct = change /  XStockHelper.getCGFloat(str: preClose);
        let upDowncolor : UIColor?;
        if change > 0 {
            upDowncolor = XStockColor.upColor();
        }else if change < 0 {
            upDowncolor = XStockColor.downColor();
        }else {
            upDowncolor = XStockColor.getFairColor();
        }
        let valueColor = XStockColor.getFairColor();
        let desColor = XStockColor.xStock_TextColor();
        let resultStr = NSMutableAttributedString.init();
        //time
        let timeStr = XStockHelper.getTimeStr(interval: data!.timeInterval).dayDateStr! + "/" + XStockHelper.getTimeStr(interval: data!.timeInterval).timeDateStr!;
        let realTimeStr = NSMutableAttributedString.init(string:"时间:" + timeStr);
        let timeDesRange = realTimeStr.string.range(of: String("时间:"));
        let timeRange = realTimeStr.string.range(of: String(timeStr));
        realTimeStr.addAttributes([NSAttributedString.Key.foregroundColor : valueColor], range: realTimeStr.string.getNSRange(timeRange!));
        realTimeStr.addAttributes([NSAttributedString.Key.foregroundColor : desColor], range: realTimeStr.string.getNSRange(timeDesRange!));
        //price
        let priceStr = XStockHelper.getFormatNumStr(num: XStockHelper.getCGFloat(str: data?.price), dotCount: priceDot);
        let realPriceStr = NSMutableAttributedString.init(string: "价格:" + priceStr);
        let priceDesRange = realPriceStr.string.range(of: String("价格:"));
        let priceRange = realPriceStr.string.range(of: String(priceStr));
        realPriceStr.addAttributes([NSAttributedString.Key.foregroundColor : desColor], range: realPriceStr.string.getNSRange(priceDesRange!));
        realPriceStr.addAttributes([NSAttributedString.Key.foregroundColor : upDowncolor!], range: realPriceStr.string.getNSRange(priceRange!));
        //avePrice
        let avePriceStr = XStockHelper.getFormatNumStr(num: XStockHelper.getCGFloat(str: data?.avePrice), dotCount: priceDot);
        let realAvePriceStr = NSMutableAttributedString.init(string: "均价:" + avePriceStr);
        let avePriceDesRange = realAvePriceStr.string.range(of: String("均价:"));
        let avePriceRange = realAvePriceStr.string.range(of: String(avePriceStr));
        realAvePriceStr.addAttributes([NSAttributedString.Key.foregroundColor : desColor], range: realAvePriceStr.string.getNSRange(avePriceDesRange!));
        realAvePriceStr.addAttributes([NSAttributedString.Key.foregroundColor : upDowncolor!], range: realAvePriceStr.string.getNSRange(avePriceRange!));
        //change
        let changeStr = XStockHelper.getFormatNumStr(num: change, dotCount: priceDot);
        let realChangeStr = NSMutableAttributedString.init(string: "涨跌额:" + changeStr);
        let changeDesRange = realChangeStr.string.range(of: String("涨跌额:"));
        let changeRange = realChangeStr.string.range(of: String(changeStr));
        realChangeStr.addAttributes([NSAttributedString.Key.foregroundColor : desColor], range: realChangeStr.string.getNSRange(changeDesRange!));
        realChangeStr.addAttributes([NSAttributedString.Key.foregroundColor : upDowncolor!], range: realChangeStr.string.getNSRange(changeRange!));
        //changePct
        let changePctStr = XStockHelper.getFormatNumStr(num: changePct * 100.0, dotCount: 2) + "%";
        let realChangePctStr = NSMutableAttributedString.init(string: "涨跌幅:" + changePctStr);
        let changePctDesRange = realChangePctStr.string.range(of: String("涨跌幅:"));
        let changePctRange = realChangePctStr.string.range(of: String(changePctStr));
        realChangePctStr.addAttributes([NSAttributedString.Key.foregroundColor : desColor], range: realChangePctStr.string.getNSRange(changePctDesRange!));
        realChangePctStr.addAttributes([NSAttributedString.Key.foregroundColor : upDowncolor!], range: realChangePctStr.string.getNSRange(changePctRange!));
        //volume
        let volume = XStockHelper.getCGFloat(str: data?.volume);
        var voluemeStr : String?;
        if volume >= 10000 {
            voluemeStr = XStockHelper.getFormatNumStr(num: volume / 10000.0, dotCount: 2) + "万手";
        }else {
            voluemeStr = XStockHelper.getFormatNumStr(num: volume, dotCount: 0) + "手";
        }
        let  realVolumeStr = NSMutableAttributedString.init(string: "成交量:" + voluemeStr!);
        let volumeDesRange = realVolumeStr.string.range(of: String("成交量:"));
        let volumeRange = realVolumeStr.string.range(of: String(voluemeStr!));
        realVolumeStr.addAttributes([NSAttributedString.Key.foregroundColor :desColor], range: realVolumeStr.string.getNSRange(volumeDesRange!));
        realVolumeStr.addAttributes([NSAttributedString.Key.foregroundColor :valueColor], range: realVolumeStr.string.getNSRange(volumeRange!));
        
        //turnover
        let turnover = volume * XStockHelper.getCGFloat(str: data?.price);
        var turnoverStr : String?;
        if turnover >= 10000 {
            turnoverStr = XStockHelper.getFormatNumStr(num: turnover / 10000.0, dotCount: 2) + "万";
        }else {
            turnoverStr = XStockHelper.getFormatNumStr(num: turnover , dotCount: 2);
        }
        let realAmountStr = NSMutableAttributedString.init(string: "成交额:" + turnoverStr!);
        let turnoverRange = realAmountStr.string.range(of: String(turnoverStr!));
        let turnoverDesRange = realAmountStr.string.range(of: String("成交额:"));
        realAmountStr.addAttributes([NSAttributedString.Key.foregroundColor : valueColor], range: realAmountStr.string.getNSRange(turnoverRange!));
        realAmountStr.addAttributes([NSAttributedString.Key.foregroundColor : desColor], range: realAmountStr.string.getNSRange(turnoverDesRange!));
        
        if XStockGlobal.share.infoBarType == .SideBar {
            right1.string = timeStr;
            right1.foregroundColor = valueColor.cgColor;
            right2.string = priceStr;
            right2.foregroundColor = upDowncolor?.cgColor;
            right3.string = avePriceStr;
            right3.foregroundColor = upDowncolor?.cgColor;
            right4.string = changeStr;
            right4.foregroundColor = upDowncolor?.cgColor;
            right5.string = changePctStr;
            right5.foregroundColor = upDowncolor?.cgColor;
            right6.string = voluemeStr!;
            right6.foregroundColor = valueColor.cgColor;
            right7.string = turnoverStr!
            right7.foregroundColor = valueColor.cgColor;
        }else {///废弃
            resultStr.append(realTimeStr);
            resultStr.append(NSAttributedString.init(string: " "));
            resultStr.append(realPriceStr);
            resultStr.append(NSAttributedString.init(string: " "));
            resultStr.append(realAvePriceStr);
            resultStr.append(NSAttributedString.init(string: " "));
            resultStr.append(realChangeStr);
            if XStockHelper.getScreenDeriction() == .LandscapeScreen {
                resultStr.append(NSAttributedString.init(string: " "));
            }else {
                resultStr.append(NSAttributedString.init(string: "\n"));
            }
            resultStr.append(realChangePctStr);
            resultStr.append(NSAttributedString.init(string: " "));
            resultStr.append(realVolumeStr);
            resultStr.append(NSAttributedString.init(string: " "));
            resultStr.append(realAmountStr);
            resultStr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11.0)], range: NSRange.init(location: 0, length: resultStr.string.count));
            upBarLayer.string = resultStr;
        }
    }
    
    
    
    
    
    
}
