//
//  XStockChartKLineView.swift
//  XStockChart
//
//  Created by xiekunpeng on 2019/8/19.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

import UIKit

class XStockChartKLineView: UIView {
    var handler  : XStockContainHandler?;
    var stkType  : XStockType?;
    var showType : XStockChartType?;
    ///MARK:几个关键数据
    var chartLeftTopPoint : CGPoint?;
    var volumeLetTopPoint : CGPoint?;
    var chartWidth : CGFloat?;
    var chartHeight : CGFloat?;
    
    
    
    
    ///最高价
    lazy var left1Layer     = CATextLayer.init();
    ///均价
    lazy var left2Layer     = CATextLayer.init();
    ///最低价
    lazy var left3Layer     = CATextLayer.init();
    ///左下角成交量描述文字
    lazy var volumeDesLayer = CATextLayer.init();
    ///左下角成交量文字
    lazy var volumeLayer    = CATextLayer.init();
    ///实际的当前屏幕显示的数据
    var realDataArr : Array<XStockKLineModel> = [];

    ///每个柱子区域宽度
    var itemWidth : CGFloat?;
    ///最大的成交量
    var maxVolume : CGFloat?;
    ///左侧显示的最大价格
    var maxPrice : CGFloat?;
    ///左侧显示的均价
    var avePrice : CGFloat?;
    ///左侧显示的最小价格
    var minPrice : CGFloat?;
    
    
    ///成交量中涨layer
    lazy var upVolumeLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.strokeColor = XStockColor.upColor().cgColor;
        return layer;
    }()
    ///成交量中跌layer
    lazy var downVolumeLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.strokeColor = XStockColor.downColor().cgColor;
        return layer;
    }()
    ///长按弹出十字线竖线
    lazy var vCrossLineLayer : CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.backgroundColor = XStockColor.getCrossCurveColor().cgColor;
        layer.frame.size = CGSize(width: 1, height: self.bounds.height);
        layer.isHidden = true;
        return layer;
    }()
    ///长按弹出十字线横线
    lazy var hCrossLineLayer : CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.backgroundColor = XStockColor.getCrossCurveColor().cgColor;
        layer.frame.size = CGSize(width: self.chartWidth!, height: 1);
        layer.isHidden = true;
        return layer
    }()
    ///价格的小数位数
    var priceDotCount : UInt8 {
        get {
            var dotCount : UInt8 = 2;
            if stkType == XStockType.US {
                if maxPrice! < 1.0 {
                    dotCount = 4;
                }
            }
            if stkType == XStockType.HK {
                dotCount = 3;
            }
            return dotCount;
        }
    }
    ///长按
    lazy var longTapG: UILongPressGestureRecognizer = {
        let tap = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction(sender:)))
        return tap;
    }()
    
    lazy var infoTimeLayer: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.fontSize = 9.0;
        layer.alignmentMode = CATextLayerAlignmentMode.center;
        layer.borderWidth = 1.0;
        layer.backgroundColor = XStockColor.getTimeInfoLayerBackColor().cgColor;
        layer.isHidden = true;
        return layer;
    }()
    
    
    
    
    lazy var infoPriceLayer: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.fontSize = 9.0;
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.borderWidth = 1;
        layer.backgroundColor = XStockColor.getTimeInfoLayerBackColor().cgColor;
        layer.isHidden = true;
        return layer;
    }()
    
    
    
    lazy var infoPctLayer: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.fontSize = 9.0;
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        layer.borderWidth = 1.0;
        layer.backgroundColor = XStockColor.getTimeInfoLayerBackColor().cgColor;
        layer.isHidden = true;
        return layer;
    }()
    
    
    lazy var infoBar: XStockTimeInfoBar = {
        if XStockGlobal.share.infoBarType == XStockLongPressInfoType.SideBar {
            let layer = XStockTimeInfoBar.init(frame: CGRect(x: 0, y: 0, width: 80.0, height: 100.0))
            layer.isHidden = true;
            self.layer.addSublayer(layer);
            return layer;
        }else {
            let layer = XStockTimeInfoBar.init(frame: CGRect(x: 0, y: 0, width: XScreenWidth - 10.0, height: 40.0));
            let window  = UIApplication.shared.keyWindow;
            let rect = self.convert(self.bounds, to: window);
            layer.frame.origin = CGPoint(x: 5, y: rect.origin.y - 60.0);
            window?.layer.addSublayer(layer);
            layer.isHidden = true;
            return layer;
        }
    }()
    
    
    
    lazy var downTimeLayer1: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.fontSize = 9.0;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.frame = CGRect(x: 0, y: chartHeight!, width: 30.0, height: 20.0);
        return layer;
    }()
    
    lazy var downTimeLayer2: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.fontSize = 9.0;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.alignmentMode = CATextLayerAlignmentMode.center;
        layer.frame = CGRect(x: self.chartWidth! / 5.0 - 15.0, y: chartHeight!, width: 30.0, height: 20.0);
        if self.showType == XStockChartType.Time {
            layer.isHidden = true;
        }else {
            layer.isHidden = false;
        }
        return layer;
    }()
    
    lazy var downTimeLayer3: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.fontSize = 9.0;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.alignmentMode = CATextLayerAlignmentMode.center;
        if self.showType == XStockChartType.Time {
            layer.frame = CGRect(x: self.chartWidth! / 2.0  - 30.0, y: chartHeight!, width: 60.0, height: 20.0);
        }else {
            layer.frame = CGRect(x: self.chartWidth! / 5.0 * 2.0 - 15.0, y: chartHeight!, width: 30.0, height: 20.0);
        }
        return layer;
    }()
    
    
    lazy var downTimeLayer4: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.alignmentMode = CATextLayerAlignmentMode.center;
        layer.frame = CGRect(x: self.chartWidth! / 5.0 * 3 - 15.0, y: chartHeight!, width: 30.0, height: 20.0);
        if self.showType == XStockChartType.Time {
            layer.isHidden = true;
        }else {
            layer.isHidden = false;
        }
        return layer;
    }()
    
    
    lazy var downTimeLayer5: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        if self.showType == XStockChartType.Time {
            layer.frame = CGRect(x: chartWidth! - 30.0, y: chartHeight!, width: 30.0, height: 20.0);
            layer.alignmentMode = CATextLayerAlignmentMode.right;
        }else {
            layer.frame = CGRect(x: self.chartWidth! / 5.0 * 4 - 15.0, y: chartHeight!, width: 30.0, height: 20.0);
            layer.alignmentMode = CATextLayerAlignmentMode.center;
        }
        return layer;
    }()
    
    
    lazy var priceCircleLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.isHidden = true;
        layer.fillColor = XStockColor.getColor(hex: XStock_Time_FiveFillColor).cgColor;
        layer.strokeColor = XStockColor.getTimeLineColor().cgColor;
        layer.lineWidth = 0.7;
        return layer;
    }()
    
    lazy var avePriceCirleLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.isHidden = true;
        layer.fillColor = XStockColor.getColor(hex: XStock_AveFillColor).cgColor;
        layer.strokeColor = XStockColor.getAveLineColor().cgColor;
        layer.lineWidth = 0.7;
        return layer;
    }()
    
    
    
    
    
    ///初始化方法
    init(frame: CGRect,
         stkType:XStockType!,
         showType:XStockChartType!,
         handler:XStockContainHandler!) {
        super.init(frame: frame);
        self.setupBaseData();
        self.setupGridLines();
        self.handler = handler;
        self.stkType = stkType;
        self.showType = showType;
        self.setupTextLayers();
        self.addLayers();
        self.addGestureRecognizer(longTapG);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///绘制方法
    ///获取数据成功, 拖动, 捏合之后重新计算
    func refreshAllContent()  {
        var dataArr : Array<XStockKLineModel>?;
        if self.showType == XStockChartType.Day  {
            if handler?.kLineManager.dayKChartDataArr.count == 0 {
                return;
            }
            dataArr = handler?.kLineManager.dayKChartDataArr;
        }
        if self.showType == XStockChartType.Week  {
            if  handler?.kLineManager.weekKChartDataArr.count == 0 {
                return;
            }
            dataArr = handler?.kLineManager.weekKChartDataArr;
        }
        if self.showType == XStockChartType.Month  {
            if handler?.kLineManager.monthKChartDataArr.count == 0 {
                return;
            }
            dataArr = handler?.kLineManager.monthKChartDataArr;
        }
        let itemCount = handler!.kLineManager.showItemCount!;
        if itemCount >= dataArr!.count {
            realDataArr = dataArr!;
        }else {
            if  handler!.kLineManager.lastPoint > itemCount {
                realDataArr = Array(dataArr![handler!.kLineManager.lastPoint - itemCount...handler!.kLineManager.lastPoint]);
            }else {
                realDataArr = Array(dataArr![0...itemCount]);
            }
        }
        var i = 0;
        var j = realDataArr.count - 1;
        while j >= i {
            let iHV = XStockHelper.getCGFloat(str: realDataArr[i].high);
            let jHV = XStockHelper.getCGFloat(str: realDataArr[j].high);
            let iLV = XStockHelper.getCGFloat(str: realDataArr[i].low);
            let jLV = XStockHelper.getCGFloat(str: realDataArr[j].low);
            let iVV = XStockHelper.getCGFloat(str: realDataArr[i].volume);
            let jVV = XStockHelper.getCGFloat(str: realDataArr[j].volume);
            maxPrice = max(iHV, max(jHV, maxPrice ?? 0.0));
            minPrice = min(iLV, min(jLV, minPrice ?? 99999999999999.0));
            maxVolume = max(iVV, max(jVV, maxVolume ?? 0.0));
            i += 1;
            j -= 1;
        }
        avePrice = (maxPrice! + minPrice!) / 2.0;
        itemWidth = chartWidth! / CGFloat(itemCount);
//        setupText();
        setupVolumeLines();
        setupDownTimeLayers()
        setTextConent()
    }
    

    
    
    
    ///初始化时调用一次
    func addLayers() {
        if XStockHelper.getScreenDeriction() == .PortraitScreen {
            if XStockGlobal.share.alwaysShowVolumeDes == true {
                self.layer.addSublayer(volumeDesLayer);
                self.layer.addSublayer(volumeLayer);
            }
        }else {
            self.layer.addSublayer(volumeDesLayer);
            self.layer.addSublayer(volumeLayer);
        }
        self.layer.addSublayer(downTimeLayer1);
        self.layer.addSublayer(downTimeLayer2);
        self.layer.addSublayer(downTimeLayer3);
        self.layer.addSublayer(downTimeLayer4);
        self.layer.addSublayer(downTimeLayer5);
        self.layer.addSublayer(left1Layer);
        self.layer.addSublayer(left2Layer);
        self.layer.addSublayer(left3Layer);
        self.layer.addSublayer(upVolumeLayer);
        self.layer.addSublayer(downVolumeLayer);
        self.layer.addSublayer(vCrossLineLayer);
        self.layer.addSublayer(hCrossLineLayer);
        self.layer.addSublayer(infoPctLayer);
        self.layer.addSublayer(infoTimeLayer);
        self.layer.addSublayer(infoPriceLayer);
        self.layer.addSublayer(priceCircleLayer);
        self.layer.addSublayer(avePriceCirleLayer);
    }
    
    
    
    ///初始化时调用一次
    func setupBaseData()  {
        chartLeftTopPoint = CGPoint(x: 0, y: 0);
        chartWidth = bounds.width;
        chartHeight = bounds.height - XStockGlobal.share.volumeHeihgt - 20;
        volumeLetTopPoint = CGPoint(x: 0, y: bounds.height - XStockGlobal.share.volumeHeihgt)
    }
    
    
    
    
    ///绘制网格线,  初始化时调用一次
    func setupGridLines()  {
        let layer = CAShapeLayer.init();
        layer.strokeColor = XStockColor.xStock_GridColor().cgColor;
        let path = UIBezierPath.init();
        path.lineWidth = 0.5;
        //Vertaical 垂直网格
        let gridWidth = chartWidth! / CGFloat(XStock_ChartVerticalGridCount - 1);
        for idx in 0...XStock_ChartVerticalGridCount - 1 {
            path.move(to: CGPoint(x: chartLeftTopPoint!.x + CGFloat(idx) * gridWidth, y: chartLeftTopPoint!.y));
            path.addLine(to: CGPoint(x: chartLeftTopPoint!.x + CGFloat(idx) * gridWidth, y: chartLeftTopPoint!.y + chartHeight!));
            path.move(to: CGPoint(x: chartLeftTopPoint!.x + CGFloat(idx) * gridWidth, y: chartLeftTopPoint!.y + 20.0 + chartHeight!));
            path.addLine(to: CGPoint(x: chartLeftTopPoint!.x + CGFloat(idx) * gridWidth, y: chartLeftTopPoint!.y + chartHeight! + 20.0 + XStockGlobal.share.volumeHeihgt));
        }
        //Horizontal  水平网格
        let chartAreaHeight = chartHeight! / CGFloat(XStock_ChartHorizontalGridCount - 3);
        for idx in 0...XStock_ChartHorizontalGridCount - 1 {
            if idx < 5 {
                if idx == 2  {
                    
                }else {
                    path.move(to: CGPoint(x: chartLeftTopPoint!.x, y: chartLeftTopPoint!.y + CGFloat(idx) * chartAreaHeight ));
                    path.addLine(to: CGPoint(x: chartLeftTopPoint!.x + chartWidth!, y: chartLeftTopPoint!.y + CGFloat(idx) * chartAreaHeight ))
                }
            }else {
                path.move(to: CGPoint(x: volumeLetTopPoint!.x, y: volumeLetTopPoint!.y + CGFloat(idx - 5) * XStockGlobal.share.volumeHeihgt ));
                path.addLine(to: CGPoint(x: volumeLetTopPoint!.x + chartWidth!, y: volumeLetTopPoint!.y + CGFloat(idx - 5) * XStockGlobal.share.volumeHeihgt ))
            }
        }
        let dotLayer = CAShapeLayer.init();
        let dotPath = UIBezierPath.init();
        ///绘制中间虚线, 颜色稍微深一些
        dotLayer.strokeColor = XStockColor.getColor(hex: 0xd5d5d5).cgColor;
        dotPath.move(to: CGPoint(x: chartLeftTopPoint!.x, y: chartLeftTopPoint!.y + CGFloat(2) * chartAreaHeight ));
        dotPath.addLine(to: CGPoint(x: chartLeftTopPoint!.x + chartWidth!, y: chartLeftTopPoint!.y + CGFloat(2) * chartAreaHeight ));
        dotLayer.lineDashPattern = [2,2];
        dotLayer.path = dotPath.cgPath;
        layer.path = path.cgPath;
        self.layer.addSublayer(layer);
        self.layer.addSublayer(dotLayer);
    }
    
    ///图表上的文字相关, 初始化时调用一次
    func setupTextLayers()  {
        volumeDesLayer.contentsScale = XStockContentScale;
        volumeLayer.contentsScale = XStockContentScale;
        volumeLayer.fontSize = 10.0;
        volumeDesLayer.fontSize = 10.0;
        volumeLayer.foregroundColor = XStockColor.upColor().cgColor;
        volumeDesLayer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        if XStockHelper.getScreenDeriction() == .LandscapeScreen {
            volumeDesLayer.frame = CGRect(x:volumeLetTopPoint!.x - 40.0 , y: volumeLetTopPoint!.y + XStockGlobal.share.volumeHeihgt - 20.0, width: 40.0, height: 12.0);
            volumeLayer.frame = CGRect(x:volumeLetTopPoint!.x - 40.0 , y: volumeLetTopPoint!.y , width: 40.0, height: 12.0);
            volumeLayer.alignmentMode = .right;
            volumeDesLayer.alignmentMode = .right;
        }else {
            volumeDesLayer.frame = CGRect(x:volumeLetTopPoint!.x + 1 , y: volumeLetTopPoint!.y + XStockGlobal.share.volumeHeihgt - 14, width: 40.0, height: 12.0);
            volumeLayer.frame = CGRect(x:volumeLetTopPoint!.x + 1 , y: volumeLetTopPoint!.y + 1.0 , width: 40.0, height: 12.0);
            volumeLayer.alignmentMode = .left;
            volumeDesLayer.alignmentMode = .left;
        }
        
        ///上方图表相关
        left1Layer.contentsScale = XStockContentScale;
        left2Layer.contentsScale = XStockContentScale;
        left3Layer.contentsScale = XStockContentScale;
        left1Layer.fontSize = 10.0;
        left2Layer.fontSize = 10.0;
        left3Layer.fontSize = 10.0;
        left1Layer.foregroundColor = XStockColor.upColor().cgColor;
        left2Layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        left3Layer.foregroundColor = XStockColor.downColor().cgColor;
        
        let chartAreaSubHeight = chartHeight! / CGFloat(XStock_ChartHorizontalGridCount - 3);
        if XStockHelper.getScreenDeriction() == .LandscapeScreen {
            left1Layer.frame = CGRect(x: chartLeftTopPoint!.x - 45.0, y: chartLeftTopPoint!.y, width: 45.0, height: 12.0);
            left2Layer.frame = CGRect(x: chartLeftTopPoint!.x - 45.0, y: chartLeftTopPoint!.y + chartAreaSubHeight * 2.0 - 7.0, width: 45.0, height: 12.0);
            left3Layer.frame = CGRect(x: chartLeftTopPoint!.x - 45.0, y: chartLeftTopPoint!.y + chartAreaSubHeight * 4.0 - 14.0, width: 45.0, height: 12.0);
            left1Layer.alignmentMode = .right;
            left2Layer.alignmentMode = .right;
            left3Layer.alignmentMode = .right;
        }else {
            left1Layer.frame = CGRect(x: chartLeftTopPoint!.x, y: chartLeftTopPoint!.y, width: 45, height: 12);
            left2Layer.frame = CGRect(x: chartLeftTopPoint!.x , y: chartLeftTopPoint!.y + chartAreaSubHeight * 2.0 - 7.0, width: 45.0, height: 12.0);
            left3Layer.frame = CGRect(x: chartLeftTopPoint!.x, y: chartLeftTopPoint!.y + chartAreaSubHeight * 4.0 - 14.0, width: 45.0, height: 12.0);
            left1Layer.alignmentMode = .left;
            left2Layer.alignmentMode = .left;
            left3Layer.alignmentMode = .left;
        }
    }
    
    ///绘制成交量柱子 多次调用;
    func setupVolumeLines()  {
        guard realDataArr.count > 0 else {
            return;
        }
        ///右侧留下20%(不让各个线挨着)
        if XStockGlobal.share.kLineColumeType == .Solid {
            upVolumeLayer.lineWidth = itemWidth! * 0.8;
            downVolumeLayer.lineWidth = itemWidth! * 0.8;
        }else {
            upVolumeLayer.lineWidth = 1;
            downVolumeLayer.lineWidth = 1;
            upVolumeLayer.fillColor = XStockColor.xStock_BackColor().cgColor;
            downVolumeLayer.fillColor = XStockColor.xStock_BackColor().cgColor;
        }
        let volumeLeftDownPoint = CGPoint(x: volumeLetTopPoint!.x, y: volumeLetTopPoint!.y + XStockGlobal.share.volumeHeihgt);
        let upPath = UIBezierPath.init();
        let downPath = UIBezierPath.init();
        let avePath = UIBezierPath.init();
        for idx in 0...realDataArr.count - 1 {
            let idxObj : XStockKLineModel = realDataArr[idx];
            let idxV : CGFloat = XStockHelper.getCGFloat(str: idxObj.volume)
            let offsetY = XStockHelper.getCGFloat(str: idxObj.volume) / maxVolume! * XStockGlobal.share.volumeHeihgt;
            let open : CGFloat = XStockHelper.getCGFloat(str: idxObj.open);
            let close : CGFloat = XStockHelper.getCGFloat(str: idxObj.close);
            if open < close  {
                if XStockGlobal.share.kLineColumeType == .Solid {
                    upPath.move(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.5, y: volumeLeftDownPoint.y))
                    upPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth!  + itemWidth! * 0.5, y: volumeLeftDownPoint.y - offsetY))
                }else {
                    upPath.move(to: CGPoint(x: volumeLeftDownPoint.x + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y));
                    upPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x + itemWidth! * 0.8 + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y ));
                    upPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x + itemWidth! * 0.8 + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y - offsetY));
                    upPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x  + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y - offsetY));
                    upPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y));
                }
            }else  {
                if XStockGlobal.share.kLineColumeType == .Solid {
                    downPath.move(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.5, y: volumeLeftDownPoint.y))
                    downPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth!  + itemWidth! * 0.5, y: volumeLeftDownPoint.y - offsetY))
                }else {
                    downPath.move(to: CGPoint(x: volumeLeftDownPoint.x + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y));
                    downPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x + itemWidth! * 0.8 + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y ));
                    downPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x + itemWidth! * 0.8 + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y - offsetY));
                    downPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x  + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y - offsetY));
                    downPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y));
                }
            }
        }
        upVolumeLayer.path = upPath.cgPath;
        downVolumeLayer.path = downPath.cgPath;
    }
    
    
    ///设置显示内容,图表周边的价格, 成交量, 百分比等信息
    func setTextConent()  {
        ///上方图表相关
        left1Layer.string = XStockHelper.getFormatNumStr(num: maxPrice, dotCount: priceDotCount);
        left2Layer.string = XStockHelper.getFormatNumStr(num: avePrice, dotCount: priceDotCount);
        left3Layer.string = XStockHelper.getFormatNumStr(num: minPrice, dotCount: priceDotCount);
        ///下方成交量相关
        var volumeCountStr = XStockHelper.getFormatNumStr(num: maxVolume, dotCount: 0);
        var volumeDesStr = "股"
        if maxVolume! >= 10000.0 {
            volumeDesStr = "万股";
            volumeCountStr = XStockHelper.getFormatNumStr(num: maxVolume!/10000.0, dotCount: 2);
        }
        volumeLayer.string = volumeCountStr;
        volumeDesLayer.string = volumeDesStr;
    }
    
    ///绘制分时时如果popint不再图表区域内的话, 就把他放在边上
    func adjustPoint(point:CGPoint) -> CGPoint {
        let rect = CGRect(x: chartLeftTopPoint!.x, y: chartLeftTopPoint!.y, width: chartWidth!, height: chartHeight!);
        if rect.contains(point) {
            return point;
        }else {
            var getX = point.x;
            var getY = point.y;
            if  point.x >= rect.maxX{
                getX = rect.maxX;
            }
            if  point.x <= rect.minX{
                getX = rect.minX;
            }
            if point.y >= rect.maxY {
                getY = rect.maxY;
            }
            if  point.y <= rect.minY {
                getY = rect.minY;
            }
            return CGPoint(x: getX, y: getY);
        }
    }
    
    //MARK:长按弹出相关信息
    @objc func longPressAction(sender : UILongPressGestureRecognizer) {
        var  thePoint = sender.location(in: self);
        thePoint = adjustCroseeCurvePoint(point: thePoint).realPoint;
        let idx = adjustCroseeCurvePoint(point: thePoint).idx;
        if sender.state == .began {
            vCrossLineLayer.isHidden = false;
            hCrossLineLayer.isHidden = false;
            infoPriceLayer.isHidden = false;
            infoTimeLayer.isHidden = false;
            infoPctLayer.isHidden = false;
            infoBar.isHidden = false;
            priceCircleLayer.isHidden = false;
            avePriceCirleLayer.isHidden = false;
            showCrossLine(point: thePoint, show: true);
            showInfoLayers(point: thePoint, idx: idx, show: true);
            showBar(point: thePoint, idx: idx, show: true);
        }
        if sender.state == .changed {
            showCrossLine(point: thePoint, show: true);
            showInfoLayers(point: thePoint, idx: idx, show: true);
            showBar(point: thePoint, idx: idx, show: true);
        }
        if sender.state == .ended {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.showCrossLine(point: thePoint, show: false);
                self.showInfoLayers(point: thePoint, idx: idx, show: false);
                self.showBar(point: thePoint, idx: idx, show: false);
            }
        }
    }
    
    ///长按时弹出的infoBar
    func showBar(point:CGPoint, idx:Int, show:Bool)  {
        if  show {
            CATransaction.begin();
            CATransaction.setDisableActions(true);
            if XStockGlobal.share.infoBarType == .SideBar {
                if point.x > chartWidth! / 2.0 {
                    infoBar.frame.origin = CGPoint(x: 30, y: 0)
                }else {
                    infoBar.frame.origin = CGPoint(x: chartWidth! - 30 - 80, y: 0);
                }
            }
            CATransaction.commit();
            if realDataArr.count > idx {
                let model : XStockKLineModel = realDataArr[idx];
//                infoBar.setupTimeContents(data: model, preClose: self.preClose, priceDot: priceDotCount);
            }
        }else {
            infoBar.isHidden = true;
        }
    }
    
    
    func showCrossLine(point:CGPoint, show:Bool)  {
        if show {
            ///关闭CALayer的隐式动画, 防止交叉线移动不及时(如果使用UIView直接更改Frame即可, 因为不触发隐式动画)
            CATransaction.begin();
            CATransaction.setDisableActions(true);
            vCrossLineLayer.frame = CGRect(x: point.x, y: 0, width: 1, height: self.bounds.height);
            hCrossLineLayer.frame = CGRect(x: 0, y: point.y, width: chartWidth!, height: 1);
            CATransaction.commit();
        }else {
            vCrossLineLayer.isHidden = true;
            hCrossLineLayer.isHidden = true;
        }
    }
    
    ///长按时依附在十字线上的信息layer
    func showInfoLayers(point:CGPoint, idx:Int, show:Bool)  {
        if show {
            if realDataArr.count > idx {
                let model : XStockKLineModel = realDataArr[idx];
                CATransaction.begin();
                CATransaction.setDisableActions(true);
                ///下方时间
                let timeStr = XStockHelper.getTimeStr(interval: model.timeInterval).fullDateStr!;
                let timeSize = XStockHelper.getStrSize(str: timeStr, fontSize: 9.0)
                var timeOrigin = CGPoint(x: point.x - timeSize.width / 2, y: chartHeight!);
                if timeOrigin.x <= 0 {
                    timeOrigin.x = 0;
                }
                if timeOrigin.x >= chartWidth! - timeSize.width {
                    timeOrigin.x = chartWidth! - timeSize.width;
                }
                infoTimeLayer.frame.origin = timeOrigin;
                infoTimeLayer.frame.size = timeSize;
                infoTimeLayer.string = timeStr;
                if point.y <= chartHeight! {
                    ///左侧价格
                    let priceFloat : CGFloat = (maxPrice! - minPrice!) * ((chartHeight! - point.y) / chartHeight!) + minPrice!;
                    let priceStr = XStockHelper.getFormatNumStr(num: priceFloat, dotCount: priceDotCount);
                    let priceSize = XStockHelper.getStrSize(str: priceStr, fontSize: 9.0)
                    let priceOrigin = CGPoint(x: 0, y: point.y - priceSize.height / 2.0);
                    infoPriceLayer.frame.origin = priceOrigin;
                    //                    infoPriceLayer.frame.size = priceSize;
                    infoPriceLayer.frame.size = CGSize(width: 30, height: priceSize.height);
                    infoPriceLayer.string = priceStr;
                    infoPriceLayer.isHidden = false;
                }else if point.y > chartHeight! &&  point.y < chartHeight! + 20 {
                    infoPriceLayer.isHidden = true;
                }else {
                    let pct = 1 - ((point.y - 20.0 - chartHeight!) / XStockGlobal.share.volumeHeihgt);
                    var volStr = "";
                    if maxVolume! >= 10000.0 {
                        volStr = XStockHelper.getFormatNumStr(num: (pct * maxVolume!) / 10000.0, dotCount: 2);
                    }else {
                        volStr = XStockHelper.getFormatNumStr(num: pct * maxVolume!, dotCount: 2);
                    }
                    let volSize = XStockHelper.getStrSize(str: volStr, fontSize: 9.0)
                    let volOrigin = CGPoint(x: 0, y: point.y - volSize.height / 2.0);
                    infoPriceLayer.frame.origin = volOrigin;
                    infoPriceLayer.frame.size = volSize;
                    //                    infoPriceLayer.frame.size = CGSize(width: 30, height: volSize.height);
                    infoPriceLayer.string = volStr;
                    infoPriceLayer.isHidden = false;
                }
                CATransaction.commit();
            }
        }else {
            infoPriceLayer.isHidden = true;
            infoTimeLayer.isHidden = true;
            infoPctLayer.isHidden = true;
        }
    }
    
    func adjustCroseeCurvePoint(point:CGPoint) -> (realPoint:CGPoint, idx:Int) {
        var resultPoint  = point;
        var idx = lroundf(Float(resultPoint.x / itemWidth!)) ;
        if idx >= realDataArr.count - 1 {
            idx = realDataArr.count - 1;
        }
        if idx <= 0 {
            idx = 0;
        }
        let maxHeight = self.bounds.height;
        var maxWidth :CGFloat = CGFloat(idx) * itemWidth!;
        if maxWidth >= chartWidth! {
            maxWidth = chartWidth!;
        }
        
        let rect = CGRect(x: chartLeftTopPoint!.x, y: chartLeftTopPoint!.y, width: maxWidth, height: maxHeight);
        if rect.contains(point) == false {
            var getX = point.x;
            var getY = point.y;
            if  point.x >= rect.maxX{
                getX = rect.maxX;
            }
            if  point.x <= 0{
                getX = 0;
            }
            if point.y >= rect.maxY {
                getY = rect.maxY;
            }
            if  point.y <= 0 {
                getY = 0;
            }
            resultPoint = CGPoint(x: getX, y: getY);
        }
        print("idxX的值 \(CGFloat(idx) * itemWidth!)")
        if XStockGlobal.share.kLineColumeType == .Solid {
            resultPoint = CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.45, y: resultPoint.y);
        }else {
            resultPoint = CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.35, y: resultPoint.y);
        }
        return (resultPoint, idx)
    }
    
