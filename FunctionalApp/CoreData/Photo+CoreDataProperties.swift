//
//  Photo+CoreDataProperties.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 14/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var fileName: String?
    @NSManaged var name: String?
    @NSManaged var photo_info: String?
    @NSManaged var in_note: NSManagedObject?

}
