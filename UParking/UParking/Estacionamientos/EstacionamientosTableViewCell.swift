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

}
