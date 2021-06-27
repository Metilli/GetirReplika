//
//  ShoppingCartData.swift
//  GetirReplika
//
//  Created by Metilli on 9.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol ShoppingCartDataDelegate {
    func didShoppingCartDataUpdated()
}
class ShoppingCartData {
    
    static let shared = ShoppingCartData()
    
    var delegate: ShoppingCartDataDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var _currentCart:[ShoppingCartProduct] = []
    public var currentCart:[ShoppingCartProduct]{
        get{
            
            return _currentCart
        }set{
            _currentCart = newValue
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
                let shoppingCartProduct = ShoppingCartProduct(context: context)
                shoppingCartProduct.id = safeItemToAdd.id
                shoppingCartProduct.count = 1
                
                ShoppingCartData.shared.currentCart.append(shoppingCartProduct)
            }
        }
        saveContext()
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
                    context.delete(ShoppingCartData.shared.currentCart[safeIndex])
                    ShoppingCartData.shared.currentCart.remove(at: safeIndex)
                }
            }
        }
        saveContext()
    }
    
    func clearCart(){
        for item in ShoppingCartData.shared.currentCart{
            context.delete(item)
        }
        ShoppingCartData.shared.currentCart.removeAll()
        saveContext()
    }
    
    func fetchProductCount(id:String) -> Int{
        var productCount = 0
        var ShoppingCartProductArray = [ShoppingCartProduct]()
        let request: NSFetchRequest<ShoppingCartProduct> = ShoppingCartProduct.fetchRequest()
        do{
            ShoppingCartProductArray = try context.fetch(request)
        }catch{
            print(error)
        }
        let shoppingCartProduct = ShoppingCartProductArray.first { (ShoppingCartProduct) -> Bool in
            ShoppingCartProduct.id == id
        }
        if let safeShoppingCartProduct = shoppingCartProduct{
            productCount = Int(safeShoppingCartProduct.count)
        }
        return productCount
    }
    
    func fetchProductPrice(id:String) -> Double{
        let cartProduct = currentCart.first { (ShoppingCartProduct) -> Bool in
            ShoppingCartProduct.id == id
        }
        var price = 0.0
        if let safeCartProduct = cartProduct{
            let productModel = ProductData.shared.fetchProductData(id: safeCartProduct.id!)
            if let safeProductModel = productModel{
                if let safePrice = Double(safeProductModel.price){
                    price = safePrice
                }
            }
        }
        return price
    }
    
    func getTotalCost() -> Double{
        var totalCost = 0.0
        for item in ShoppingCartData.shared.currentCart{
            if let safeID = item.id{
                let price = ShoppingCartData.shared.fetchProductPrice(id: safeID)
                totalCost += price * Double(item.count)
            }
        }
        return totalCost
    }
    
    func saveContext(){
        do{
            try context.save()
            delegate?.didShoppingCartDataUpdated()
        }catch{
            print(error)
        }
    }
}
