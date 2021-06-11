//
//  MainPageViewCell.swift
//  GetirReplika
//
//  Created by Metilli on 8.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class ProductCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var myLabel: UILabel!
    public var indexPathRow: Int = 0
    private var shadowLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shapeImage()
    }
    
    func shapeImage(){
        myImage.layer.borderColor = #colorLiteral(red: 0.8999999762, green: 0.8999999762, blue: 0.8999999762, alpha: 1)
        myImage.layer.borderWidth = 1
        myImage.layer.cornerRadius = 15
        myImage.clipsToBounds = true
    }
    
}
