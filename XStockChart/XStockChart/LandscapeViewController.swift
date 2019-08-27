//
//  LandscapeViewController.swift
//  XStockChart
//
//  Created by xiekunpeng on 2019/8/27.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController, XStockContainViewDelegate {

    var chartView : XStockContainView?;
    
    
    init(stk:String!, preClose:String!, showType:XStockChartType, handler:XStockContainHandler!) {
        super.init(nibName: nil, bundle: nil);
        chartView = XStockContainView.init(frame: CGRect(x: 0, y: 20, width: XScreenWidth, height: XScreenHeight), stkCode: stk, delegate: self, preClose: "2.45", showType: showType);
        chartView?.handler = handler;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(chartView!)
        // Do any additional setup after loading the view.
    }
    

    //MARK:XStockContainViewDelegate
    func xStockTapToBigChart(showType: XStockChartType) {
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
