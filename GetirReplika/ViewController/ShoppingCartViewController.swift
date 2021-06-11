//
//  ShoppingCartViewController.swift
//  GetirReplika
//
//  Created by Metilli on 14.10.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController {

    @IBOutlet weak var shoppingTableView: UITableView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShoppingCartData.shared.delegate = self
        
        shoppingTableView.delegate = self
        shoppingTableView.dataSource = self
        shoppingTableView.register(UINib(nibName: K.TableViewCell.shoppingCartItemNib, bundle: nil), forCellReuseIdentifier: K.TableViewCell.shoppingCartItemIdentifier)
        // Do any additional setup after loading the view.
    }
    
    func shapeLayers(){
        proceedButton.layer.cornerRadius = 10
        proceedButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        totalCostLabel.layer.cornerRadius = 10
        totalCostLabel.layer.borderWidth = 1
        totalCostLabel.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        totalCostLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    @IBAction func clearShoppingCartPressed(_ sender: UIBarButtonItem) {
        ShoppingCartData.shared.clearCart()
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ShoppingCartData.shared.delegate = self
        didShoppingCartDataUpdated()
    }
}

extension ShoppingCartViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingCartData.shared.currentCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableViewCell.shoppingCartItemIdentifier, for: indexPath) as! ShoppingCartItemCell
        cell.productId = ShoppingCartData.shared.currentCart[indexPath.item].id
        cell.productName = ShoppingCartData.shared.currentCart[indexPath.item].name
        cell.productPrice = ShoppingCartData.shared.currentCart[indexPath.item].price
        cell.productCount = ShoppingCartData.shared.currentCart[indexPath.item].count
        cell.productImage = ShoppingCartData.shared.currentCart[indexPath.item].image
        return cell
    }
    
}

extension ShoppingCartViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! ShoppingCartItemCell
        ProductData.shared.selectedItemID = selectedCell.productId
        performSegue(withIdentifier: K.Segue.itemDetailViewSegue, sender: self)
    }
}

extension ShoppingCartViewController: ShoppingCartDataDelegate{
    func didShoppingCartDataUpdated() {
        let totalCost = ShoppingCartData.shared.getTotalCost()
        totalCostLabel.text = "₺ " + String(format: "%.2f",totalCost)
        shoppingTableView.reloadData()
    }
}
