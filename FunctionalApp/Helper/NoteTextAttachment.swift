//
//  NoteTextAttachment.swift
//
//
//  Created by Pyae Phyo Myint Soe on 16/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

class NoteTextAttachment: NSTextAttachment {
    override var image : UIImage?{
        didSet{
            self.imageSize = image?.size
            self.imageScale = image?.scale == nil ? 1 : Float(image!.scale)
        }
    }
    
    override init(data contentData: NSData?, ofType uti: String?) {
        super.init(data: contentData, ofType: uti)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if aDecoder.containsValueForKey("imageSize"){
            self.imageSize = aDecoder.decodeCGSizeForKey("imageSize")
        }
        if aDecoder.containsValueForKey("imageName"){
            self.imageName = aDecoder.decodeObjectForKey("imageName") as? String
        }
        if aDecoder.containsValueForKey("imageScale"){
            self.imageScale = aDecoder.decodeFloatForKey("imageScale")
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        if let imgSize = self.imageSize{
            aCoder.encodeCGSize(imgSize, forKey: "imageSize")
        }
        if let imgPath = self.imageName{
            aCoder.encodeObject(imgPath, forKey: "imageName")
        }
        aCoder.encodeFloat(imageScale, forKey: "imageScale")
    }
    
    var imageSize : CGSize?
    var imageScale : Float = 1
    var imageName : String?
    override func attachmentBoundsForTextContainer(textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        var curRect = super.attachmentBoundsForTextContainer(textContainer, proposedLineFragment: lineFrag, glyphPosition: position, characterIndex: charIndex)
        if let containerSize = textContainer?.size, imgSize = self.imageSize{
            curRect.size.width = containerSize.width-10//minus lineFragmentPadding
            curRect.size.height = (curRect.size.width/imgSize.width) * imgSize.height
        }
        return curRect
    }
}
