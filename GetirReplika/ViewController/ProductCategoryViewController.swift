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
    
    @IBOutlet weak var menuBarCollectionView: UICollectionView!
    @IBOutlet weak var productItemsCollectionView: UICollectionView!
    
    var allProducts:[Product] = []
    var selectedCategoryProducts:[Product] = []
    var subCategoriesUnique:[String] = []
    var subcategoryProductsWithSection:[[Product]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProductCategoryData.shared.delegate = self
        
        loadItemsFromDatabase()
        
        menuBarCollectionView.dataSource = self
        menuBarCollectionView.delegate = self
        menuBarCollectionView.register(UINib(nibName: K.CollectionViewCell.menuBarCellNib, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.CollectionViewCell.menuBarCellIdentifier)
        
        productItemsCollectionView.dataSource = self
        productItemsCollectionView.delegate = self
        productItemsCollectionView.register(UINib(nibName: K.CollectionViewCell.productItemCellNib, bundle: nil), forCellWithReuseIdentifier: K.CollectionViewCell.productItemCellIdentifier)
        productItemsCollectionView.register(UINib(nibName: "ProductItemHeaderCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProductItemResuableCell")
        
        title = "Ürünler"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func loadItemsFromDatabase(){
        let db = Firestore.firestore()
        db.collection("products").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let product = Product(ID: document.documentID as String,
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
                self.loadProductCollectionView()
            }
        }
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
        subCategoriesUnique = Array(Set(subCategories))
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
            cell.image.kf.setImage(with: url!)
            cell.nameString = subcategoryProductsWithSection[indexPath.section][indexPath.row].name
            cell.priceString = subcategoryProductsWithSection[indexPath.section][indexPath.row].price
            cell.unitString = subcategoryProductsWithSection[indexPath.section][indexPath.row].unit
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

extension ProductCategoryViewController: CategoryDelegate{
    func didCategoryChanged() {
        loadProductCollectionView()
    }
}
