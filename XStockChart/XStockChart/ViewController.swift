//
//  ViewController.swift
//  XStockChart
//
//  Created by xiekunpeng on 2019/7/23.
//  Copyright © 2019年 xiekunpeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XStockContainViewDelegate {

    var chartView : XStockContainView?;


    override func viewDidLoad() {
        super.viewDidLoad()
        chartView = XStockContainView.init(frame: CGRect(x: 0, y: 100, width: XScreenWidth, height: 440), stkCode: "665.HK", delegate: self, preClose: "2.45", showType: .Time);
        self.view.addSubview(chartView!)
    }


    
    
    //MARK:XStockContainViewDelegate
    func xStockChartTaped(showType: XStockChartType) {
        AppDelegate.delegate.isLandScape = true;
        UIDevice.switch(UIInterfaceOrientation.landscapeRight);
        print("当前方向  \(XStockHelper.getScreenDeriction())")
        let landscapeC = LandscapeViewController.init(stk: "665.HK", preClose: "2.45", showType: showType);
        let navC  = UINavigationController.init(rootViewController: landscapeC);
        self.navigationController!.present(navC, animated: true, completion: nil);
        print("去大图");
    }
    
    
    
    
}

