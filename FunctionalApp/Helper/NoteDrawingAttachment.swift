//
//  NoteDrawingAttachment.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 26/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

class NoteDrawingAttachment: NoteTextAttachment {
    var drawingBounds = CGRectZero
    var canvasSize = CGSizeZero
    
    override init(data contentData: NSData?, ofType uti: String?) {
        super.init(data: contentData, ofType: uti)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawingBounds = aDecoder.decodeCGRectForKey("drawingBounds")
        canvasSize = aDecoder.decodeCGSizeForKey("canvasSize")
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeCGRect(drawingBounds, forKey: "drawingBounds")
        aCoder.encodeCGSize(canvasSize, forKey: "canvasSize")
    }
    
}
