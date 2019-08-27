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
        self.view.addSubview(chartView)
    }


    
    //MARK:XStockContainViewDelegate
    func xStockTapToBigChart(showType: XStockChartType) {
        print("去大图");
    }
    
    
}

