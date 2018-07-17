//
//  Store.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/12/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataStorageManager {
    
    let context: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("")
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    public func saveUser(with id: String) {
        
        context?.perform {
            // guardar
            let user = User(context: self.context!)
            user.parked = false
            user.reserves = 2
            user.uid = id
            try! self.context!.save()
        }
    }
    
    public func saveSpace(space: String) {
        let user = fetchUser()
        context?.performAndWait {
            user!.occupiedSpace = space
            user!.reserves -= 1
            try! self.context!.save()
            ParkingSpaceNotifierUtil().hasReserved()
        }
    }
    
    public func logout() {
        let user = fetchUser()!
        context?.performAndWait {
            self.context?.delete(user)
        }
    }
    
    public func removeReserve() {
        let user = fetchUser()!
        context?.perform {
            user.occupiedSpace = nil
            try! self.context?.save()
        }
    }
    
    public func fetchUser() -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        var result: [User] = Array()
        
        context?.performAndWait {
            result = try! fetchRequest.execute()
        }
        
        guard let object = result.first else {
            print("No retorno objetos")
            return nil
        }
        return object
    }
}
