//
//  ProductCategoryModel.swift
//  GetirReplika
//
//  Created by Metilli on 15.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class ProductCategoryModel{
    let text: String
    let mainCategory: String
    let image: UIImage
    var isSelected: Bool
    
    public init(text: String, mainCategory: String, image:UIImage, isSelected:Bool) {
        self.text = text
        self.mainCategory = mainCategory
        self.image = image
        self.isSelected = isSelected
    }
}
