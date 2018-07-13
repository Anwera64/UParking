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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = DataStorageManager().fetchUser()
        codeView.text = user!.uid
        reservesView.text = String(user!.reserves)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
