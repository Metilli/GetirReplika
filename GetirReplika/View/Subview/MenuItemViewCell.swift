//
//  MenuItemViewCell.swift
//  GetirReplika
//
//  Created by Metilli on 17.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class MenuItemViewCell: UICollectionViewCell {

    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    
    public var text: String? {
        didSet{
            label.text = text
            resizeCell()
        }
    }
    
    func resizeCell(){
        self.frame.size.height = 50
        self.frame.size.width = label.intrinsicContentSize.width + CGFloat(20)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
