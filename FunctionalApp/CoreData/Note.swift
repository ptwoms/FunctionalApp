//
//  Note.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 14/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import Foundation
import CoreData


class Note: NSManagedObject {
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        if let allAttachments = content?.getAllAttachments(){
            for curAttachment in allAttachments{
                CommonHelper.deletePhotoWithName(curAttachment.imageName)
            }
        }
        if let noOfNote = in_notebook?.numberOfNotes?.intValue where noOfNote > 0{
            in_notebook?.numberOfNotes = noOfNote - 1
        }else{
            in_notebook?.numberOfNotes =  0
        }
    }
    
    func getTitle() -> String {
        return title == nil ? "" : title!
    }

}
