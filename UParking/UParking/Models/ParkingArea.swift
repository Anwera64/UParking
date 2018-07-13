//
//  ParkingArea.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/13/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ParkingArea: Codable {
    var name: String
    var items: [ParkingSpace]
    var type: String
    
    init(name: String, with items: [ParkingSpace], at area: String) {
        self.name = name
        self.items = items
        self.type = area
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["nombreEspacio"] as? String,
            let type = value["tipoArea"] as? String else {
                return nil
        }
        
        self.name = name
        self.type = type
        self.items = Array()
        
        let objects = snapshot.childSnapshot(forPath: "spaces").children.allObjects
        for object in objects {
            if let spaceItem = object as? DataSnapshot, let space = ParkingSpace(snapshot: spaceItem) {
                items.append(space)
            }
        }
    }
}

