//
//  ParkingSpace.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/13/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ParkingSpace {
    var pos: Int
    var occupied: Bool
    var cleaning: Bool?
    var user: String?
    
    init(occupied: Bool, cleaning: Bool?, by user: String?, pos: Int) {
        self.occupied = occupied
        self.cleaning = cleaning
        self.user = user
        self.pos = pos
    }
    
    init?(snapshot: DataSnapshot, id: Int) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let occupied = value["ocupado"] as? Bool else {
                return nil
        }
        
        let cleaning = value["limpieza"] as? Bool
        let usuario = value["user"] as? String
        
        self.occupied = occupied
        self.user = usuario
        self.cleaning = cleaning
        self.pos = id
    }
}
