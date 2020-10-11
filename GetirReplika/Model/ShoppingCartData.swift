//
//  ShoppingCartData.swift
//  GetirReplika
//
//  Created by Metilli on 9.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

protocol ShoppingCartDataDelegate {
    func didShoppingCartDataUpdated()
}
class ShoppingCartData {
    
    static let shared = ShoppingCartData()
    
    var delegate: ShoppingCartDataDelegate?
    
    private var _currentCart:[ShoppingCartModel] = []
    public var currentCart:[ShoppingCartModel]{
        get{
            return _currentCart
        }set{
            _currentCart = newValue
            delegate?.didShoppingCartDataUpdated()
        }
    }
    
    func addItemToCart(id:String){
        let shoppingCarItem = ShoppingCartData.shared.currentCart.first { (ShoppingCartModel) -> Bool in
            ShoppingCartModel.id == id
        }
        if let safeItem = shoppingCarItem{
                safeItem.count += 1
        }else{
            
            let itemToAdd = ProductData.shared.allProducts.first { (ProductModel) -> Bool in
                ProductModel.ID == id
            }
            if let safeItemToAdd = itemToAdd{
                let shoppingCartItem = ShoppingCartModel(id: safeItemToAdd.ID, name: safeItemToAdd.name, price: safeItemToAdd.price, count: 1, image: safeItemToAdd.image3xURL)
                ShoppingCartData.shared.currentCart.append(shoppingCartItem)
            }
        }
        delegate?.didShoppingCartDataUpdated()
    }
    
    func deleteItemFromCart(id:String){
        let shoppingCarItem = ShoppingCartData.shared.currentCart.first { (ShoppingCartModel) -> Bool in
            ShoppingCartModel.id == id
        }
        if let item = shoppingCarItem{
            item.count -= 1
            if item.count == 0{
                let index = ShoppingCartData.shared.currentCart.firstIndex { (ShoppingCartModel) -> Bool in
                    return ShoppingCartModel.id == id
                }
                if let safeIndex = index{
                    ShoppingCartData.shared.currentCart.remove(at: safeIndex)
                    print(ShoppingCartData.shared.currentCart.count)
                }
            }
        }
        delegate?.didShoppingCartDataUpdated()
    }
}
