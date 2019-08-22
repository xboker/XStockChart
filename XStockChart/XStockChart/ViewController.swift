//
//  ViewController.swift
//  XStockChart
//
//  Created by xiekunpeng on 2019/7/23.
//  Copyright © 2019年 xiekunpeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XStockContainViewDelegate {

    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        let chartView = XStockContainView.init(frame: CGRect(x: 0, y: 100, width: XScreenWidth, height: 440), stkCode: "665.HK", delegate: self, preClose: "2.45", showType: .Time);
        chartView.delegate = self;
        self.view.addSubview(chartView)
        
        
//        let str = "撒饭大师傅";
//        print("强制转换的结果: \(XStockHelper.getCGFloat(str: str))");
//        print("强制转换的结果: \(str.CGFloatValue())");
        
    }


    
    //MARK:XStockContainViewDelegate
    func xStockTapToBigChart(showType: XStockChartType) {
        print("去大图");
    }
    
    
}

