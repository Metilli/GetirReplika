//
//  Product.swift
//  GetirReplika
//
//  Created by Metilli on 26.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

class ProductModel {
    var id: String
    var mainCategory: String
    var subCategory: String
    var name: String
    var price: String
    var priceDiscounted: String
    var unit: String
    var productDescription: String
    var image1xURL: String
    var image2xURL: String
    var image3xURL: String
    var imageName: String
    var isFavorite: Bool = false
    
    init(ID: String, mainCategory: String, subCategory: String, name: String, price: String, priceDiscounted: String?, unit: String, description: String?, image1xURL: String?, image2xURL: String?, image3xURL: String?, imageName: String, isFavorite: Bool?) {
        self.mainCategory = mainCategory
        self.subCategory = subCategory
        self.name = name
        self.price = price
        self.priceDiscounted = priceDiscounted ?? ""
        self.unit = unit
        self.productDescription = description ?? ""
        self.image1xURL = image1xURL ?? ""
        self.image2xURL = image2xURL ?? ""
        self.image3xURL = image3xURL ?? ""
        self.id = ID
        self.imageName = imageName
        self.isFavorite = isFavorite ?? false
    }
}
