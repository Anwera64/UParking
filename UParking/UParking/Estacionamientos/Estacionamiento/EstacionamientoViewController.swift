//
//  EstacionamientoViewController.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/16/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import UIKit

class EstacionamientoViewController: UIViewController {
    
    @IBOutlet weak var unusedReservesView: UILabel!
    @IBOutlet weak var spaceTextView: UILabel!
    @IBOutlet weak var invitedSwitchView: UISwitch!
    @IBOutlet weak var invitedDocTextField: UITextField!
    @IBOutlet weak var cleaningSwitchView: UISwitch!
    @IBOutlet weak var spacesBackgroundView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func drawSpaces() {
        //Linea de arriba
        
    }

    @IBAction func onReserve(_ sender: UIButton) {
    }
}
