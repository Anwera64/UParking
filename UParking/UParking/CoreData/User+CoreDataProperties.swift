//
//  User+CoreDataProperties.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/12/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var parked: Bool 
    @NSManaged public var reserves: Int32
    @NSManaged public var uid: String?
    @NSManaged public var occupiedSpace: String? 

}
