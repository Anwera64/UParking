//
//  AlertUtils.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/10/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import Foundation
import UIKit

class AlertUtil {
    
    static func simpleAlert(title: String, detail: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: detail, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        return alert
    }
    
    static func welcomeAlert(title: String, detail: String, closure: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: detail, preferredStyle: .alert)
        let action = UIAlertAction(title: "Gracias", style: .cancel)
        let actionComplaint = UIAlertAction(title: "No soy yo", style: .destructive, handler: closure)
        alert.addAction(action)
        alert.addAction(actionComplaint)
        return alert
    }
}
