//
//  EstacionamientoViewController.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/16/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EstacionamientoViewController: UIViewController, ParkingSpaceViewDelegate, EstacionamientoDelegate {
    
    static let identifier = "EstacionamientoViewController"
    
    var spaces: Int!
    var objectReference: DatabaseReference!
    var selectedSpace: Int?
    private var manager: EstacionamientoManager!
    
    @IBOutlet weak var unusedReservesView: UILabel!
    @IBOutlet weak var spaceTextView: UILabel!
    @IBOutlet weak var invitedSwitchView: UISwitch!
    @IBOutlet weak var invitedDocTextField: UITextField!
    @IBOutlet weak var cleaningSwitchView: UISwitch!
    @IBOutlet weak var spacesBackgroundView: ParkingSpaceView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        spacesBackgroundView.spaces = spaces
        spacesBackgroundView.delegate = self
        manager = EstacionamientoManager(objectReference: objectReference, delegate: self)
        manager.getSpaces()
    }
    
    @IBAction func onReserve(_ sender: UIButton) {
        guard let number = selectedSpace else {
            print("no selected space")
            let alert = AlertUtil.simpleAlert(title: "Advertencia", detail: "Tienes que seleccionar un espacio para reservar")
            self.present(alert, animated: true)
            return
        }
        let cleaning = cleaningSwitchView.isOn
        var user: String
        if invitedSwitchView.isOn, let txt = invitedDocTextField.text {
            user = txt
        } else {
            guard let mobileUser = DataStorageManager().fetchUser() else {
                print("usuario invalido")
                return
            }
            user = mobileUser.uid!
        }
        manager.reserveSpace(space: ParkingSpace(occupied: true, cleaning: cleaning, by: user, pos: number-1))
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onInvitadoSwitched(_ sender: Any) {
        if invitedSwitchView.isOn {
            invitedDocTextField.isHidden = false
        } else {
            invitedDocTextField.isHidden = true
        }
    }
    
    func onSpaceSelected(over id: String) {
        spaceTextView.text = "Espacio: \(id)"
        selectedSpace = Int(id)
    }
    
    func setSpaces(with spaces: [ParkingSpace]) {
        spaces.forEach { (space) in
            spacesBackgroundView.setOccupied(positionAt: space.pos, occupied: space.occupied)
        }
    }
    
    deinit {
        manager.destroyListeners()
    }
    
}
