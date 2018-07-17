//
//  ParkingSpaceNotifierUtil.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/17/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ParkingSpaceNotifierUtil {
    
    private var rootRef = Database.database().reference()
    private var handle: UInt!
    private var arrived: Bool = false {
        didSet {
            if arrived {
                rootRef.removeObserver(withHandle: handle)
                if let controller = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController() {
                    let alert = AlertUtil.simpleAlert(title: "Bienvenido", detail: "Has llegado a tu reserva")
                    controller.present(alert, animated: true)
                }
            }
        }
    }

    public func hasReserved() {
        guard let user = DataStorageManager().fetchUser(), let occupiedSpace = user.occupiedSpace else {
            print("usuario invalido en notificacion")
            return
        }
        
        let route = String(occupiedSpace.suffix(occupiedSpace.count - 45))
        handle = rootRef.child(route).observe(.value, with: { snapshot in
            guard let space: ParkingSpace = ParkingSpace(snapshot: snapshot, id: nil) else {
                print("Wrong space item. Returns nil")
                return
            }
            self.arrived = space.occupied
        })
    }
}

//Codigo obtenido de un foro de Github.
//Link: https://gist.github.com/db0company/369bfa43cb84b145dfd8
extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
