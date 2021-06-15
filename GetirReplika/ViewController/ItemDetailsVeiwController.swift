//
//  ItemDetailsVeiwController.swift
//  GetirReplika
//
//  Created by Metilli on 11.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class ItemDetailsVeiwController: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var addCartButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countStackView: UIStackView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    private var id:String = ""
    
    private var _count:Int = 0
    public var count:Int{
        get{
            return _count
        }
        set{
            _count = newValue
            countLabel.text = String(_count)
            if _count > 0 {
                addCartButton.isHidden = true
                countStackView.isHidden = false
            }else{
                addCartButton.isHidden = false
                countStackView.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shapeButtons()
        fetchItemData(ID: ProductData.shared.selectedItemID)
    }
    
    func shapeButtons(){
        addCartButton.layer.cornerRadius = 15
        addCartButton.clipsToBounds = true
        
        minusButton.layer.cornerRadius = 8
        minusButton.layer.borderWidth = 1
        minusButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        minusButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        plusButton.layer.cornerRadius = 8
        plusButton.layer.borderWidth = 1
        plusButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        plusButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    func fetchItemData(ID: String){
        if let safeItem = ProductData.shared.fetchProductData(id: ID){
            id = safeItem.id
            let url = URL(string: safeItem.image3xURL)
            productImage.kf.setImage(with: url!)
            priceLabel.text = "₺ " + safeItem.price
            nameLabel.text = safeItem.name
            unitLabel.text = safeItem.unit
            if safeItem.isFavorite{
                favoriteButton.image = UIImage(systemName: K.SystemImages.heartFill)
                favoriteButton.tintColor = UIColor(named: K.Colors.getirYellow)
            }else{
                favoriteButton.image = UIImage(systemName: K.SystemImages.heart)
                favoriteButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            
            count = ShoppingCartData.shared.fetchProductCount(id: id)
        }
    }
    
    @IBAction func addCartPressed(_ sender: Any) {
        ShoppingCartData.shared.addItemToCart(id: id)
        count = ShoppingCartData.shared.fetchProductCount(id: id)
        ShoppingCartData.shared.delegate?.didShoppingCartDataUpdated()
    }
    
    @IBAction func minusPressed(_ sender: Any) {
        ShoppingCartData.shared.deleteItemFromCart(id: id)
        count = ShoppingCartData.shared.fetchProductCount(id: id)
        ShoppingCartData.shared.delegate?.didShoppingCartDataUpdated()
    }
    
    @IBAction func plusPressed(_ sender: Any) {
        ShoppingCartData.shared.addItemToCart(id: id)
        count = ShoppingCartData.shared.fetchProductCount(id: id)
        ShoppingCartData.shared.delegate?.didShoppingCartDataUpdated()
    }
    
    @IBAction func favoritePressed(_ sender: Any) {
        ProductData.shared.changeFavorite(id: id)
        fetchItemData(ID: id)
    }
}
