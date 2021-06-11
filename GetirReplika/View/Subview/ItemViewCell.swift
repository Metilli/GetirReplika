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
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var productCountLabel: UILabel!
    
    private var strokeLayer = CAShapeLayer()
    public var isAnimatedBefore = false
    
    private var _id:String=""
    public var id:String{
        get{
            return _id
        }set{
            _id = newValue
        }
    }
    
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
    
    private var _productCount:Int = 0
    public var productCount:Int{
        get{
            return _productCount
        }
        set{
            let oldValue = self._productCount
            self._productCount = newValue
            self.productCountLabel.text = String(self.productCount)
            if oldValue == 0 && newValue > 0{
                productCountLabel.isHidden = false
                minusButton.isHidden = false
            }
            else if oldValue > 0 && newValue == 0{
                productCountLabel.isHidden = true
                minusButton.isHidden = true
            }
        }
    }
    
    private var _indexPath: [IndexPath] = []
    public var indexPath: [IndexPath]{
        get{
            return _indexPath
        }
        set{
            _indexPath = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shapeImage()
        
        productCountLabel.isHidden = true
        minusButton.isHidden = true
    }
    
    func shapeImage(){
        image.layer.borderColor = #colorLiteral(red: 0.8999999762, green: 0.8999999762, blue: 0.8999999762, alpha: 1)
        image.layer.borderWidth = 1
        image.layer.cornerRadius = 15
        image.clipsToBounds = false
        
        plusButton.layer.borderColor = #colorLiteral(red: 0.8999999762, green: 0.8999999762, blue: 0.8999999762, alpha: 1)
        plusButton.layer.borderWidth = 1
        plusButton.layer.cornerRadius = 5
        plusButton.clipsToBounds = true
        
        minusButton.layer.borderColor = #colorLiteral(red: 0.8999999762, green: 0.8999999762, blue: 0.8999999762, alpha: 1)
        minusButton.layer.borderWidth = 1
        minusButton.layer.cornerRadius = 5
        minusButton.clipsToBounds = true
    }
    
    func addBorderAnimation(){
        self.strokeLayer.fillColor = UIColor.clear.cgColor
        self.strokeLayer.strokeColor = UIColor(named: K.Colors.getirPurple)?.cgColor
        self.strokeLayer.lineWidth = 1

        // Create a rounded rect path using button's bounds.
        self.strokeLayer.path = CGPath.init(roundedRect: self.image.bounds, cornerWidth: 15, cornerHeight: 15, transform: nil) // same path like the empty one ...
        // Add layer to the button
        self.image.layer.addSublayer(self.strokeLayer)
        
        if self.isAnimatedBefore == false{
            // Create animation layer and add it to the stroke layer.
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = CGFloat(0.0)
            animation.toValue = CGFloat(1.0)
            animation.duration = 1
            animation.fillMode = CAMediaTimingFillMode.forwards
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            self.strokeLayer.add(animation, forKey: "circleAnimation\(id)")
        }
    }
    
    func removeBorderAnimation(){
        self.strokeLayer.removeFromSuperlayer()
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        ShoppingCartData.shared.lastModifiedItemIndexPath = indexPath
        ShoppingCartData.shared.addItemToCart(id: id)
        productCount = ShoppingCartData.shared.fetchProductCount(id: id)
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        ShoppingCartData.shared.lastModifiedItemIndexPath = indexPath
        ShoppingCartData.shared.deleteItemFromCart(id: id)
        productCount = ShoppingCartData.shared.fetchProductCount(id: id)
    }
}
