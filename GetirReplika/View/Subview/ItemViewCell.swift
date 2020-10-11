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
            _productCount = newValue
            productCountLabel.text = String(productCount)
            if _productCount == 0{
                productCountLabel.isHidden = true
                minusButton.isHidden = true
            }else{
                productCountLabel.isHidden = false
                minusButton.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shapeImage()
        
        productCountLabel.isHidden = true
        minusButton.isHidden = true
        
        fetchItemData()
    }
    
    func shapeImage(){
        image.layer.borderColor = #colorLiteral(red: 0.8999999762, green: 0.8999999762, blue: 0.8999999762, alpha: 1)
        image.layer.borderWidth = 1
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        
        plusButton.layer.borderColor = #colorLiteral(red: 0.8999999762, green: 0.8999999762, blue: 0.8999999762, alpha: 1)
        plusButton.layer.borderWidth = 1
        plusButton.layer.cornerRadius = 5
        plusButton.clipsToBounds = true
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        ShoppingCartData.shared.addItemToCart(id: id)
        fetchItemData()
        ShoppingCartData.shared.delegate?.didShoppingCartDataUpdated()
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        ShoppingCartData.shared.deleteItemFromCart(id: id)
        fetchItemData()
        ShoppingCartData.shared.delegate?.didShoppingCartDataUpdated()
    }
    
    func fetchItemData(){
        let item = ShoppingCartData.shared.currentCart.first { (ShoppingCartModel) -> Bool in
            ShoppingCartModel.id == id
        }
        if let safeItem = item{
            productCount = safeItem.count
        }
    }
}
