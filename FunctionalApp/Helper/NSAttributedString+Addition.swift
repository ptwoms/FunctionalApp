//
//  NSAttributedString+Addition.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 16/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

extension NSAttributedString{
    func getAllAttachmentsInRange(range : NSRange) -> [NoteTextAttachment]? {
        var curIndex = range.location
        let finalLoc = range.location + range.length
        if length > 0 && curIndex < length{
            var allAttachments = [NoteTextAttachment]()
            repeat{
                var rangePtr = NSRange()
                let attributes = attributesAtIndex(curIndex, effectiveRange: &rangePtr)
                if let attachment = attributes[NSAttachmentAttributeName] as? NoteTextAttachment{
                    print("Image in the selection \(attachment.imageName)")
                    allAttachments.append(attachment)
                }
                curIndex = rangePtr.location + rangePtr.length
            }while curIndex < length && curIndex < finalLoc
            return allAttachments
        }
        return nil
    }
    
    func deleteAllOriginalPhotoAttachments() {
        if let allAttachments = getAllAttachmentsInRange(NSMakeRange(0, length)){
            for curAttachment in allAttachments{
                CommonHelper.deletePhotoWithName(curAttachment.imageName)
            }
        }
    }
    
//    func resizeAllAttachments(contentMaxWidth : CGFloat){
//        if self.length > 0{
//            var curIndex : Int = 0
//            let maxRange = NSMakeRange(0, self.length)
//            repeat{
//                var rangePointer = NSRange()
//                let attributes = attributesAtIndex(curIndex, longestEffectiveRange: &rangePointer, inRange: maxRange)
//                NSLog("Attributes \(attributes)")
//                if let attachment = attributes[NSAttachmentAttributeName] as? NSTextAttachment, curImage = attachment.image{
//                    let imageSize = curImage.size
//                    if imageSize.width < contentMaxWidth{
//                        let resizeRatio = contentMaxWidth/imageSize.height
//                        var newBounds = attachment.bounds
//                        newBounds.size.width = contentMaxWidth
//                        newBounds.size.height = resizeRatio*imageSize.height
//                        attachment.bounds = newBounds
//                    }else{
//                    }
//                }
//                curIndex = rangePointer.location + rangePointer.length
//            }while curIndex < self.length
//        }
//    }
}