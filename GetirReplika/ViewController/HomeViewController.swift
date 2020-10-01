//
//  HomeViewController.swift
//  GetirReplika
//
//  Created by Metilli on 7.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var promotionCollectionView: UICollectionView!
    
    @IBOutlet weak var getirButton: MainPageGetirButtons!
    @IBOutlet weak var getirYemekButton: MainPageGetirButtons!
    @IBOutlet weak var getirBuyukButton: MainPageGetirButtons!
    @IBOutlet weak var getirSuButton: MainPageGetirButtons!
    
    @IBOutlet weak var estimationTimeLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    
    private var promotionScrollTimer: Timer! = nil
    private var indexPromotion = 0
    
    @IBOutlet weak var getirButtonsStackView: UIStackView!
    
    let productCategories = ProductCategoryData.shared.productCategories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        productCollectionView.register(UINib(nibName: K.CollectionViewCell.productCategoryCellNib, bundle: nil), forCellWithReuseIdentifier: K.CollectionViewCell.productCategoryCellIdentifier)
        
        promotionCollectionView.dataSource = self
        promotionCollectionView.delegate = self
        promotionCollectionView.register(UINib(nibName: K.CollectionViewCell.mapCellNib, bundle: nil), forCellWithReuseIdentifier: K.CollectionViewCell.mapCellIdentifier)
        promotionCollectionView.register(UINib(nibName: K.CollectionViewCell.promotionCellNib, bundle: nil), forCellWithReuseIdentifier: K.CollectionViewCell.promotionCellIdentifier)
        
        addressTableView.dataSource = self
        addressTableView.register(UINib(nibName: K.TableViewCell.addressCellNib, bundle: nil), forCellReuseIdentifier: K.TableViewCell.addressCellIdentifier)
        
        getirButton.activateButton(bool: true)
        
        startAutoScroll(startTime: 3)
    }
    
    @objc func autoScrollPromotions(){
        indexPromotion += 1
        if indexPromotion > 2 {
            indexPromotion = 0
        }
        
        promotionCollectionView.scrollToItem(at: IndexPath(row: indexPromotion, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func startAutoScroll(startTime: Double){
        promotionScrollTimer = Timer.scheduledTimer(timeInterval: startTime, target: self, selector: #selector(autoScrollPromotions), userInfo: nil, repeats: true)
    }
    
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableViewCell.addressCellIdentifier, for: indexPath) as! AddressCellTableViewCell
        DispatchQueue.main.async {
            cell.frame.size.height = 60
        }
        return cell
    }
}

extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollectionView{
            return productCategories.count
        }else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionViewCell.productCategoryCellIdentifier, for: indexPath) as! ProductCategoryCollectionViewCell
            cell.myImage.image = productCategories[indexPath.row].image
            cell.myLabel.text = productCategories[indexPath.row].text
            return cell
        }
        else
        {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionViewCell.mapCellIdentifier, for: indexPath) as! MapCollectionViewCell
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionViewCell.promotionCellIdentifier, for: indexPath) as! PromotionCollectionViewCell
                cell.promotionImage.image = UIImage(named: "promotionView\(indexPath.row)")
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == promotionCollectionView{
            return CGSize(width: collectionView.frame.size.width, height: (collectionView.backgroundView?.frame.size.height)!)
        }else{
            return collectionView.cellForItem(at: indexPath)?.frame.size ?? CGSize(width: 0, height: 0)
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == promotionCollectionView{
            promotionScrollTimer.invalidate()
            startAutoScroll(startTime: 5)
        }
        else {
            let selectedCell = productCollectionView.cellForItem(at: indexPath) as! ProductCategoryCollectionViewCell
            ProductCategoryData.shared.selectedCategory = selectedCell.myLabel.text!
            performSegue(withIdentifier: K.Segue.productSegue, sender: self)
        }
    }
    
}



