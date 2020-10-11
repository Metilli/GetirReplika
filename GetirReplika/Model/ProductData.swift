//
//  ProductData.swift
//  GetirReplika
//
//  Created by Metilli on 11.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import Firebase

class ProductData {
    
    static let shared = ProductData()
    
    public var allProducts:[ProductModel] = []
    
    private var _selectedItemID:String = ""
    public var selectedItemID:String{
        get{
            return _selectedItemID
        }set{
            _selectedItemID = newValue
        }
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
