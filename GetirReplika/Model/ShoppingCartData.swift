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
    
    private var _lastModifiedItemIndexPath: [IndexPath] = []
    public var lastModifiedItemIndexPath: [IndexPath]{
        get{
            return _lastModifiedItemIndexPath
        }
        set{
            _lastModifiedItemIndexPath = newValue
        }
    }
    
    private var _animatedCells:[String:IndexPath] = [:]
    public var animatedCells:[String:IndexPath]{
        get{
            return _animatedCells
        }set{
            _animatedCells = newValue
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
                ProductModel.id == id
            }
            if let safeItemToAdd = itemToAdd{
                let shoppingCartItem = ShoppingCartModel(id: safeItemToAdd.id, name: safeItemToAdd.name, price: safeItemToAdd.price, count: 1, image: safeItemToAdd.image3xURL)
                ShoppingCartData.shared.currentCart.append(shoppingCartItem)
            }
        }
        //delegate?.didShoppingCartDataUpdated()
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
                }
            }
        }
        //delegate?.didShoppingCartDataUpdated()
    }
    
    func clearCart(){
        ShoppingCartData.shared.currentCart.removeAll()
        //ShoppingCartData.shared.delegate?.didShoppingCartDataUpdated()
    }
    
    func fetchProductCount(id:String) -> Int{
        var productCount = 0
        let item = ShoppingCartData.shared.currentCart.first { (ShoppingCartModel) -> Bool in
            ShoppingCartModel.id == id
        }
        if let safeItem = item{
            productCount = safeItem.count
        }else {
            productCount = 0
        }
        return productCount
    }
    
    func getTotalCost() -> Double{
        var totalCost = 0.0
        for item in ShoppingCartData.shared.currentCart{
            totalCost += Double(item.price)! * Double(item.count)
        }
        return totalCost
    }
}
