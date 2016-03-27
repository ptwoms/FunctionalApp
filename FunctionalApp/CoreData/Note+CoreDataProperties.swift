//
//  Note+CoreDataProperties.swift
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

extension Note {

    @NSManaged var title: String?
    @NSManaged var content: NSAttributedString?
    @NSManaged var created_at: NSDate?
    @NSManaged var updated_at: NSDate?
    @NSManaged var note_id: String?
    @NSManaged var in_notebook: Notebook?
    @NSManaged var photos: NSSet?

}
