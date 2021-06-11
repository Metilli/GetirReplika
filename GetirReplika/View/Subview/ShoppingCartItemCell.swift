//
//  ShoppingCartItemCell.swift
//  GetirReplika
//
//  Created by Metilli on 14.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Kingfisher

class ShoppingCartItemCell: UITableViewCell {
    
    @IBOutlet weak private var productImageView: UIImageView!
    @IBOutlet weak private var productNameLabel: UILabel!
    @IBOutlet weak private var productPriceLabel: UILabel!
    @IBOutlet weak private var minusButton: UIButton!
    @IBOutlet weak private var productCountLabel: UILabel!
    @IBOutlet weak private var plusButton: UIButton!
    
    private var _id:String = ""
    public var productId:String{
        get{
            return _id
        }
        set{
            _id = newValue
        }
    }
    
    private var _count:Int = 0
    public var productCount:Int{
        get{
            return _count
        }
        set{
            _count = newValue
            productCountLabel.text = String(productCount)
        }
    }
    
    private var _name:String = ""
    public var productName:String{
        get{
            return _name
        }set{
            _name = newValue
            productNameLabel.text = productName
        }
    }
    
    private var _price:String = ""
    public var productPrice:String{
        get{
            return _price
        }set{
            _price = newValue
            productPriceLabel.text = "₺ " + productPrice
        }
    }
    
    private var _imageURL:String = ""
    public var productImage:String{
        get{
            return _imageURL
        }set{
            _imageURL = newValue
            let url = URL(string: _imageURL)
            productImageView.kf.setImage(with: url!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shapeButtons()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func shapeButtons(){
        productImageView.layer.cornerRadius = 10
        productImageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        productImageView.layer.borderWidth = 1
        productImageView.clipsToBounds = true
        
        minusButton.layer.cornerRadius = 8
        minusButton.layer.borderWidth = 1
        minusButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        minusButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        plusButton.layer.cornerRadius = 8
        plusButton.layer.borderWidth = 1
        plusButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        plusButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        ShoppingCartData.shared.deleteItemFromCart(id: productId)
        productCount = ShoppingCartData.shared.fetchProductCount(id: productId)
        ShoppingCartData.shared.delegate?.didShoppingCartDataUpdated()
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        ShoppingCartData.shared.addItemToCart(id: productId)
        productCount = ShoppingCartData.shared.fetchProductCount(id: productId)
        ShoppingCartData.shared.delegate?.didShoppingCartDataUpdated()
    }
}
