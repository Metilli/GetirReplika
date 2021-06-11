//
//  MenuBarResuableView.swift
//  GetirReplika
//
//  Created by Metilli on 16.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class MenuBarResuableView: UICollectionReusableView {

    @IBOutlet weak var menuBarCollectionView: UICollectionView!
    
    private var productCategories = ProductCategoryData.shared.productCategories
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        menuBarCollectionView.dataSource = self
        menuBarCollectionView.delegate = self
        menuBarCollectionView.register(UINib(nibName: "MenuItemViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    func getWidthOfString(text: String, font: UIFont) -> CGFloat{
        let lbl = UILabel()
        lbl.text = text
        lbl.font = font
        lbl.sizeToFit()
        
        return lbl.frame.size.width
    }
    
    
}

extension MenuBarResuableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MenuItemViewCell
        
        cell.text = productCategories[indexPath.item].text
        if productCategories[indexPath.item].isSelected{
            cell.indicatorView.alpha = 1
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }else{
            cell.indicatorView.alpha = 0
        }
        return cell
    }
}

extension MenuBarResuableView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = productCategories[indexPath.item].text
        let font = UIFont.systemFont(ofSize: 17)
        
        return CGSize(width: getWidthOfString(text: text, font: font) + CGFloat(20), height: CGFloat(50))
    }
}
extension MenuBarResuableView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! MenuItemViewCell
        
        ProductCategoryData.shared.selectedCategory = cell.text!
        
        menuBarCollectionView.reloadData()
        
        menuBarCollectionView.deselectItem(at: indexPath, animated: false)
    }
}
