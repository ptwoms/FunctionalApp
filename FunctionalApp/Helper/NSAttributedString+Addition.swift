//
//  NSAttributedString+Addition.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 16/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

extension NSAttributedString{
    func getAllAttachments() -> [NoteTextAttachment]? {
        return getAllAttachmentsInRange(NSMakeRange(0, length))
    }
    
    func getFirstStrippedCharacters(count : Int) -> String {
        var curIndex = 0
        let finalLoc = self.length
        var rangePtr = NSRange()
        var finalString = ""
        while curIndex < finalLoc {
            let attributes = attributesAtIndex(curIndex, effectiveRange: &rangePtr)
            if (attributes[NSAttachmentAttributeName] as? NSTextAttachment) == nil{
                let firstIndex = string.startIndex.advancedBy(rangePtr.location)
                let endIndex = firstIndex.advancedBy(rangePtr.length)
                let strOfInterest = string.substringWithRange(firstIndex..<endIndex)
                if finalString == ""{
                    let firstStr = ((strOfInterest + "a").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
                    finalString = firstStr.substringToIndex(firstStr.endIndex.predecessor())
                }else{
                    finalString = finalString + strOfInterest
                }
                if finalString.characters.count >= count{
                    return finalString.substringToIndex(finalString.startIndex.advancedBy(count))
                }
            }
            curIndex = rangePtr.location + rangePtr.length
        }
        return finalString
    }
    
    func getAllAttachmentsInRange(range : NSRange) -> [NoteTextAttachment]? {
        var curIndex = range.location
        let finalLoc = range.location + range.length
        if length > 0 && curIndex < length{
            var allAttachments = [NoteTextAttachment]()
            var rangePtr = NSRange()
            repeat{
                let attributes = attributesAtIndex(curIndex, effectiveRange: &rangePtr)
                if let attachment = attributes[NSAttachmentAttributeName] as? NoteTextAttachment{
                    allAttachments.append(attachment)
                }
                curIndex = rangePtr.location + rangePtr.length
            }while curIndex < length && curIndex < finalLoc
            return allAttachments
        }
        return nil
    }
    
    func getFirstAttachment() -> NoteTextAttachment? {
        var curIndex = 0
        let finalLoc = self.length
        if length > 0 && curIndex < length{
            var rangePtr = NSRange()
            repeat{
                let attributes = attributesAtIndex(curIndex, effectiveRange: &rangePtr)
                if let attachment = attributes[NSAttachmentAttributeName] as? NoteTextAttachment{
                    return attachment
                }
                curIndex = rangePtr.location + rangePtr.length
            }while curIndex < finalLoc
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
}