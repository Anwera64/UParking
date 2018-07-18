//
//  EstacionamientoViewController.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/16/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EstacionamientoViewController: UIViewController, ParkingSpaceViewDelegate, EstacionamientoDelegate, UITextFieldDelegate {
    
    static let identifier = "EstacionamientoViewController"
    
    var spaces: Int!
    var objectReference: DatabaseReference!
    var selectedSpace: Int?
    var mobileUser: User = DataStorageManager().fetchUser()!
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
        unusedReservesView.text = "Reservas restantes para esta semana: \(mobileUser.reserves)"
        manager = EstacionamientoManager(objectReference: objectReference, delegate: self)
        manager.getSpaces()
        let gesture: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(_:)))
        view.addGestureRecognizer(gesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc
    func closeKeyboard(_: UIGestureRecognizer? = nil) {
        invitedDocTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - invitedDocTextField.frame.origin.y + invitedDocTextField.frame.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //Al hacer click en el boton de reserva se ejecuta esta funcion.
    //Crea un ParkingSpace a partir de la informacion brindada por el usuario y lo pasa al manager.
    @IBAction func onReserve(_ sender: UIButton) {
        
        guard let number = selectedSpace else {
            print("no selected space")
            let alert = AlertUtil.simpleAlert(title: "Advertencia", detail: "Tienes que seleccionar un espacio para reservar")
            self.present(alert, animated: true)
            return
        }
        
        guard mobileUser.reserves > 0 else {
            print("usuario sin reservas")
            let alert = AlertUtil.simpleAlert(title: "Advertencia", detail: "No tienes mas reservas restantes para esta semana.")
            self.present(alert, animated: true)
            return
        }
        
        guard mobileUser.occupiedSpace == nil else {
            print("usuario con reserva en curso")
            let alert = AlertUtil.simpleAlert(title: "Advertencia", detail: "Ya tienes una reserva en efecto en estos momentos. Solo se acepta 1 reserva a la vez.")
            self.present(alert, animated: true)
            return
        }
        
        let cleaning = cleaningSwitchView.isOn
        var user: String
        if invitedSwitchView.isOn {
            guard let txt = invitedDocTextField.text?.trimmed() else {
                let alert = AlertUtil.simpleAlert(title: "Advertencia", detail: "Tienes que insertar el DNI del invitado en el campo correspondiente.")
                self.present(alert, animated: true)
                return
            }
            user = txt
        } else {
            user = mobileUser.uid!
        }
        manager.reserveSpace(space: ParkingSpace(occupied: false, cleaning: cleaning, by: user, pos: number-1, reserved: true))
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
            let situation = space.occupied || (space.reserved != nil ? space.reserved! : false)
            spacesBackgroundView.setOccupied(positionAt: space.pos, occupied: situation)
        }
    }
    
    deinit {
        manager.destroyListeners()
    }
    
}