//    ////长按时价格线和均价线上的小圆
//    func showCircles(point:CGPoint, idx:Int, show:Bool)  {
//        if show {
//            let idxObj : XStockTimeModel = realDataArr[idx] ;
//            let price : CGFloat = XStockHelper.getCGFloat(str: idxObj.price);
//            let avePrice : CGFloat = XStockHelper.getCGFloat(str: idxObj.avePrice);
//            let priceOffsetY : CGFloat = XStockHelper.getOffsetY(price: price, minPrice: minPrice, maxPrice: maxPrice, height: chartHeight!);
//            let avePriceOffsetY : CGFloat = XStockHelper.getOffsetY(price: avePrice, minPrice: minPrice, maxPrice: maxPrice, height: chartHeight!);
//            let pricePoint = CGPoint(x: CGFloat(idx) * itemWidth, y: priceOffsetY);
//            let avePricePoint = CGPoint(x: CGFloat(idx) * itemWidth, y: avePriceOffsetY);
//            let pricePath : UIBezierPath = UIBezierPath.init(arcCenter: pricePoint, radius: 2.5, startAngle: 0, endAngle: CGFloat(Double.pi) * 2.0, clockwise: true);
//            let avePricePath : UIBezierPath = UIBezierPath.init(arcCenter: avePricePoint, radius: 2.5, startAngle: 0, endAngle: CGFloat(Double.pi) * 2.0, clockwise: true);
//            CATransaction.begin();
//            CATransaction.setDisableActions(true);
//            priceCircleLayer.path = pricePath.cgPath;
//            avePriceCirleLayer.path = avePricePath.cgPath;
//            CATransaction.commit();
//        }else {
//            priceCircleLayer.isHidden = true;
//            avePriceCirleLayer.isHidden = true;
//        }
//    }
    
    ///渲染下方timeLayer的值
    func setupDownTimeLayers()  {
        if self.showType == XStockChartType.Five {
            if handler?.timeManager.fiveDayStrArr.count ?? 0 == 5 {
                downTimeLayer1.string = handler?.timeManager.fiveDayStrArr[0];
                downTimeLayer2.string = handler?.timeManager.fiveDayStrArr[1];
                downTimeLayer3.string = handler?.timeManager.fiveDayStrArr[2];
                downTimeLayer4.string = handler?.timeManager.fiveDayStrArr[3];
                downTimeLayer5.string = handler?.timeManager.fiveDayStrArr[4];
            }
            return;
        }
        if self.stkType == XStockType.HK {
            downTimeLayer1.string = "09:30";
            downTimeLayer3.string = "12:00/13:00";
            downTimeLayer5.string = "16:00";
            return;
        }
        if self.stkType == XStockType.HS {
            downTimeLayer1.string = "09:30";
            downTimeLayer3.string = "11:30/13:00";
            downTimeLayer5.string = "15:00";
            return;
        }
        if self.stkType == XStockType.US {
            downTimeLayer1.string = "09:30";
            downTimeLayer3.string = "12:00";
            downTimeLayer5.string = "16:00";
            return;
        }
        downTimeLayer1.string = "09:30";
        downTimeLayer3.string = "12:00";
        downTimeLayer5.string = "16:00";
    }
    
    
    
    
    
    
    
    
    
    
   
    
    
    
    
    
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
