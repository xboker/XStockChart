//
//  XStockContainTitleView.swift
//  XStockChart
//  顶部bar, 用来切换图表显示类型
//  Created by xiekunpeng on 2019/7/24.
//  Copyright © 2019 xiekunpeng. All rights reserved.
//

import UIKit


typealias ChangeChartTypeBlock = (_ chartType:XStockChartType)->();


protocol XStockContainTitleViewDelegate {
    func chartTapChangeType(chartType:XStockChartType);
}



class XStockContainTitleView: UIView {

    init(titleArr:Array<String>!, frame:CGRect) {
        super.init(frame: frame);
        layoutBtns(titleArr: titleArr);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate :XStockContainTitleViewDelegate?;
    var changeB : ChangeChartTypeBlock?;
    var indexBtn : UIButton?;
    lazy var underLine: UIView = {
        let v = UIView.init(frame: CGRect(x: 0, y: self.bounds.size.height, width: self.bounds.size.width, height: 1));
        v.backgroundColor = XStockColor.getColor(hex: XStock_ContainViewUnderLineColor);
        return v;
    }()
    var idxLine : UIView?;
    
    func layoutBtns(titleArr:Array<String>!) {
        let btnWidth = self.bounds.size.width / CGFloat(titleArr.count);
        let btnHeight = self.bounds.size.height;
        
        for idx in 0...titleArr.count - 1 {
            let btn : UIButton = UIButton.init(frame: CGRect(x: CGFloat(idx) * btnWidth, y: 0, width: btnWidth, height: btnHeight));
            btn.tag = 4000 + idx;
            btn.addTarget(self, action: #selector(tapAction(sender:)), for: UIControl.Event.touchUpInside);
            btn.setTitleColor(XStockColor.getColor(hex: XStock_ContainTitleChooseColor), for: UIControl.State.selected);
            btn.setTitleColor(XStockColor.getColor(hex: XStock_ContainTitleUnChooseColor), for: UIControl.State.normal);
            btn.setTitle(titleArr[idx], for: UIControl.State.normal);
            btn.titleLabel?.adjustsFontSizeToFitWidth = true;
            if idx == 0 {
                self.indexBtn = btn;
                btn.isSelected = true;
                idxLine = UIView.init(frame: CGRect(x: 0, y: btnHeight - 1.0, width: btnWidth, height: 1));
                idxLine?.backgroundColor = XStockColor.getColor(hex: XStock_ContainTitleChooseColor);
                self.addSubview(idxLine!);
            }
            self.addSubview(underLine);
            self.addSubview(btn);
        }
    }
    
    @objc func tapAction(sender : UIButton)  {
        if self.indexBtn! == sender {
            return;
        }
        self.indexBtn?.isSelected = false;
        sender.isSelected = true;
        self.indexBtn! = sender;
        let idx = self.indexBtn!.tag - 4000;
        weak var weakSelf = self;
        UIView.animate(withDuration: 0.2) {
            weakSelf!.idxLine!.frame = CGRect(x: sender.frame.minX, y: sender.frame.maxY - 1, width: sender.bounds.width, height: 1);
        }
        
        self.delegate?.chartTapChangeType(chartType: XStockGlobal.share.chartShowTypeArr[idx]);
        if self.changeB != nil {
            self.changeB!(XStockGlobal.share.chartShowTypeArr[idx]);
        }
    }
    
    func clickChangeChartType(changeB:@escaping ChangeChartTypeBlock)  {
        self.changeB = changeB;
    }
    
    
    func reLayoutSelectBtn(showType:XStockChartType) {
        let idx = XStockGlobal.share.chartShowTypeArr.index(of: showType);
        let btn : UIButton = self.viewWithTag(4000 + idx!) as! UIButton;
        tapAction(sender: btn);
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
