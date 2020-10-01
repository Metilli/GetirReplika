	//
//  MainPageGetirButtons.swift
//  GetirReplika
//
//  Created by Metilli on 9.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit

class MainPageGetirButtons: UIButton {

    public var isOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton(){
        layer.cornerRadius = frame.size.height / 4
        backgroundColor = UIColor.white
        setTitleColor(UIColor(named: "getirPurple"), for: .normal)
        
        addTarget(self, action: #selector(MainPageGetirButtons.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed(){
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool){
        isOn = bool
        
        let titleColor = bool ? UIColor(named: "getirYellow") : UIColor(named: "getirPurple")
        let backgroundColor = bool ? UIColor(named: "getirPurple") : UIColor.white
        
        self.backgroundColor = backgroundColor
        setTitleColor(titleColor, for: .normal)
    }
}
