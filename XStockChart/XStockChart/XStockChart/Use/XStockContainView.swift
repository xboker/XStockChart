//
//  XStockContainView.swift
//  XStockChart
//  实际使用时, 将这个view初始化添加到相应的位置
//  Created by xiekunpeng on 2019/7/24.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

import UIKit

//竖屏状态下, 图表(上下左右)距离父视图距离为20   所有的间隔也为20   可以根据效果调整为15;
private let Offset20 : CGFloat = 20.0;
//横屏状态下, 图表(左右)距离父视图距离为50
private let Offset70 : CGFloat = 50.0;


@objc protocol XStockContainViewDelegate {
   @objc optional func xStockTapToBigChart(showType:XStockChartType) -> Void;
}


class XStockContainView: UIView, XStockContainTitleViewDelegate, XStockContainHandlerDelegate {

    ///必须设置代理,以回调操作
    @objc var delegate : XStockContainViewDelegate?;
    ///股票的类型, 默认是沪深
    @objc var stkType  : XStockType = .HS;
    ///初始化后显示的图标类型, 默认是分时
    @objc var showType : XStockChartType = .Time;
    ///昨收价, 默认为nil
    @objc var preClose : String?;
    var idxView : UIView?;
    var viewsArr : Array<UIView> = [];
    
    
    ///获取数据的工具
    lazy var handler: XStockContainHandler = {
        let model = XStockContainHandler();
        model.delegate = self;
        return model;
    }()
    
