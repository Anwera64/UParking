//
//  EstacionamientosTableViewCell.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/12/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import UIKit

class EstacionamientosTableViewCell: UICollectionViewCell {
    
    
    static public let identifier = "EstacionamientosTableViewCell"
    
    @IBOutlet weak var imageParkingView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var freeSpacesView: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 15
        self.layer.masksToBounds = true
    }

}
