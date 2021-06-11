//
//  AddressCellTableViewCell.swift
//  GetirReplika
//
//  Created by Metilli on 8.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class AddressCellTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true

        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
