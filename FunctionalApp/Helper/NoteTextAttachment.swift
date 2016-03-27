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
        }
    }
//    override func imageForBounds(imageBounds: CGRect, textContainer: NSTextContainer?, characterIndex charIndex: Int) -> UIImage? {
//        let image = super.imageForBounds(imageBounds, textContainer: textContainer, characterIndex: charIndex)
//        NSLog("imageBounds \(imageBounds)")
//        NSLog("textContainer \(textContainer?.size)")
//        if let containerSize = textContainer?.size where imageBounds.size.width > textContainer?.size.width{
//            return image?.imageWithMaxWidth(containerSize.width)
//        }
//        return image
//    }
//
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
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        if let imgSize = self.imageSize{
            aCoder.encodeCGSize(imgSize, forKey: "imageSize")
        }
        if let imgPath = self.imageName{
            aCoder.encodeObject(imgPath, forKey: "imageName")
        }
    }
    
    var imageSize : CGSize?
    var imageName : String?
    override func attachmentBoundsForTextContainer(textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        var curRect = super.attachmentBoundsForTextContainer(textContainer, proposedLineFragment: lineFrag, glyphPosition: position, characterIndex: charIndex)
        NSLog("textContainer \(textContainer?.size)")
        NSLog("curRect \(curRect)")
        NSLog("curImage \(image)")
        NSLog("imageSize \(imageSize)")
        if let containerSize = textContainer?.size, imgSize = self.imageSize{
            curRect.size.width = containerSize.width
            curRect.size.height = (containerSize.width/imgSize.width) * imgSize.height
        }
        return curRect
    }
}
