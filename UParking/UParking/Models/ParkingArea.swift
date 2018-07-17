//
//  ParkingArea.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/13/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ParkingArea {
    var name: String
    var items: [ParkingSpace]
    var type: String
    var imgURLString: String?
    var imgAreaTypeURLString: String?
    var databaseReference: DatabaseReference?
    
    init(name: String, with items: [ParkingSpace], at area: String, imgURl: String, imgTypeAreaURL: String) {
        self.name = name
        self.items = items
        self.type = area
        self.imgURLString = imgURl
        self.imgAreaTypeURLString = imgTypeAreaURL
    }
    
    init?(snapshot: DataSnapshot, reference: DatabaseReference) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["nombreEspacio"] as? String,
            let type = value["tipoArea"] as? String else {
                return nil
        }
        
        self.imgURLString = value["urlImagen"] as? String
        self.imgAreaTypeURLString = value["urlImagenTipoArea"] as? String
        self.name = name
        self.type = type
        self.items = Array()
        self.databaseReference = reference
        
        let objects = snapshot.childSnapshot(forPath: "spaces").children.allObjects
        var counter = 0
        for object in objects {
            if let spaceItem = object as? DataSnapshot, let space = ParkingSpace(snapshot: spaceItem, id: counter) {
                items.append(space)
            }
            counter += 1
        }
    }
}

