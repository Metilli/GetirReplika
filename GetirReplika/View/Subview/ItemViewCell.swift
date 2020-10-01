//
//  ItemViewCell.swift
//  GetirReplika
//
//  Created by Metilli on 30.09.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class ItemViewCell: UICollectionViewCell {
    
    @IBOutlet public weak var image: UIImageView!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var unitLabel: UILabel!
    
    private var _priceString:String = ""
    public var priceString: String {
        get{
            return _priceString
        }
        set{
            _priceString = newValue
            priceLabel.text = "₺ " + _priceString
        }
    }
    
    private var _nameString:String = ""
    public var nameString: String {
        get{
            return _nameString
        }
        set{
            _nameString = newValue
            nameLabel.text = _nameString
        }
    }
    
    private var _unitString:String = ""
    public var unitString: String {
        get{
            return _unitString
        }
        set{
            _unitString = newValue
            unitLabel.text = _unitString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shapeImage()
    }
    
    func shapeImage(){
        image.layer.borderColor = #colorLiteral(red: 0.8999999762, green: 0.8999999762, blue: 0.8999999762, alpha: 1)
        image.layer.borderWidth = 1
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
    }
}