    ///顶部切换图表的按钮
    lazy var titleView: XStockContainTitleView = {
        let v : XStockContainTitleView = XStockContainTitleView.init(titleArr: XStockGlobal.share.chartShowTitleArr, frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.size.width, height: XStock_ContainViewTitleHeight));
        v.delegate = self;
        return v;
    }()
    
    ///分时
    lazy var timeV: XStockChartTimeView = {
        let rect : CGRect?;
        if XStockHelper.getScreenDeriction() == XStockScreenDirectionType.LandscapeScreen {
            rect = CGRect(x: Offset70, y: Offset20 + XStock_ContainViewTitleHeight, width: self.bounds.width - Offset70 * 2.0, height: self.bounds.height - Offset20 * 2 - XStock_ContainViewTitleHeight);
        }else {
            rect = CGRect(x: Offset20, y: Offset20 + XStock_ContainViewTitleHeight, width: self.bounds.width - Offset20 * 2.0, height: self.bounds.height - Offset20 * 2 - XStock_ContainViewTitleHeight);
        }
        let v = XStockChartTimeView.init(frame: rect!, stkType: self.stkType, preClose: self.preClose, showType: XStockChartType.Time, handler: self.handler);
        return v;
    }()
    
    ///五日
    lazy var fiveV: XStockChartTimeView = {
        let rect : CGRect?;
        if XStockHelper.getScreenDeriction() == XStockScreenDirectionType.LandscapeScreen {
            rect = CGRect(x: Offset70, y: Offset20 + XStock_ContainViewTitleHeight, width: self.bounds.width - Offset70 * 2.0, height: self.bounds.height - Offset20 * 2 - XStock_ContainViewTitleHeight);
        }else {
            rect = CGRect(x: Offset20, y: Offset20 + XStock_ContainViewTitleHeight, width: self.bounds.width - Offset20 * 2.0, height: self.bounds.height - Offset20 * 2 - XStock_ContainViewTitleHeight);
        }
        let v = XStockChartTimeView.init(frame: rect!, stkType: self.stkType, preClose: self.preClose, showType: XStockChartType.Five, handler: self.handler);
        v.isHidden = true;
        return v;
    }()
    
    ///日K
    lazy var dayV: XStockChartKLineView = {
        let rect : CGRect?;
        if XStockHelper.getScreenDeriction() == XStockScreenDirectionType.LandscapeScreen {
            rect = CGRect(x: Offset70, y: Offset20 + XStock_ContainViewTitleHeight, width: self.bounds.width - Offset70 * 2.0 - Offset20, height: self.bounds.height - Offset20 * 2 - XStock_ContainViewTitleHeight);
        }else {
            rect = CGRect(x: Offset20, y: Offset20 + XStock_ContainViewTitleHeight, width: self.bounds.width - Offset20 * 2.0, height: self.bounds.height - Offset20 * 2 - XStock_ContainViewTitleHeight);
        }
        let v = XStockChartKLineView.init(frame: rect!, stkType: self.stkType, showType: XStockChartType.Day, handler: self.handler);
        v.isHidden = true;
        return v;
    }()
    
    ///周K
    lazy var weekV: XStockChartKLineView = {
        let rect : CGRect?;
        if XStockHelper.getScreenDeriction() == XStockScreenDirectionType.LandscapeScreen {
            rect = CGRect(x: Offset70, y: Offset20 + XStock_ContainViewTitleHeight, width: self.bounds.width - Offset70 * 2.0 - Offset20, height: self.bounds.height - Offset20 * 2 - XStock_ContainViewTitleHeight);
        }else {
            rect = CGRect(x: Offset20, y: Offset20 + XStock_ContainViewTitleHeight, width: self.bounds.width - Offset20 * 2.0, height: self.bounds.height - Offset20 * 2 - XStock_ContainViewTitleHeight);
        }
        let v = XStockChartKLineView.init(frame: rect!, stkType: self.stkType, showType: XStockChartType.Week, handler: self.handler);
        v.isHidden = true;
        return v;
    }()
    
    ///月K
    lazy var monthV: XStockChartKLineView = {
        let rect : CGRect?;
        if XStockHelper.getScreenDeriction() == XStockScreenDirectionType.LandscapeScreen {
            rect = CGRect(x: Offset70, y: Offset20 + XStock_ContainViewTitleHeight, width: self.bounds.width - Offset70 * 2.0 - Offset20, height: self.bounds.height - Offset20 * 2 - XStock_ContainViewTitleHeight);
        }else {
            rect = CGRect(x: Offset20, y: Offset20 + XStock_ContainViewTitleHeight, width: self.bounds.width - Offset20 * 2.0, height: self.bounds.height - Offset20 * 2 - XStock_ContainViewTitleHeight);
        }
        let v = XStockChartKLineView.init(frame: rect!, stkType: self.stkType, showType: XStockChartType.Month, handler: self.handler);
        v.isHidden = true;
        return v;
    }()
    
    ///点击手势
    lazy var tapG: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(goToBigChart(sender:)))
        return tap;
    }()

    ///代理方法
    @objc func goToBigChart(sender:UITapGestureRecognizer)  {
        self.delegate?.xStockTapToBigChart!(showType: self.showType);
    }
    
    
    //MARK:-----------MethodBegin-----------
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - frame: 图表显示的区域, 从上到下依次为:按钮V, offset, 图表V, offset, 成交量V, offset;
    ///   - stkCode: 股票的代码, 用来区分股票类型, 必须!
    ///   - delegate: 代理, 用来回调对图标的操作, 必须!
    ///   - preClose: 昨收价, 必须, 绘制涨跌幅的百分比要用到, 如果不能传入有效值, 则会默认取有效数据中的第一条价格用;
    ///   - showType: 默认显示的图标类型, 必须!
    init(frame: CGRect,
         stkCode:String!,
         delegate:XStockContainViewDelegate!,
         preClose:String!,
         showType:XStockChartType!) {
        super.init(frame: frame);
        self.delegate = delegate;
        self.stkType = XStockHelper.getStkType(stkCode: stkCode);
        if preClose != nil {
            self.preClose = preClose!;
        }
        self.addSubview(titleView);
        self.showType = showType!;
        titleView.reLayoutSelectBtn(showType: showType);
        
        handler.getChartData(dataType: XStockGetDataType.Default, showType: self.showType);
        for item in XStockGlobal.share.chartShowTypeArr {
            if item == .Time {
                self.addSubview(timeV);
                self.viewsArr.append(timeV);
                if showType == XStockChartType.Time {
                    self.idxView = timeV;
                }
            }
            if item == .Five {
                self.addSubview(fiveV);
                self.viewsArr.append(fiveV);
                if showType == XStockChartType.Five {
                    self.idxView = fiveV;
                }
            }
            if item == .Day {
                self.addSubview(dayV);
                self.viewsArr.append(dayV);
                if showType == XStockChartType.Day {
                    self.idxView = dayV;
                }
            }
            if item == .Week {
                self.addSubview(weekV);
                self.viewsArr.append(weekV);
                if showType == XStockChartType.Week {
                    self.idxView = weekV;
                }
            }
            if item == .Month {
                self.addSubview(monthV);
                self.viewsArr.append(monthV);
                if showType == XStockChartType.Month {
                    self.idxView = monthV;
                }
            }
        }
        if  XStockHelper.getScreenDeriction() != .LandscapeScreen {
            self.addGestureRecognizer(tapG);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        assert(true, "请使用上方带Frame的初始化");
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:XStockContainTitleViewDelegate   点击切换显示
    func chartTapChangeType(chartType: XStockChartType) {
        if showType == chartType {
            return;
        }
        showType = chartType;
        idxView?.isHidden = true;
        switch chartType {
        case .Time: do{
            idxView = timeV
            break;
        }
        case .Five: do {
            idxView = fiveV
            break;
            }
        case .Day: do {
            idxView = dayV;
            break;
            }
        case .Week: do {
            idxView = weekV;
            break;
            }
        case .Month: do {
            idxView = monthV;
            break;
            }
        default:
            break;
        }
        idxView?.isHidden = false;
        handler.getChartData(dataType: XStockGetDataType.Default, showType: chartType);
    }
    //MARK:XStockContainHandlerDelegate   获取数据成功
    func getChartDataSuccess(chartType: XStockChartType, success: Bool) {
        switch chartType {
        case .Time: do {
            timeV.refreshAllContent();
            break;
            }
        case .Five: do {
            fiveV.refreshAllContent();
            break;
            }
            
        case .Day: do {
            dayV.refreshAllContent();
            break;
            }
        case .Week: do {
            weekV.refreshAllContent();
            break;
            }
        case .Month: do {
            monthV.refreshAllContent();
            }
        default:break;
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
