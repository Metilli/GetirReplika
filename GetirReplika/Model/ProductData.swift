//
//  ProductData.swift
//  GetirReplika
//
//  Created by Metilli on 11.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class ProductData {
    
    static let shared = ProductData()
    
    public var allProducts:[ProductModel] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var _selectedItemID:String = ""
    public var selectedItemID:String{
        get{
            return _selectedItemID
        }set{
            _selectedItemID = newValue
        }
    }
    
    func changeFavorite(id: String){
        var productArray = [FavoriteProduct]()
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        do {
            productArray = try context.fetch(request)
        }
        catch{
            print(error)
        }
        let product = productArray.first{ (ProductModel) -> Bool in
            ProductModel.id == id
        }
        if let safeProduct = product{
            context.delete(safeProduct)
        }
        else{
            let newFavoriteProduct = FavoriteProduct(context: context)
            newFavoriteProduct.id = id
            newFavoriteProduct.isFavorite = true
            
            do{
                try context.save()
            }catch{
                print(error)
            }
        }
    }
    
    func fetchProductData(id: String) -> ProductModel?{
      let allProducts = ProductData.shared.allProducts
        let item = allProducts.first{ (ProductModel) -> Bool in
            ProductModel.id == id}
    
        if let safeItem = item{
            return safeItem
        }
        else {
            return nil
        }
    }
    
    func fetchProductisFavorite(id:String) -> Bool{
        var isFavorite = false
        var productArray = [FavoriteProduct]()
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        do {
            productArray = try context.fetch(request)
        }
        catch{
            print(error)
        }
        let product = productArray.first{ (ProductModel) -> Bool in
            ProductModel.id == id
        }
        if let _ = product{
            isFavorite = true
        }
        return isFavorite
    }
    
    func loadItemsFromDatabase(){
        let db = Firestore.firestore()
        db.collection("products").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let product = ProductModel(ID: document.documentID as String,
                                          mainCategory: document.data()["mainCategory"] as! String,
                                          subCategory: document.data()["subCategory"] as! String,
                                          name: document.data()["name"] as! String,
                                          price: document.data()["price"] as! String,
                                          priceDiscounted: document.data()["priceDiscounted"] as? String,
                                          unit: document.data()["unit"] as! String,
                                          description: document.data()["description"] as? String,
                                          image1xURL: document.data()["image1xURL"] as? String,
                                          image2xURL: document.data()["image2xURL"] as? String,
                                          image3xURL: document.data()["image3xURL"] as? String,
                                          imageName: document.data()["mainCategory"] as! String)
                    self.allProducts.append(product)
                }
            }
        }
    }
}
