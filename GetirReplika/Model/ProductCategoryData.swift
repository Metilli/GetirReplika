//
//  ProductCategoryData.swift
//  GetirReplika
//
//  Created by Metilli on 18.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryDelegate {
    func didCategoryChanged()
}


class ProductCategoryData{
    
    static let shared = ProductCategoryData()
    
    var delegate: CategoryDelegate?
    
    private var _selectedCategory = ""
    public var selectedCategory: String {
        get
        {
            return _selectedCategory
        }
        set
        {
            for product in productCategories{
                if newValue == product.text{
                    product.isSelected = true
                    _selectedCategory = product.mainCategory
                    delegate?.didCategoryChanged()
                }else{
                    product.isSelected = false
                }
            }
        }
    }
    
    public var productCategories = [
        ProductCategoryModel(text: K.ProductCategories.newProductText, mainCategory: K.ProductCategories.newProductMainCategory, image: UIImage(named: K.ProductCategories.newProductImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.waterText, mainCategory: K.ProductCategories.waterMainCategory,image: UIImage(named: K.ProductCategories.waterImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.softDrinksText, mainCategory: K.ProductCategories.softDrinksMainCategory,image: UIImage(named: K.ProductCategories.softDrinksImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.vegitablesText, mainCategory: K.ProductCategories.vegitablesMainCategory,image: UIImage(named: K.ProductCategories.vegitablesImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.bakeryText, mainCategory: K.ProductCategories.bakeryMainCategory,image: UIImage(named: K.ProductCategories.bakeryImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.mainFoodsText, mainCategory: K.ProductCategories.mainFoodsMainCategory,image: UIImage(named: K.ProductCategories.mainFoodsImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.snacksText, mainCategory: K.ProductCategories.snacksMainCategory,image: UIImage(named: K.ProductCategories.snacksImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.iceCreamText,mainCategory: K.ProductCategories.iceCreamMainCategory, image: UIImage(named: K.ProductCategories.iceCreamImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.fastFoodText, mainCategory: K.ProductCategories.fastFoodMainCategory,image: UIImage(named: K.ProductCategories.fastFoodImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.breakfastText, mainCategory: K.ProductCategories.breakfastMainCategory,image: UIImage(named: K.ProductCategories.breakfastImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.fitText, mainCategory: K.ProductCategories.fitMainCategory,image: UIImage(named: K.ProductCategories.fitImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.personalCareText, mainCategory: K.ProductCategories.personalCareMainCategory,image: UIImage(named: K.ProductCategories.personalCareImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.homeCareText, mainCategory: K.ProductCategories.homeCareMainCategory,image: UIImage(named: K.ProductCategories.homeCareImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.homeStyleText, mainCategory: K.ProductCategories.homeStyleMainCategory,image: UIImage(named: K.ProductCategories.homeStyleImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.technologyText, mainCategory: K.ProductCategories.technologyMainCategory,image: UIImage(named: K.ProductCategories.technologyImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.petText, mainCategory: K.ProductCategories.petMainCategory,image: UIImage(named: K.ProductCategories.petImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.babyCareText, mainCategory: K.ProductCategories.babyCareMainCategory,image: UIImage(named: K.ProductCategories.babyCareImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.sexualText, mainCategory: K.ProductCategories.sexualMainCategory,image: UIImage(named: K.ProductCategories.sexualImage)!, isSelected: false),
        ProductCategoryModel(text: K.ProductCategories.wearText, mainCategory: K.ProductCategories.wearMainCategory,image: UIImage(named: K.ProductCategories.wearImage)!, isSelected: false)
    ]
}
