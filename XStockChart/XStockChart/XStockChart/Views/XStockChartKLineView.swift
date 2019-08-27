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
    ///记录拖动K线图时的最后位置
    var recordPoint : CGPoint?;
    ///记录pinch时的比例
    var recordWidth : CGFloat?;
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
    ///涨的成交量柱子
    lazy var upKLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.lineWidth = 1.0;
        layer.strokeColor = XStockColor.upColor().cgColor;
        return layer;
    }()
    ///跌得成交量柱子
    lazy var downKLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.lineWidth = 1.0;
        layer.strokeColor = XStockColor.downColor().cgColor;
        return layer;
    }()
    ///MA5线
    lazy var MA5Layer: CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.lineWidth = 1.0;
        layer.fillColor = UIColor.clear.cgColor;
        layer.strokeColor = XStockColor.getColor(hex: XStock_MA5Color).cgColor;
        return layer;
    }()
    ///MA10线
    lazy var MA10Layer: CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.lineWidth = 1.0;
        layer.fillColor = UIColor.clear.cgColor;
        layer.strokeColor = XStockColor.getColor(hex: XStock_MA10Color).cgColor;
        return layer;
    }()
    ///MA20线
    lazy var MA20Layer: CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.lineWidth = 1.0;
        layer.fillColor = UIColor.clear.cgColor;
        layer.strokeColor = XStockColor.getColor(hex: XStock_MA20Color).cgColor;
        return layer;
    }()
    ///MA30线
    lazy var MA30Layer: CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.lineWidth = 1.0;
        layer.fillColor = UIColor.clear.cgColor;
        layer.strokeColor = XStockColor.getColor(hex: XStock_MA30Color).cgColor;
        return layer;
    }()
    ///MA60线
    lazy var MA60Layer: CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.lineWidth = 1.0;
        layer.fillColor = UIColor.clear.cgColor;
        layer.strokeColor = XStockColor.getColor(hex: XStock_MA60Color).cgColor;
        return layer;
    }()
    ///显示MA的layer
    lazy var MATextLayer: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.fontSize = 9.0;
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.frame = CGRect(x: 10.0, y: -15.0, width: self.chartWidth! - 20, height: 15);
        return layer;
    }()
    ///成交量中涨layer
    lazy var upVolumeLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.lineWidth = 1.0;
        layer.strokeColor = XStockColor.upColor().cgColor;
        return layer;
    }()
    ///成交量中跌layer
    lazy var downVolumeLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.lineWidth = 1.0;
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
    ///当前数据的源
    var allDataArr : Array<XStockKLineModel> {
        get {
            var dataArr : Array<XStockKLineModel>?;
            if self.showType == XStockChartType.Day  {
                dataArr = handler?.kLineManager.dayKChartDataArr;
            }
            if self.showType == XStockChartType.Week  {
                dataArr = handler?.kLineManager.weekKChartDataArr;
            }
            if self.showType == XStockChartType.Month  {
                dataArr = handler?.kLineManager.monthKChartDataArr;
            }
            return dataArr ?? [];
        }
    }
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
    ///长按时十字线下方的时间信息layer
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
    ///长按时十字线左侧的价格信息layer
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
    ///长按时弹出的信息bar
    lazy var infoBar: XStockKLineInfoBar = {
            let layer = XStockKLineInfoBar.init(frame: CGRect(x: 0, y: 0, width: 90.0, height: 130.0))
            layer.isHidden = true;
            self.layer.addSublayer(layer);
            return layer;
    }()
    ///下方的时间信息1
    lazy var downTimeLayer1: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.fontSize = 9.0;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.alignmentMode = CATextLayerAlignmentMode.left;
        layer.frame = CGRect(x: 0, y: chartHeight!, width: 40.0, height: 20.0);
        return layer;
    }()
    ///下方的时间信息2
    lazy var downTimeLayer2: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.fontSize = 9.0;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.alignmentMode = CATextLayerAlignmentMode.center;
        layer.frame = CGRect(x: self.chartWidth! / 5.0 - 20.0, y: chartHeight!, width: 40.0, height: 20.0);
        return layer;
    }()
    ///下方的时间信息3
    lazy var downTimeLayer3: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.fontSize = 9.0;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.alignmentMode = CATextLayerAlignmentMode.center;
        layer.frame = CGRect(x: self.chartWidth! / 5.0 * 2.0 - 20.0, y: chartHeight!, width: 40.0, height: 20.0);
        return layer;
    }()
    ///下方的时间信息4
    lazy var downTimeLayer4: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.alignmentMode = CATextLayerAlignmentMode.center;
        layer.frame = CGRect(x: self.chartWidth! / 5.0 * 3 - 20.0, y: chartHeight!, width: 40.0, height: 20.0);
        return layer;
    }()
    ///下方的时间信息5
    lazy var downTimeLayer5: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.frame = CGRect(x: self.chartWidth! / 5.0 * 4 - 20.0, y: chartHeight!, width: 40.0, height: 20.0);
        layer.alignmentMode = CATextLayerAlignmentMode.center;
        return layer;
    }()
    ///下方的时间信息6
    lazy var downTimeLayer6: CATextLayer = {
        let layer = CATextLayer.init();
        layer.contentsScale = XStockContentScale;
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.fontSize = 9.0;
        layer.frame = CGRect(x: self.chartWidth! - 40.0, y: chartHeight!, width: 40.0, height: 20.0);
        layer.alignmentMode = CATextLayerAlignmentMode.right;
        return layer;
    }()
    ///K线上最高价格layer
    lazy var maxPriceLayer: CATextLayer = {
        let layer = CATextLayer.init();
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.contentsScale = XStockContentScale;
        layer.fontSize = 8;
        return layer;
    }()
    ///K线上最低价格layer
    lazy var minPriceLayer: CATextLayer = {
        let layer = CATextLayer.init();
        layer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        layer.contentsScale = XStockContentScale;
        layer.fontSize = 8;
        return layer;
    }()
    ///K线上最高/低价格连接线
    lazy var linkLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init();
        layer.lineWidth = 1.0;
        layer.strokeColor = XStockColor.getFairColor().cgColor;
        return layer;
    }()
    
    ///拖动手势
    lazy var panG: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(sender:)))
        return pan;
    }()
    ///捏合手势
    lazy var pinchG: UIPinchGestureRecognizer = {
        let pan = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchAction(sender:)));
        return pan;
    }()

    
    //MARK:-----------MethodBegin-----------
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
        self.addGestureRecognizer(panG);
        self.addGestureRecognizer(pinchG);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:绘制方法  获取数据成功, 拖动, 捏合之后重新计算
    ///获取数据成功, 拖动, 捏合之后重新计算
    func refreshAllContent()  {
        guard allDataArr.count > 0 else {
            return;
        }
        let itemCount = handler!.kLineManager.showItemCount!;
        if itemCount >= allDataArr.count {
            realDataArr = allDataArr;
        }else {
            if  handler!.kLineManager.lastPoint > itemCount {
                realDataArr = Array(allDataArr[handler!.kLineManager.lastPoint - itemCount + 1...handler!.kLineManager.lastPoint]);
            }else {
                realDataArr = Array(allDataArr[0...itemCount - 1]);
            }
        }
        var i = 0;
        var j = realDataArr.count - 1;
        maxPrice = 0.0;
        minPrice = 999999999999.0;
        maxVolume = 0.0;
        var highPIdx = 0;
        var lowPIdx = 0;
        var maxHighP : CGFloat = 0.0;
        var minLowP : CGFloat = 99999999999.0;
        
        while j >= i {
            let iHV = XStockHelper.getCGFloat(str: realDataArr[i].high);
            let jHV = XStockHelper.getCGFloat(str: realDataArr[j].high);
            let iLV = XStockHelper.getCGFloat(str: realDataArr[i].low);
            let jLV = XStockHelper.getCGFloat(str: realDataArr[j].low);
            let iVV = XStockHelper.getCGFloat(str: realDataArr[i].volume);
            let jVV = XStockHelper.getCGFloat(str: realDataArr[j].volume);
            
            let highI = XStockHelper.getCGFloat(str: realDataArr[i].high);
            let highJ = XStockHelper.getCGFloat(str: realDataArr[j].high);
            let lowI = XStockHelper.getCGFloat(str: realDataArr[i].low);
            let lowJ = XStockHelper.getCGFloat(str: realDataArr[j].low);
            if highI > highJ {
                if maxHighP <= highI {
                    maxHighP = highI;
                    highPIdx = i;
                }
            }else {
                if maxHighP <= highJ {
                    maxHighP = highJ;
                    highPIdx = j;
                }
            }
            if lowI < lowJ {
                if minLowP >= lowI {
                    minLowP = lowI;
                    lowPIdx = i;
                }
            }else {
                if minLowP >= lowJ {
                    minLowP = lowJ;
                    lowPIdx = j;
                }
            }
            if XStockHelper.getScreenDeriction() == .PortraitScreen && UIDevice.current.userInterfaceIdiom == .phone {
                let maxIMA = max(realDataArr[i].MA5 ?? 0.0, max(realDataArr[i].MA10 ?? 0.0, realDataArr[i].MA20 ?? 0.0));
                let maxJMA = max(realDataArr[j].MA5 ?? 0.0, max(realDataArr[j].MA10 ?? 0.0, realDataArr[j].MA20 ?? 0.0));
                maxPrice = max(maxPrice!, max(jHV, iHV));
                maxPrice = max(maxPrice!, max(maxIMA, maxJMA));
            }else {
                let maxIMA = max(realDataArr[i].MA5 ?? 0.0, max(realDataArr[i].MA10 ?? 0.0, max(realDataArr[i].MA20 ?? 0.0, max(realDataArr[i].MA30 ?? 0.0, realDataArr[i].MA60 ?? 0.0))));
                let maxJMA = max(realDataArr[j].MA5 ?? 0.0, max(realDataArr[j].MA10 ?? 0.0, max(realDataArr[j].MA20 ?? 0.0, max(realDataArr[j].MA30 ?? 0.0, realDataArr[j].MA60 ?? 0.0))));
                maxPrice = max(maxPrice!, max(jHV, iHV));
                maxPrice = max(maxPrice!, max(maxIMA, maxJMA));
            }
            minPrice = min(iLV, min(jLV, minPrice!));
            maxVolume = max(iVV, max(jVV, maxVolume!));
            i += 1;
            j -= 1;
        }
        ///价格放大缩小, 不绘制到顶部或者底部
        maxPrice = maxPrice! * 1.15;
        minPrice = minPrice! * 0.85;
        avePrice = (maxPrice! + minPrice!) / 2.0;
        itemWidth = chartWidth! / CGFloat(itemCount);
        setupKAndMAChartLayers(maxHighIdx: highPIdx, minLowIdx: lowPIdx);
        setupVolumeLinesLayers();
        setupDownTimeLayers();
        setupTextConentLayers();
    }
    
    ///初始化时调用一次
    func addLayers() {
        self.layer.addSublayer(downTimeLayer1);
        self.layer.addSublayer(downTimeLayer2);
        self.layer.addSublayer(downTimeLayer3);
        self.layer.addSublayer(downTimeLayer4);
        self.layer.addSublayer(downTimeLayer5);
        self.layer.addSublayer(downTimeLayer6);
        self.layer.addSublayer(upVolumeLayer);
        self.layer.addSublayer(downVolumeLayer);
        self.layer.addSublayer(vCrossLineLayer);
        self.layer.addSublayer(hCrossLineLayer);
        self.layer.addSublayer(upKLayer);
        self.layer.addSublayer(downKLayer);
        self.layer.addSublayer(MA5Layer);
        self.layer.addSublayer(MA10Layer);
        self.layer.addSublayer(MA20Layer);
        self.layer.addSublayer(left1Layer);
        self.layer.addSublayer(left2Layer);
        self.layer.addSublayer(left3Layer);
        self.layer.addSublayer(linkLayer);
        self.layer.addSublayer(maxPriceLayer);
        self.layer.addSublayer(minPriceLayer);
        if XStockHelper.getScreenDeriction() == .PortraitScreen && UIDevice.current.userInterfaceIdiom == .phone {
        }else {
            self.layer.addSublayer(MA30Layer);
            self.layer.addSublayer(MA60Layer);
        }
        self.layer.addSublayer(MATextLayer);
        self.layer.addSublayer(infoTimeLayer);
        self.layer.addSublayer(infoPriceLayer);
        if XStockHelper.getScreenDeriction() == .PortraitScreen {
            if XStockGlobal.share.alwaysShowVolumeDes == true {
                self.layer.addSublayer(volumeDesLayer);
                self.layer.addSublayer(volumeLayer);
            }
        }else {
            self.layer.addSublayer(volumeDesLayer);
            self.layer.addSublayer(volumeLayer);
        }
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
    
    ///图表上的文字相关layer, 初始化时调用一次
    func setupTextLayers()  {
        volumeDesLayer.contentsScale = XStockContentScale;
        volumeLayer.contentsScale = XStockContentScale;
        volumeLayer.fontSize = 10.0;
        volumeDesLayer.fontSize = 10.0;
        volumeLayer.foregroundColor = XStockColor.upColor().cgColor;
        volumeDesLayer.foregroundColor = XStockColor.xStock_TextColor().cgColor;
        if XStockHelper.getScreenDeriction() == .LandscapeScreen {
            volumeDesLayer.frame = CGRect(x:volumeLetTopPoint!.x - 40.0 , y: volumeLetTopPoint!.y + XStockGlobal.share.volumeHeihgt - 20.0, width: 40.0, height: 12.0);
            volumeLayer.frame = CGRect(x:volumeLetTopPoint!.x - 50.0 , y: volumeLetTopPoint!.y , width: 50.0, height: 12.0);
            volumeLayer.alignmentMode = .right;
            volumeDesLayer.alignmentMode = .right;
        }else {
            volumeDesLayer.frame = CGRect(x:volumeLetTopPoint!.x + 1 , y: volumeLetTopPoint!.y + XStockGlobal.share.volumeHeihgt - 14, width: 40.0, height: 12.0);
            volumeLayer.frame = CGRect(x:volumeLetTopPoint!.x + 1 , y: volumeLetTopPoint!.y + 1.0 , width: 50.0, height: 12.0);
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
    func setupVolumeLinesLayers()  {
        guard realDataArr.count > 0 else {
            return;
        }
        ///右侧留下20%(不让各个线挨着)
        let volumeLeftDownPoint = CGPoint(x: volumeLetTopPoint!.x, y: volumeLetTopPoint!.y + XStockGlobal.share.volumeHeihgt);
        let upPath = UIBezierPath.init();
        let downPath = UIBezierPath.init();
        for idx in 0...realDataArr.count - 1 {
            let idxObj : XStockKLineModel = realDataArr[idx];
            let offsetY = XStockHelper.getCGFloat(str: idxObj.volume) / maxVolume! * XStockGlobal.share.volumeHeihgt;
            let open : CGFloat = XStockHelper.getCGFloat(str: idxObj.open);
            let close : CGFloat = XStockHelper.getCGFloat(str: idxObj.close);
            if open < close  {
                upPath.move(to: CGPoint(x: volumeLeftDownPoint.x + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y));
                upPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x + itemWidth! * 0.8 + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y ));
                upPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x + itemWidth! * 0.8 + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y - offsetY));
                upPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x  + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y - offsetY));
                upPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y));
                if XStockGlobal.share.kLineColumeType == .Solid {
                    upVolumeLayer.fillColor = upVolumeLayer.strokeColor;
                }else {
                    upVolumeLayer.fillColor = XStockColor.xStock_BackColor().cgColor;
                }
            }else  {
                downPath.move(to: CGPoint(x: volumeLeftDownPoint.x + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y));
                downPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x + itemWidth! * 0.8 + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y ));
                downPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x + itemWidth! * 0.8 + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y - offsetY));
                downPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x  + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y - offsetY));
                downPath.addLine(to: CGPoint(x: volumeLeftDownPoint.x + CGFloat(idx) * itemWidth!, y: volumeLeftDownPoint.y));
                if XStockGlobal.share.kLineColumeType == .Solid {
                    downVolumeLayer.fillColor = downVolumeLayer.strokeColor;
                }else {
                    downVolumeLayer.fillColor = XStockColor.xStock_BackColor().cgColor;
                }
            }
        }
        upVolumeLayer.path = upPath.cgPath;
        downVolumeLayer.path = downPath.cgPath;
    }
    
    ///绘制K线的蜡烛图
    func setupKAndMAChartLayers(maxHighIdx : Int, minLowIdx : Int)  {
        guard realDataArr.count > 0 else {
            return;
        }
        ///右侧留下20%(不让各个线挨着)
        let upPath = UIBezierPath.init();
        let downPath = UIBezierPath.init();
        let MA5Path = UIBezierPath.init();
        let MA10Path = UIBezierPath.init();
        let MA20Path = UIBezierPath.init();
        let MA30Path = UIBezierPath.init();
        let MA60Path = UIBezierPath.init();
        let priceInfoPath = UIBezierPath.init();
        var MA5Moved = false;
        var MA10Moved = false;
        var MA20Moved = false;
        var MA30Moved = false;
        var MA60Moved = false;
        for idx in 0...realDataArr.count - 1 {
            let idxObj : XStockKLineModel = realDataArr[idx];
            let open : CGFloat = XStockHelper.getCGFloat(str: idxObj.open);
            let close : CGFloat = XStockHelper.getCGFloat(str: idxObj.close);
            let offsetHigh : CGFloat = XStockHelper.getOffsetY(price: XStockHelper.getCGFloat(str: idxObj.high), minPrice: minPrice!, maxPrice: maxPrice!, height: chartHeight!);
            let offsetLow : CGFloat = XStockHelper.getOffsetY(price: XStockHelper.getCGFloat(str: idxObj.low), minPrice: minPrice!, maxPrice: maxPrice!, height: chartHeight!);
            let offsetOpen : CGFloat = XStockHelper.getOffsetY(price: open, minPrice: minPrice!, maxPrice: maxPrice!, height: chartHeight!);
            let offsetClose : CGFloat = XStockHelper.getOffsetY(price: close, minPrice: minPrice!, maxPrice: maxPrice!, height: chartHeight!);
            CATransaction.begin();
            CATransaction.setDisableActions(true);
            if idx == maxHighIdx {
                priceInfoPath.move(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.4, y: offsetHigh));
                maxPriceLayer.string = XStockHelper.getFormatNumStr(num: XStockHelper.getCGFloat(str: realDataArr[idx].high), dotCount: priceDotCount);
                if idx >= realDataArr.count / 2 {
                    maxPriceLayer.alignmentMode = CATextLayerAlignmentMode.right;
                    maxPriceLayer.frame = CGRect(x:  CGFloat(idx) * itemWidth! + itemWidth! * 0.4 - 80.0, y: offsetHigh - 6.0, width: 50.0, height: 10.0);
                    priceInfoPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.4 - 30.0, y: offsetHigh - 3.0));
                }else {
                    maxPriceLayer.alignmentMode = CATextLayerAlignmentMode.left;
                    maxPriceLayer.frame = CGRect(x:  CGFloat(idx) * itemWidth! + itemWidth! * 0.4 + 30.0, y: offsetHigh - 6.0, width: 50.0, height: 10.0);
                    priceInfoPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.4 + 30.0, y: offsetHigh - 3.0));
                }
            }
            if idx == minLowIdx {
                priceInfoPath.move(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.4, y: offsetLow));
                minPriceLayer.string = XStockHelper.getFormatNumStr(num: XStockHelper.getCGFloat(str: realDataArr[idx].low), dotCount: priceDotCount);
                if idx >= realDataArr.count / 2 {
                    minPriceLayer.alignmentMode = CATextLayerAlignmentMode.right;
                    minPriceLayer.frame = CGRect(x:  CGFloat(idx) * itemWidth! + itemWidth! * 0.4 - 80.0, y: offsetLow + 2.0, width: 50.0, height: 10.0);
                    priceInfoPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.4 - 30.0, y: offsetLow + 6.0));
                }else {
                    minPriceLayer.alignmentMode = CATextLayerAlignmentMode.left;
                    minPriceLayer.frame = CGRect(x:  CGFloat(idx) * itemWidth! + itemWidth! * 0.4 + 30.0, y: offsetLow + 2.0, width: 50.0, height: 10.0);
                    priceInfoPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.4 + 30.0, y: offsetLow + 6.0));
                }
            }
            CATransaction.commit();
            ///绘制K线蜡烛
            if open <= close  {
                upPath.move(to: CGPoint(x: CGFloat(idx) * itemWidth!, y: offsetOpen));
                upPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.8, y: offsetOpen));
                upPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.8, y: offsetClose));
                upPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth! , y: offsetClose));
                upPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth!, y: offsetOpen));
                if XStockGlobal.share.kLineColumeType == .Solid {
                    upKLayer.fillColor = upKLayer.strokeColor;
                }else {
                    upKLayer.fillColor = XStockColor.xStock_BackColor().cgColor;
                }
                upPath.move(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.4, y: offsetOpen));
                upPath.addLine(to:CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.4, y: offsetLow));
                upPath.move(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.4, y: offsetClose));
                upPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.4, y: offsetHigh));
            }else  {
                downPath.move(to: CGPoint(x: CGFloat(idx) * itemWidth!, y: offsetClose));
                downPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.8, y: offsetClose));
                downPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.8, y: offsetOpen));
                downPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth! , y: offsetOpen));
                downPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth!, y: offsetClose));
                if XStockGlobal.share.kLineColumeType == .Solid {
                    downKLayer.fillColor = downKLayer.strokeColor;
                }else {
                    downKLayer.fillColor = XStockColor.xStock_BackColor().cgColor;
                }
                downPath.move(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.4, y: offsetClose));
                downPath.addLine(to:CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.4, y: offsetLow));
                downPath.move(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.4, y: offsetOpen));
                downPath.addLine(to: CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.4, y: offsetHigh));
            }
            ///绘制MA数据
            if MA5Moved {
                if idxObj.MA5 != nil {
                    MA5Path.addLine(to: CGPoint(x: itemWidth! * 0.4 + CGFloat(idx) * itemWidth!, y: XStockHelper.getOffsetY(price: idxObj.MA5!, minPrice: minPrice!, maxPrice: maxPrice!, height: chartHeight!)));
                }
            }else {
                if idxObj.MA5 != nil {
                    MA5Path.move(to: CGPoint(x: itemWidth! * 0.4 + CGFloat(idx) * itemWidth!, y: XStockHelper.getOffsetY(price: idxObj.MA5!, minPrice: minPrice!, maxPrice: maxPrice!, height: chartHeight!)));
                    MA5Moved = true;
                }
            }
            if MA10Moved {
                if idxObj.MA10 != nil {
                    MA10Path.addLine(to: CGPoint(x: itemWidth! * 0.4 + CGFloat(idx) * itemWidth!, y: XStockHelper.getOffsetY(price: idxObj.MA10!, minPrice: minPrice!, maxPrice: maxPrice!, height: chartHeight!)));
                }
            }else {
                if idxObj.MA10 != nil {
                    MA10Path.move(to: CGPoint(x: itemWidth! * 0.4 + CGFloat(idx) * itemWidth!, y: XStockHelper.getOffsetY(price: idxObj.MA10!, minPrice: minPrice!, maxPrice: maxPrice!, height: chartHeight!)));
                    MA10Moved = true;
                }
            }
            if MA20Moved {
                if idxObj.MA20 != nil {
                    MA20Path.addLine(to: CGPoint(x: itemWidth! * 0.4 + CGFloat(idx) * itemWidth!, y: XStockHelper.getOffsetY(price: idxObj.MA20!, minPrice: minPrice!, maxPrice: maxPrice!, height: chartHeight!)));
                }
            }else {
                if idxObj.MA20 != nil {
                    MA20Path.move(to: CGPoint(x: itemWidth! * 0.4 + CGFloat(idx) * itemWidth!, y: XStockHelper.getOffsetY(price: idxObj.MA20!, minPrice: minPrice!, maxPrice: maxPrice!, height: chartHeight!)));
                    MA20Moved = true;
                }
            }
            if MA30Moved {
                if idxObj.MA30 != nil {
                    MA30Path.addLine(to: CGPoint(x: itemWidth! * 0.4 + CGFloat(idx) * itemWidth!, y: XStockHelper.getOffsetY(price: idxObj.MA30!, minPrice: minPrice!, maxPrice: maxPrice!, height: chartHeight!)));
                }
            }else {
                if idxObj.MA30 != nil {
                    MA30Path.move(to: CGPoint(x: itemWidth! * 0.4 + CGFloat(idx) * itemWidth!, y: XStockHelper.getOffsetY(price: idxObj.MA30!, minPrice: minPrice!, maxPrice: maxPrice!, height: chartHeight!)));
                    MA30Moved = true;
                }
            }
            if MA60Moved {
                if idxObj.MA60 != nil {
                    MA60Path.addLine(to: CGPoint(x: itemWidth! * 0.4 + CGFloat(idx) * itemWidth!, y: XStockHelper.getOffsetY(price: idxObj.MA60!, minPrice: minPrice!, maxPrice: maxPrice!, height: chartHeight!)));
                }
            }else {
                if idxObj.MA60 != nil {
                    MA60Path.move(to: CGPoint(x: itemWidth! * 0.4 + CGFloat(idx) * itemWidth!, y: XStockHelper.getOffsetY(price: idxObj.MA60!, minPrice: minPrice!, maxPrice: maxPrice!, height: chartHeight!)));
                    MA60Moved = true;
                }
            }
        }
        linkLayer.path = priceInfoPath.cgPath;
        upKLayer.path = upPath.cgPath;
        downKLayer.path = downPath.cgPath;
        MA5Layer.path = MA5Path.cgPath;
        MA10Layer.path = MA10Path.cgPath;
        MA20Layer.path = MA20Path.cgPath;
        MA30Layer.path = MA30Path.cgPath;
        MA60Layer.path = MA60Path.cgPath;
    }
    
    ///设置显示内容,图表周边的价格, 成交量, 百分比等信息
    func setupTextConentLayers()  {
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
        
        if  realDataArr.count > 0 {
            let lastObj : XStockKLineModel = realDataArr.last!;
            setupMATextContent(obj: lastObj);
        }
    }
    
    ///设置MA数据显示的layer
    func setupMATextContent(obj:XStockKLineModel!)  {
        var muStr  :  NSMutableAttributedString?;
        let MA5Str   = "MA5:" + XStockHelper.getFormatNumStr(num: obj.MA5, dotCount: priceDotCount);
        let MA10Str  = "  MA10:" + XStockHelper.getFormatNumStr(num: obj.MA10, dotCount: priceDotCount);
        let MA20Str  = "  MA20:" + XStockHelper.getFormatNumStr(num: obj.MA20, dotCount: priceDotCount);
        let MA30Str  = "  MA30:" + XStockHelper.getFormatNumStr(num: obj.MA30, dotCount: priceDotCount);
        let MA60Str  = "  MA60:" + XStockHelper.getFormatNumStr(num: obj.MA60, dotCount: priceDotCount);
        if XStockHelper.getScreenDeriction() == .PortraitScreen && UIDevice.current.userInterfaceIdiom == .phone {
            muStr = NSMutableAttributedString.init(string: "MA   " + MA5Str + MA10Str + MA20Str);
        }else {
            muStr = NSMutableAttributedString.init(string: "MA   " + MA5Str + MA10Str + MA20Str + MA30Str + MA60Str);
        }
        let desRange = muStr!.string.range(of: String("MA   "));
        let MA5Range = muStr!.string.range(of: MA5Str);
        let MA10Range = muStr!.string.range(of: MA10Str);
        let MA20Range = muStr!.string.range(of: MA20Str);
        let MA30Range = muStr!.string.range(of: MA30Str);
        let MA60Range = muStr!.string.range(of: MA60Str);
        muStr?.addAttributes([NSAttributedString.Key.foregroundColor : XStockColor.xStock_TextColor().cgColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)], range: muStr!.string.getNSRange(desRange!));
        muStr?.addAttributes([NSAttributedString.Key.foregroundColor : XStockColor.getColor(hex: XStock_MA5Color).cgColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)], range: muStr!.string.getNSRange(MA5Range!));
        muStr?.addAttributes([NSAttributedString.Key.foregroundColor : XStockColor.getColor(hex: XStock_MA10Color).cgColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)], range: muStr!.string.getNSRange(MA10Range!));
        muStr?.addAttributes([NSAttributedString.Key.foregroundColor : XStockColor.getColor(hex: XStock_MA20Color).cgColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)], range: muStr!.string.getNSRange(MA20Range!));
        if XStockHelper.getScreenDeriction() == .PortraitScreen && UIDevice.current.userInterfaceIdiom == .phone {
        }else {
            muStr?.addAttributes([NSAttributedString.Key.foregroundColor : XStockColor.getColor(hex: XStock_MA30Color).cgColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)], range: muStr!.string.getNSRange(MA30Range!));
            muStr?.addAttributes([NSAttributedString.Key.foregroundColor : XStockColor.getColor(hex: XStock_MA60Color).cgColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)], range: muStr!.string.getNSRange(MA60Range!));
        }
        MATextLayer.string = muStr!;
    }
    
    //MARK: 手势方法集合
    ///滑动方法
    @objc func panAction(sender : UIPanGestureRecognizer) {
        if sender.state == UIPinchGestureRecognizer.State.began {
            recordPoint = CGPoint.zero;
        }
        if sender.state == UIPinchGestureRecognizer.State.changed {
            let point  = sender.translation(in: sender.view);
            let offsetCount : Int = lroundf(Float((recordPoint!.x - point.x) / itemWidth!));
            print("触发拖动 \(point.x),  记录点 \(recordPoint!.x)");
            handler?.kLineManager.lastPoint += offsetCount;
            if recordPoint!.x > point.x {
                if handler!.kLineManager.lastPoint >= allDataArr.count - 1 {
                    handler?.kLineManager.lastPoint = allDataArr.count - 1;
                }
            }else {
                if handler!.kLineManager.lastPoint <= XStock_MinKLineCount {
                    handler?.kLineManager.lastPoint = XStock_MinKLineCount;
                }
            }
            refreshAllContent();
            recordPoint = point;
        }
    }
    
    ///捏合手势
    @objc func pinchAction(sender : UIPinchGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            recordWidth = itemWidth!;
        }
        if sender.state == UIGestureRecognizer.State.changed {
            let getWidth : CGFloat = recordWidth! * sender.scale * 0.8;
            handler?.kLineManager.showItemCount = lroundf(Float(chartWidth! / getWidth));
            if handler!.kLineManager.showItemCount! >=  XStock_MaxKLineCount {
                handler?.kLineManager.showItemCount = XStock_MaxKLineCount;
            }
            if handler!.kLineManager.showItemCount! <= XStock_MinKLineCount {
                handler?.kLineManager.showItemCount = XStock_MinKLineCount;
            }
            refreshAllContent();
        }
    }
    
    ///长按弹出相关信息
    @objc func longPressAction(sender : UILongPressGestureRecognizer) {
        var  thePoint = sender.location(in: self);
        thePoint = adjustCroseeCurvePoint(point: thePoint).realPoint;
        let idx = adjustCroseeCurvePoint(point: thePoint).idx;
        if realDataArr.count > idx {
            let obj = realDataArr[idx];
            setupMATextContent(obj: obj);
        }
        if sender.state == .began {
            vCrossLineLayer.isHidden = false;
            hCrossLineLayer.isHidden = false;
            infoPriceLayer.isHidden = false;
            infoTimeLayer.isHidden = false;
            infoBar.isHidden = false;
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
                if self.realDataArr.count > 0 {
                    let obj = self.realDataArr.last;
                    self.setupMATextContent(obj: obj);
                }
            }
        }
    }
    
    ///长按时弹出的infoBar
    func showBar(point:CGPoint, idx:Int, show:Bool)  {
        if  show {
            CATransaction.begin();
            CATransaction.setDisableActions(true);
            if point.x > chartWidth! / 2.0 {
                infoBar.frame.origin = CGPoint(x: 30.0, y: 0)
            }else {
                infoBar.frame.origin = CGPoint(x: chartWidth!  - 90.0, y: 0);
            }
            CATransaction.commit();
            if realDataArr.count > idx {
                let model : XStockKLineModel = realDataArr[idx];
                infoBar.setupKLineContents(data: model, priceDot: priceDotCount);
            }
        }else {
            infoBar.isHidden = true;
        }
    }
    
    ///长按弹出十字线
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
                    infoPriceLayer.string = volStr;
                    infoPriceLayer.isHidden = false;
                }
                CATransaction.commit();
            }
        }else {
            infoPriceLayer.isHidden = true;
            infoTimeLayer.isHidden = true;
        }
    }
    
    ///换算长按时弹出的point
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
        resultPoint = CGPoint(x: CGFloat(idx) * itemWidth! + itemWidth! * 0.35, y: resultPoint.y);
        return (resultPoint, idx)
    }
    
    ///渲染下方timeLayer的值
    func setupDownTimeLayers()  {
        if realDataArr.count > 0 {
           downTimeLayer1.string = XStockHelper.getTimeStr(interval: realDataArr[0].timeInterval).monthDateStr!;
        }
        let sectionWidth = self.chartWidth! / 5.0;
        let idx2 = lroundf(Float(sectionWidth / itemWidth!));
        if realDataArr.count > idx2 {
            downTimeLayer2.string = XStockHelper.getTimeStr(interval: realDataArr[idx2].timeInterval).monthDateStr!;
        }
        let idx3 = lroundf(Float(sectionWidth * 2.0 / itemWidth!));
        if realDataArr.count > idx3 {
            downTimeLayer3.string = XStockHelper.getTimeStr(interval: realDataArr[idx3].timeInterval).monthDateStr!;
        }
        let idx4 = lroundf(Float(sectionWidth * 3.0 / itemWidth!));
        if realDataArr.count > idx4 {
            downTimeLayer4.string = XStockHelper.getTimeStr(interval: realDataArr[idx4].timeInterval).monthDateStr!;
        }
        let idx5 = lroundf(Float(sectionWidth * 4.0 / itemWidth!));
        if realDataArr.count > idx5 {
            downTimeLayer5.string = XStockHelper.getTimeStr(interval: realDataArr[idx5].timeInterval).monthDateStr!;
        }
        let idx6 = lroundf(Float(sectionWidth * 5.0 / itemWidth!));
        if realDataArr.count > idx6 {
            downTimeLayer6.string = XStockHelper.getTimeStr(interval: realDataArr[idx6].timeInterval).monthDateStr!;
        }  
    }
    
    
    
    
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
