//
//  EstacionamientosManager.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/13/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import Foundation
import FirebaseDatabase

class EstacionamientosManager {
    public var delegate: EstacionamientosDelegate!
    private let rootRef = Database.database().reference()
    public var filteredByTypeAreas = [String: [ParkingArea]]()
    
    init(with delegate: EstacionamientosDelegate) {
        self.delegate = delegate
    }
    
    public func getParkingSpaces() {
        rootRef.child("Data").observeSingleEvent(of: .value, with: { (snapshot) in
            let objects = snapshot.children.allObjects
            for object in objects {
                if let areaItem = object as? DataSnapshot, let area = ParkingArea(snapshot: areaItem) {
                    if self.filteredByTypeAreas[area.type] == nil {
                        self.filteredByTypeAreas[area.type] = Array()
                    }
                    self.filteredByTypeAreas[area.type]?.append(area)
                }
            }
            self.delegate.setParkingAreas(with: self.filteredByTypeAreas)
        })
    }
    
    public func getImage(with urlString: String, at index: IndexPath) {
        guard let url = URL(string: urlString) else {
            print("Invalid url")
            return
        }
        
        URLSession(configuration: .default).dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            if let d = data, let image = UIImage(data: d) {
                DispatchQueue.main.async {
                    self.delegate.imageReady(with: image, at: index)
                }
            }
        }).resume()
    }
}

protocol EstacionamientosDelegate {
    func setParkingAreas(with areas: [String: [ParkingArea]])
    
    func imageReady(with image: UIImage, at index: IndexPath)
}
