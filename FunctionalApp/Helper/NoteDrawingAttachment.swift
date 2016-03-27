//
//  NoteDrawingAttachment.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 26/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

class NoteDrawingAttachment: NSTextAttachment {
    var drawingBound = CGRectZero
    var imageName : String?
    
    override init(data contentData: NSData?, ofType uti: String?) {
        super.init(data: contentData, ofType: uti)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.drawingBound = aDecoder.decodeCGRectForKey("drawingBound")
        if aDecoder.containsValueForKey("imageName"){
            self.imageName = aDecoder.decodeObjectForKey("imageName") as? String
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeCGRect(drawingBound, forKey: "drawingBound")
        if let imgPath = self.imageName{
            aCoder.encodeObject(imgPath, forKey: "imageName")
        }
    }
    
}
