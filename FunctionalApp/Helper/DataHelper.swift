//
//  DataHelper.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 29/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import Foundation
import CoreData

class DataHelper {
    static func getAllNotebooks() -> [Notebook]?{
        let request = NSFetchRequest(entityName: "Notebook")
        let nameSorting = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [nameSorting]
        return try! AppDelegate.sharedAppDelegate.managedObjectContext.executeFetchRequest(request) as? [Notebook]
    }
    
    static func getNotebookWithName(notebookName : String) -> Notebook?{
        let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext
        let request = managedObjectContext.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplateWithName("hasNotebookWithName", substitutionVariables: ["newName":notebookName])
        if let result = try? managedObjectContext.executeFetchRequest(request!) where result.count > 0{
            return result.first as? Notebook
        }
        return nil
    }
    
    static func hasNotebookWithName(notebookName : String) -> Bool{
        return getNotebookWithName(notebookName) != nil
    }
    
    static func saveNotebookWithName(notebookName : String) -> Notebook?{
        let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Notebook", inManagedObjectContext: managedObjectContext)
        let notebook = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext) as! Notebook
        notebook.setValue(notebookName, forKey: "name")
        if let _ = try? managedObjectContext.save(){
            return notebook
        }
        return nil
    }
}
