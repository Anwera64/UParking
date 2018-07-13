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
    
    public func fetchUser() -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        // TODO: - implementar throw
        var result: [User] = Array()
        
        context?.performAndWait {
            result = try! fetchRequest.execute()
        }
        
        // TODO: - implementar throw
        guard let object = result.first else {
            print("No retorno objetos")
            return nil
        }
        return object
    }
}
