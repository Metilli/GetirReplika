//
//  ShoppingCartModel.swift
//  GetirReplika
//
//  Created by Metilli on 9.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit

class ShoppingCartModel {
    public var id:String
    public var name:String
    public var price:String
    public var count:Int
    public var image:String
    
    init(id:String, name: String, price: String, count: Int, image:String) {
        self.id = id
        self.name = name
        self.price = price
        self.count = count
        self.image = image
    }
}
