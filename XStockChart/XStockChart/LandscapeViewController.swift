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
    
    
    init(stk:String!, preClose:String!, showType:XStockChartType) {
        super.init(nibName: nil, bundle: nil);
        chartView = XStockContainView.init(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 30), stkCode: stk, delegate: self, preClose: "2.45", showType: showType);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true;
        self.view.backgroundColor = UIColor.white;
        self.view.addSubview(chartView!)
        // Do any additional setup after loading the view.
    }
 
    
    //MARK:XStockContainViewDelegate
    func xStockChartTaped(showType: XStockChartType) {
        AppDelegate.delegate.isLandScape = false;
        UIDevice.switchOrientation(orientation: UIInterfaceOrientation.portrait);
        self.dismiss(animated: true, completion: nil);
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
