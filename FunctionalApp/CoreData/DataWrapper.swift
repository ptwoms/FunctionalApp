//
//  DataWrapper.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 16/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit
import CoreData

class DataWrapper {
    static func getAllNotebooks() -> [Notebook]?{
        let request = NSFetchRequest(entityName: "Notebook")
        return try! AppDelegate.sharedAppDelegate.managedObjectContext.executeFetchRequest(request) as? [Notebook]
    }
}
