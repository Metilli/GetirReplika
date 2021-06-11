//
//  ProductCategoryViewController.swift
//  GetirReplika
//
//  Created by Metilli on 16.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ProductCategoryViewController: UIViewController {
    
    static let shared = ProductCategoryViewController()

    @IBOutlet weak var menuBarCollectionView: UICollectionView!
    @IBOutlet weak var productItemsCollectionView: UICollectionView!
    
    var shoppingCartLabel = UILabel()
    var shoppingCartView = UIView()
    
    var allProducts:[ProductModel] = ProductData.shared.allProducts
    var selectedCategoryProducts:[ProductModel] = []
    var subCategoriesUnique:[String] = []
    var subcategoryProductsWithSection:[[ProductModel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProductCategoryData.shared.delegate = self
        ShoppingCartData.shared.delegate = self
        
        menuBarCollectionView.dataSource = self
        menuBarCollectionView.delegate = self
        menuBarCollectionView.register(UINib(nibName: K.CollectionViewCell.menuBarCellNib, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.CollectionViewCell.menuBarCellIdentifier)
        
        productItemsCollectionView.dataSource = self
        productItemsCollectionView.delegate = self
        productItemsCollectionView.register(UINib(nibName: K.CollectionViewCell.productItemCellNib, bundle: nil), forCellWithReuseIdentifier: K.CollectionViewCell.productItemCellIdentifier)
        productItemsCollectionView.register(UINib(nibName: "ProductItemHeaderCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProductItemResuableCell")
        
        setNavgationBarItems()
        
        loadProductCollectionView()
        
        didShoppingCartDataUpdated()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ShoppingCartData.shared.delegate = self
        loadProductCollectionView()
        didShoppingCartDataUpdated()
    }
    
    func loadProductCollectionView(){
        let selectedCategory = ProductCategoryData.shared.selectedCategory
        selectedCategoryProducts = []
        for product in allProducts{
            if product.mainCategory == selectedCategory{
                selectedCategoryProducts.append(product)
            }
        }
        var subCategories: [String] = []
        for selectedProducts in selectedCategoryProducts{
            subCategories.append(selectedProducts.subCategory)
        }
        subCategoriesUnique = []
        subCategoriesUnique = Array(Set(subCategories)).sorted()
        subcategoryProductsWithSection = []
        for subcategory in subCategoriesUnique{
            subcategoryProductsWithSection.append(
                selectedCategoryProducts.filter { (Product) -> Bool in
                    return Product.subCategory == subcategory
                }
            )
        }
        productItemsCollectionView.reloadData()
    }
    
    func setNavgationBarItems(){
        navigationItem.title = "Ürünler"
        
        let shoppingCartButton = UIButton.init(type: .custom)
        shoppingCartButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = UIImage(systemName: "cart")
        imageView.backgroundColor = UIColor.white
        imageView.tintColor = UIColor(named: K.Colors.getirPurple)
        
        shoppingCartLabel = UILabel(frame: CGRect(x: 40, y: 0, width: 60, height: 30))
        shoppingCartLabel.text = "0"
        shoppingCartLabel.sizeThatFits(CGSize(width: 50, height: 30))
        shoppingCartLabel.backgroundColor = UIColor.opaqueSeparator
        shoppingCartLabel.textColor = UIColor.init(named: K.Colors.getirPurple)
        shoppingCartLabel.textAlignment = .right
        shoppingCartLabel.font = UIFont(name: "System", size: 12)
        
        shoppingCartView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        shoppingCartButton.frame = shoppingCartView.frame
        shoppingCartView.backgroundColor = UIColor.opaqueSeparator
        shoppingCartView.addSubview(shoppingCartButton)
        shoppingCartView.addSubview(imageView)
        shoppingCartView.addSubview(shoppingCartLabel)
        shoppingCartView.layer.cornerRadius = 10
        shoppingCartView.layer.borderWidth = 0
        shoppingCartView.clipsToBounds = true
        
        let barButton = UIBarButtonItem.init(customView: shoppingCartView)
        navigationItem.rightBarButtonItem = barButton
        shoppingCartView.isHidden = true
    }
    
    @objc func buttonPressed(){
        performSegue(withIdentifier: K.Segue.shoppingCartSegue, sender: self)
    }
}

extension ProductCategoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuBarCollectionView{
            return 0
        }else{
            return subcategoryProductsWithSection[section].count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == menuBarCollectionView{
            return 1
        }else{
            return subcategoryProductsWithSection.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuBarCollectionView
        {
            let cell = UICollectionViewCell()
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionViewCell.productItemCellIdentifier, for: indexPath) as! ItemViewCell
            let url = URL(string: subcategoryProductsWithSection[indexPath.section][indexPath.row].image3xURL)
            cell.indexPath = [indexPath]
            cell.id = subcategoryProductsWithSection[indexPath.section][indexPath.row].ID
            cell.image.kf.setImage(with: url!)
            cell.nameString = subcategoryProductsWithSection[indexPath.section][indexPath.row].name
            cell.priceString = subcategoryProductsWithSection[indexPath.section][indexPath.row].price
            cell.unitString = subcategoryProductsWithSection[indexPath.section][indexPath.row].unit
            cell.productCount = ShoppingCartData.shared.fetchProductCount(id: cell.id)
            if cell.productCount > 0{
                if ShoppingCartData.shared.animatedCells[cell.id] == nil{
                    cell.isAnimatedBefore = false
                    ShoppingCartData.shared.animatedCells[cell.id] = indexPath
                }else {
                    cell.isAnimatedBefore = true
                }
                cell.addBorderAnimation()
            }else{
                ShoppingCartData.shared.animatedCells.removeValue(forKey: cell.id)
                cell.isAnimatedBefore = false
                cell.removeBorderAnimation()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == menuBarCollectionView{
            switch kind
            {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: K.CollectionViewCell.menuBarCellIdentifier, for: indexPath)
                return headerView
            default:
                fatalError()
            }
        }else{
            switch kind
            {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProductItemResuableCell", for: indexPath) as! ProductItemHeaderCell
                headerView.label.text = subcategoryProductsWithSection[indexPath.section][0].subCategory
                return headerView
            default:
                fatalError()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productItemsCollectionView{
            return CGSize(width: 120, height: 250)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}

extension ProductCategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == menuBarCollectionView{
            return CGSize(width: collectionView.frame.width, height: 50) //add your height here
        }
        else{
            return CGSize(width: collectionView.frame.width, height: 30)
        }
    }
}

extension ProductCategoryViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productItemsCollectionView{
            let selectedCell = productItemsCollectionView.cellForItem(at: indexPath) as! ItemViewCell
            ProductData.shared.selectedItemID = selectedCell.id
            performSegue(withIdentifier: K.Segue.itemDetailViewSegue, sender: self)
        }
    }
}

extension ProductCategoryViewController: CategoryDelegate{
    func didCategoryChanged() {
        loadProductCollectionView()
    }
}

extension ProductCategoryViewController: ShoppingCartDataDelegate{
    func didShoppingCartDataUpdated() {
        
        let totalCost = ShoppingCartData.shared.getTotalCost()
        
        if totalCost > 0 {
            shoppingCartView.isHidden = false
        }else{
            shoppingCartView.isHidden = true
        }
        
        shoppingCartLabel.text = "₺ "+String(format: "%.2f",totalCost)
        
        //productItemsCollectionView.reloadData()
        productItemsCollectionView.reloadItems(at: ShoppingCartData.shared.lastModifiedItemIndexPath)
    }
}

