//
//  XStockKLineInfoBar.swift
//  XStockChart
//  宽度为90 高度为130
//  Created by xiekunpeng on 2019/8/23.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

import UIKit

class XStockKLineInfoBar:  CALayer {
    ///每个控件的高度
    var  controlHeight : CGFloat {
        get {
            return (self.bounds.height - 4.0) / 9.0;
        }
    };
    
    lazy var left1: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2.0, y: 2.0, width: 30.0, height: controlHeight)
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
        layer.frame = CGRect(x: 2.0, y: 2.0 + controlHeight , width: 30.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.string = "开盘";
        return layer;
    }()
    
    lazy var left3: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2.0, y: 2.0 + controlHeight * 2.0 , width: 30.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.string = "最高";
        return layer;
    }()
    
    lazy var left4: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2.0, y: 2.0 + controlHeight * 3.0 , width: 30.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.string = "最低";
        return layer;
    }()
    
    lazy var left5: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2.0, y: 2.0 + controlHeight * 4.0 , width: 30.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.string = "收盘";
        return layer;
    }()
    
    lazy var left6: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2.0, y: 2.0 + controlHeight * 5.0 , width: 30.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.string = "涨跌额";
        return layer;
    }()
    
    lazy var left7: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2.0, y: 2.0 + controlHeight * 6.0 , width: 30.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.string = "涨跌幅";
        return layer;
    }()
    
    lazy var left8: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2.0, y: 2.0 + controlHeight * 7.0 , width: 30.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.string = "成交量";
        return layer;
    }()
    
    lazy var left9: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 2.0, y: 2.0 + controlHeight * 8.0 , width: 30.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.string = "成交额";
        return layer;
    }()
    
    lazy var right1: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 20.0, y: 2.0  , width: 69.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var right2: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 30.0, y: 2.0 + controlHeight  , width: 58.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var right3: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 30.0, y: 2.0 + controlHeight * 2.0  , width: 58.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var right4: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 30.0, y: 2.0 + controlHeight * 3.0 , width: 58.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var right5: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 30.0, y: 2.0 + controlHeight * 4.0  , width: 58.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var right6: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 30.0, y: 2.0 + controlHeight * 5.0  , width: 58.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var right7: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 30.0, y: 2.0 + controlHeight * 6.0 , width: 58.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var right8: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 30.0, y: 2.0 + controlHeight * 7.0 , width: 58.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
    
    lazy var right9: CATextLayer = {
        let layer = CATextLayer.init();
        layer.frame = CGRect(x: 30.0, y: 2.0 + controlHeight * 8.0 , width: 58.0, height: controlHeight)
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.fontSize = 9.0;
        layer.contentsScale = XStockContentScale;
        return layer;
    }()
 
    //MARK:----------MethodBegin----------
    init(frame:CGRect) {
        super.init();
        self.frame = frame;
        self.addSublayer(left1);
        self.addSublayer(left2);
        self.addSublayer(left3);
        self.addSublayer(left4);
        self.addSublayer(left5);
        self.addSublayer(left6);
        self.addSublayer(left7);
        self.addSublayer(left8);
        self.addSublayer(left9);
        self.addSublayer(right1);
        self.addSublayer(right2);
        self.addSublayer(right3);
        self.addSublayer(right4);
        self.addSublayer(right5);
        self.addSublayer(right6);
        self.addSublayer(right7);
        self.addSublayer(right8);
        self.addSublayer(right9);
        self.backgroundColor = XStockColor.xStock_BackColor().cgColor;
        self.borderWidth = 1.0;
        self.borderColor = UIColor.lightGray.cgColor;
        self.cornerRadius = 2.0;
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///传入一个日/周/月K数据进行展示
    func setupKLineContents(data:XStockKLineModel?, priceDot:UInt8)  {
        guard data != nil  else {
            return;
        }
        let change = XStockHelper.getCGFloat(str: data?.close) - XStockHelper.getCGFloat(str: data?.open);
        let changePct = change /  XStockHelper.getCGFloat(str: data?.open);
        let upDowncolor : UIColor?;
        if change > 0 {
            upDowncolor = XStockColor.upColor();
        }else if change < 0 {
            upDowncolor = XStockColor.downColor();
        }else {
            upDowncolor = XStockColor.getFairColor();
        }
        let valueColor = XStockColor.getFairColor();
        //time
        let timeStr = XStockHelper.getTimeStr(interval: data!.timeInterval).fullDateStr! ;
        ///open
        let openStr = XStockHelper.getFormatNumStr(num: XStockHelper.getCGFloat(str: data?.open), dotCount: priceDot);
        ///close
        let closeStr = XStockHelper.getFormatNumStr(num: XStockHelper.getCGFloat(str: data?.close), dotCount: priceDot);
        //high
        let highStr = XStockHelper.getFormatNumStr(num: XStockHelper.getCGFloat(str: data?.high), dotCount: priceDot);
        ///low
        let lowStr = XStockHelper.getFormatNumStr(num: XStockHelper.getCGFloat(str: data?.low), dotCount: priceDot);
        ///turnover
        let turnOver = XStockHelper.getCGFloat(str: data?.turnOver);
        var turnOverStr : String?;
        if turnOver >= 10000 {
            turnOverStr = XStockHelper.getFormatNumStr(num: turnOver / 10000.0, dotCount: 2) + "万";
        }else {
            turnOverStr = XStockHelper.getFormatNumStr(num: turnOver , dotCount: 2);
        }
        ///volume
        let volume = XStockHelper.getCGFloat(str: data?.volume);
        var volumeStr : String?;
        if volume >= 10000 {
            volumeStr = XStockHelper.getFormatNumStr(num: volume / 10000.0, dotCount: 2) + "万";
        }else {
            volumeStr = XStockHelper.getFormatNumStr(num: volume , dotCount: 2);
        }
        ///change
        let changeStr = XStockHelper.getFormatNumStr(num: change, dotCount: priceDot);
        //changePct
        let changePctStr = XStockHelper.getFormatNumStr(num: changePct * 100.0, dotCount: 2) + "%";
        right1.string = timeStr;
        right1.foregroundColor = valueColor.cgColor;
        right2.string = openStr;
        right2.foregroundColor = upDowncolor?.cgColor;
        right3.string = highStr;
        right3.foregroundColor = upDowncolor?.cgColor;
        right4.string = lowStr;
        right4.foregroundColor = upDowncolor?.cgColor;
        right5.string = closeStr;
        right5.foregroundColor = upDowncolor?.cgColor;
        right6.string = changeStr;
        right6.foregroundColor = upDowncolor?.cgColor;
        right7.string = changePctStr;
        right7.foregroundColor = upDowncolor?.cgColor;
        right8.string = volumeStr;
        right8.foregroundColor = valueColor.cgColor;
        right9.string = turnOverStr;
        right9.foregroundColor = valueColor.cgColor;
    }
    
    
    
    
    
    
}
