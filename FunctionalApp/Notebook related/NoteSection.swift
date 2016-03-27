//
//  NoteSection.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 16/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

enum NoteSectionType{
    case Text
    case Photo
}

class NoteSection {
    let noteSectionType : NoteSectionType
    var content : String
    
    init(noteSectionType : NoteSectionType, content : String){
        self.noteSectionType = noteSectionType
        self.content = content
    }
}
