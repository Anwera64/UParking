//
//  EstacionamientoManager.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/16/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class EstacionamientoManager {
    
    private let rootRef: DatabaseReference
    private let delegate: EstacionamientoDelegate
    var spaces: [ParkingSpace] = []
    let dsm = DataStorageManager()
    
    init(objectReference: DatabaseReference, delegate: EstacionamientoDelegate) {
        self.rootRef = objectReference
        self.delegate = delegate
    }
    
    func getSpaces() {
        rootRef.child("spaces").observe(.value) { (snapshot) in
            self.spaces.removeAll()
            let objects = snapshot.children.allObjects
            var counter = 0
            for object in objects {
                if let spaceItem = object as? DataSnapshot, let space = ParkingSpace(snapshot: spaceItem, id: counter) {
                    self.spaces.append(space)
                }
                counter += 1
            }
            self.delegate.setSpaces(with: self.spaces)
        }
    }
    
    func reserveSpace(space: ParkingSpace) {
        let spaceRef = rootRef.child("spaces/\(space.pos)")
        var values: [String: Any] = Dictionary()
        values["reservado"] = space.reserved
        values["usuario"] = space.user
        values["limpieza"] = space.cleaning
        spaceRef.updateChildValues(values)
        dsm.saveSpace(space: spaceRef.ref.description())
    }
    
    func destroyListeners() {
        rootRef.removeAllObservers()
    }
}

protocol EstacionamientoDelegate {
    func setSpaces(with spaces: [ParkingSpace])
}
