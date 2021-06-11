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
    private var promotionCount = 4
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
        promotionCollectionView.register(UINib(nibName: K.CollectionViewCell.promotionCellNib, bundle: nil), forCellWithReuseIdentifier: K.CollectionViewCell.promotionCellIdentifier)
        
        addressTableView.dataSource = self
        addressTableView.register(UINib(nibName: K.TableViewCell.addressCellNib, bundle: nil), forCellReuseIdentifier: K.TableViewCell.addressCellIdentifier)
        
        getirButton.activateButton(bool: true)
        
        startAutoScroll(startTime: 5)
    }
    
    func startAutoScroll(startTime: Double){
        promotionScrollTimer = Timer.scheduledTimer(timeInterval: startTime, target: self, selector: #selector(autoScrollPromotions), userInfo: nil, repeats: true)
    }
    
    @objc func autoScrollPromotions(){
        indexPromotion += 1
        
        if indexPromotion < promotionCount - 1{
            promotionCollectionView.scrollToItem(at: IndexPath(row: indexPromotion, section: 0), at: .centeredHorizontally, animated: true)
        }else{
            indexPromotion = 0
            promotionCollectionView.scrollToItem(at: IndexPath(row: indexPromotion, section: 0), at: .centeredHorizontally, animated: false)
            indexPromotion = 1
            promotionCollectionView.scrollToItem(at: IndexPath(row: indexPromotion, section: 0), at: .centeredHorizontally, animated: true)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        promotionScrollTimer.invalidate()
        startAutoScroll(startTime: 5)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageFloat = (scrollView.contentOffset.x / scrollView.frame.size.width)
        let pageInt = Int(round(pageFloat))
        
        switch pageInt {
        case 0:
            indexPromotion = 2
            promotionCollectionView.scrollToItem(at: [0, indexPromotion], at: .left, animated: false)
        case promotionCount - 1:
            indexPromotion = 1
            promotionCollectionView.scrollToItem(at: [0, indexPromotion], at: .left, animated: false)
        default:
            break
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageFloat = (scrollView.contentOffset.x / scrollView.frame.size.width)
        let pageInt = Int(round(pageFloat))
        
        switch pageInt {
            case 0:
                indexPromotion = 2
                promotionCollectionView.scrollToItem(at: [0, indexPromotion], at: .left, animated: false)
            case promotionCount - 1:
                indexPromotion = 1
                promotionCollectionView.scrollToItem(at: [0, indexPromotion], at: .left, animated: false)
            default:
                break
        }
    }
    
    @IBAction func getirButtonsPressed(_ sender: MainPageGetirButtons) {
        
        if getirButton != sender{
            if getirButton.isOn == true{
                getirButton.activateButton(bool: false)
            }
        }
        if getirSuButton != sender{
            if getirSuButton.isOn == true{
                getirSuButton.activateButton(bool: false)
            }
        }
        if getirYemekButton != sender{
            if getirYemekButton.isOn == true{
                getirYemekButton.activateButton(bool: false)
            }
        }
        if getirBuyukButton != sender{
            if getirBuyukButton.isOn == true{
                getirBuyukButton.activateButton(bool: false)
            }
        }
        
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
            return promotionCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionViewCell.productCategoryCellIdentifier, for: indexPath) as! ProductCategoryCollectionViewCell
            cell.myImage.image = productCategories[indexPath.row].image
            cell.myLabel.text = productCategories[indexPath.row].text
            cell.indexPathRow = indexPath.row
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionViewCell.promotionCellIdentifier, for: indexPath) as! PromotionCollectionViewCell
            cell.promotionImage.image = UIImage(named: "promotionView\(indexPath.row+1)")
            
            return cell
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == promotionCollectionView{
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }else{
            return collectionView.cellForItem(at: indexPath)?.frame.size ?? CGSize(width: 80, height: 100)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productCollectionView{
            let selectedCell = productCollectionView.cellForItem(at: indexPath) as! ProductCategoryCollectionViewCell
            ProductCategoryData.shared.selectedCategory = selectedCell.myLabel.text!
            ProductCategoryData.shared.selectedCategoryIndexRow = selectedCell.indexPathRow
            performSegue(withIdentifier: K.Segue.productSegue, sender: self)
        }
    }
}



