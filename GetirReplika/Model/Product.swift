//
//  Product.swift
//  GetirReplika
//
//  Created by Metilli on 26.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

class Product {
    var ID: String
    var mainCategory: String
    var subCategory: String
    var name: String
    var price: String
    var priceDiscounted: String
    var unit: String
    var description: String
    var image1xURL: String
    var image2xURL: String
    var image3xURL: String
    var imageName: String
    
    init(ID: String, mainCategory: String, subCategory: String, name: String, price: String, priceDiscounted: String?, unit: String, description: String?, image1xURL: String?, image2xURL: String?, image3xURL: String?, imageName: String) {
        self.mainCategory = mainCategory
        self.subCategory = subCategory
        self.name = name
        self.price = price
        self.priceDiscounted = priceDiscounted ?? ""
        self.unit = unit
        self.description = description ?? ""
        self.image1xURL = image1xURL ?? ""
        self.image2xURL = image2xURL ?? ""
        self.image3xURL = image3xURL ?? ""
        self.ID = ID
        self.imageName = imageName
    }
}
