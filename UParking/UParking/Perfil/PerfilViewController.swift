//
//  PerfilViewController.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/10/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {
    
    @IBOutlet weak var codeView: UILabel!
    @IBOutlet weak var reservesView: UILabel!
    
    static public let ID = "PerfilView"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let user = DataStorageManager().fetchUser()
        codeView.text = user!.uid
        reservesView.text = String(user!.reserves)
    }
    
    @IBAction func onLogout(_ sender: UIButton) {
        DataStorageManager().logout()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyboard.instantiateInitialViewController()!
        present(loginController, animated: true)
    }
    
}
