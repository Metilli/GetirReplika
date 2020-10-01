//
//  MenuItemButton.swift
//  GetirReplika
//
//  Created by Metilli on 16.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    override var isHighlighted: Bool{
        didSet{
            
        }
    }
    
    var isOn = false
    var bottomView: UIView {
        get
        {
            let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height / 10 ))
            bottomView.backgroundColor = UIColor(named: "getirYellow")
            return bottomView
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton(){
        backgroundColor = UIColor(named: "getirPurple")
        setTitleColor(UIColor.white, for: .normal)
        addTarget(self, action: #selector(MenuItemButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed(){
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool){
        isOn = bool
        
        if(isOn){
            self.addSubview(bottomView)
        }
        else{
            bottomView.removeFromSuperview()
        }
   }
    
}
