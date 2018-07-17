//
//  ViewController.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/9/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var codeView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = loginButton.frame.height / 7
        loginButton.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if DataStorageManager().fetchUser() != nil {
            onLogin()
        }
    }

    @IBAction func onClick(_ sender: Any) {
        guard let code = codeView.text?.trimmed(), let _ = passwordView.text?.trimmed() else {
            let alert = AlertUtil.simpleAlert(title: "Error", detail: "Tienes que ingresar codigo y contraseña")
            self.present(alert, animated: true)
            return
        }
        
        DataStorageManager().saveUser(with: code)
        onLogin()
    }
    
    //Se realiza la creacion de TabBar   y Navigation ViewControllers y se les asignan las views correspondientes. Despues se presenta el TabBar
    private func onLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let perfilViewController = storyboard.instantiateViewController(withIdentifier: PerfilViewController.ID) as! PerfilViewController
        perfilViewController.tabBarItem.title = "Perfil"
        let estacionamientosViewController = storyboard.instantiateViewController(withIdentifier: EstacionamientosViewController.identifier) as! EstacionamientosViewController
        estacionamientosViewController.navigationItem.title = "Estacionamientos"
        estacionamientosViewController.mode = 1
        
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = [estacionamientosViewController]
        navigationController.tabBarItem.title = "Estacionamientos"
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController, perfilViewController]
        
        present(tabBarController, animated: true)
    }
}

extension String {
    
    func trimmed() -> String? {
        let trimmed = self.trimmingCharacters(in: .whitespaces)
        return trimmed.count > 0 ? trimmed : nil
    }
}

