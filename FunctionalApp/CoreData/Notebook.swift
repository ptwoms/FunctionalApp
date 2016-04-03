//
//  Notebook.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 14/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import Foundation
import CoreData


class Notebook: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    func allNotesSortByDate() -> [Note]? {
        if let allNotes = notes?.allObjects as? [Note]{
            return allNotes.sort({ $0.updated_at!.compare($1.updated_at!) == .OrderedDescending })
        }
        return nil
    }
    
    func addNote(newNote : Note) {
        numberOfNotes = NSNumber(int: numberOfNotes!.intValue+1)
        mutableSetValueForKey("notes").addObject(newNote)
    }
    
    func deleteNote(noteToDelete : Note){
        AppDelegate.sharedAppDelegate.managedObjectContext.deleteObject(noteToDelete)
    }
    
    func moveNote(noteToMove : Note, toNotebook : Notebook){
        numberOfNotes = NSNumber(int: max(numberOfNotes!.intValue-1, 0))
        mutableSetValueForKey("notes").removeObject(noteToMove)
        toNotebook.addNote(noteToMove)
    }
    
    
}
