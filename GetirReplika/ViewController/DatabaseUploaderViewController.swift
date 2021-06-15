//
//  DatabaseUploaderViewController.swift
//  GetirReplika
//
//  Created by Metilli on 26.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Firebase

class DatabaseUploaderViewController: UIViewController {
    
    private var productArray: [ProductModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readLocalDatabase()
        uploadImages()
    }
    
    func uploadImages(){
        let storageRef = Firebase.Storage.storage().reference()
        
        for product in productArray
        {
            for i in 0...2
            {
                var imageName = ""
                if i == 0 {
                    imageName = product.imageName
                }else if i == 1{
                    imageName = product.imageName + "@2x"
                }else if i == 2{
                    imageName = product.imageName + "@3x"
                }
                let url2 = Bundle.main.url(forResource: imageName, withExtension: "png", subdirectory: "Products")
                
                // File located on disk
                let localFile = url2!
                
                // Create a reference to the file you want to upload
                let imageRef = storageRef.child("products/" + product.mainCategory + "/" + product.subCategory + "/" + imageName + ".png")
                
                // Upload the file to the path "images/rivers.jpg"
                let _ = imageRef.putFile(from: localFile, metadata: nil) { metadata, error in
                    guard let _ = metadata else {
                        if let error2 = error {
                            print(error2)
                        }
                        return
                    }
                    if let error2 = error {
                        print(error2)
                    }else{
                        imageRef.downloadURL { (URL, error) -> Void in
                            if (error != nil) {
                                // Handle any errors
                            } else {
                                if i == 0 {
                                    product.image1xURL = URL!.absoluteString
                                }else if i == 1{
                                    product.image2xURL = URL!.absoluteString
                                }else if i == 2{
                                    product.image3xURL = URL!.absoluteString
                                }
                                self.createFirestoreDocuments(product: product)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func createFirestoreDocuments(product: ProductModel){
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "ID": product.id,
            "mainCategory": product.mainCategory,
            "subCategory": product.subCategory,
            "name": product.name,
            "price": product.price,
            "priceDiscounted": product.priceDiscounted,
            "unit": product.unit,
            "description": product.productDescription,
            "imageName": product.imageName,
            "image1xURL": product.image1xURL,
            "image2xURL": product.image2xURL,
            "image3xURL": product.image3xURL
        ]
        db.collection("products").document(product.id).setData(data){ err in
            if let err = err{
                print(err)
            }else{
                print("Document saved successfully written! ID: " + product.id)
            }
        }
    }
    
    func readLocalDatabase(){
        let url = Bundle.main.path(forResource: "Book1", ofType: "csv")
        var ID = 0
        var allText = ""
        do {
            allText = try String(contentsOfFile: url!, encoding: String.Encoding.utf8)
            let lines = allText.split(separator: "\r\n")
            for line in lines {
                ID += 1
                let myProduct = ProductModel(ID: "", mainCategory: "", subCategory: "", name: "", price: "", priceDiscounted: "", unit: "", description: "", image1xURL: "", image2xURL: "", image3xURL: "",imageName: "",isFavorite: false)
                let columns = line.split(separator: ",").map(String.init)
                myProduct.id = String(ID)
                myProduct.mainCategory = columns[0]
                myProduct.subCategory = columns[1]
                myProduct.name = columns[2]
                myProduct.price = columns[3]
                myProduct.priceDiscounted = columns[4]
                myProduct.unit = columns[5]
                myProduct.productDescription = columns[6]
                myProduct.imageName = columns[7]
                productArray.append(myProduct)
            }
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
