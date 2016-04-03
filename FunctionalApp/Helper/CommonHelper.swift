//
//  CommonHelper.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 14/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

class CommonHelper: NSObject {
    
    static func showAlertWithTitle(titleStr : String?, andDescription : String, okHandler : ((Void) -> Void)? = nil){
        let alertCtrl = UIAlertController(title: titleStr, message: andDescription, preferredStyle: UIAlertControllerStyle.Alert)
        alertCtrl.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.Cancel, handler:{ (action) -> Void in
            okHandler?()
        }))
        var alertWindow : UIWindow?
        alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        alertWindow?.rootViewController = UIViewController()
        alertWindow?.windowLevel = UIWindowLevelAlert
        alertWindow?.makeKeyAndVisible()
        alertWindow?.rootViewController?.presentViewController(alertCtrl, animated: true, completion: nil)
    }
    
    static func showAlertWithTitle(titleStr : String?, andDescription : String, okHandler: ((Void) -> Void)?, cancelHandler: ((Void) -> Void)?){
        let alertCtrl = UIAlertController(title: titleStr, message: andDescription, preferredStyle: UIAlertControllerStyle.Alert)
        alertCtrl.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            okHandler?()
        }))
        alertCtrl.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            cancelHandler?()
        }))
        var alertWindow : UIWindow?
        alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        alertWindow?.rootViewController = UIViewController()
        alertWindow?.windowLevel = UIWindowLevelAlert
        alertWindow?.makeKeyAndVisible()
        alertWindow?.rootViewController?.presentViewController(alertCtrl, animated: true, completion: nil)
    }
    
    /* Photo Related */
    static func deletePhotoWithName(imageName : String?) -> Bool{
        if let curImgName = imageName, imagesFolderPath = getPhotoFolder(){
            do{
                let fileManager = NSFileManager.defaultManager()
                try fileManager.removeItemAtPath(imagesFolderPath + "/" + curImgName)
                if let thumbFolder = getThumbPhotoFolder(){
                    try fileManager.removeItemAtPath(thumbFolder + "/" + curImgName)
                }
                return true
            }catch{
                
            }
        }
        return false
    }
    
    static func getThumbnailPhotoWithName(imageName : String?) -> UIImage?{
        if let curImgName = imageName, imagesFolderPath = getThumbPhotoFolder(){
            return UIImage(contentsOfFile: imagesFolderPath + "/" + curImgName)?.imageFitToSize(GlobalConstants.noteThumbnailSize)
        }
        return nil
    }
    
    static func getPhotoFolder() -> String?{
        if let documentFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first{
            return (documentFolder as NSString).stringByAppendingPathComponent("images")
        }
        return nil
    }
    
    static func getThumbPhotoFolder() -> String?{
        if let documentFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first{
            return (documentFolder as NSString).stringByAppendingPathComponent("images/thumbnails/")
        }
        return nil
    }
    
    static func createFlolderIfNecessary(folderPath : String) throws{
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(folderPath){
            try fileManager.createDirectoryAtPath(folderPath, withIntermediateDirectories: false, attributes: nil)
        }
    }
    
    static func savePhotoToLocalDirectory(imageToSave : UIImage) -> String?{
        if let imagesFolderPath = getPhotoFolder(), thumbnailFolderPath = getThumbPhotoFolder(){
            do{
               try createFlolderIfNecessary(imagesFolderPath)
               try createFlolderIfNecessary(thumbnailFolderPath)
            }catch{
                return nil
            }
            
            let newPhotoName = getNewUniquePhotoName()
            if let thumbImage = imageToSave.resizeImageToSize(GlobalConstants.noteThumbnailSize){
                let thumbnailData = UIImagePNGRepresentation(thumbImage)
                thumbnailData?.writeToFile(thumbnailFolderPath + "/" + newPhotoName, atomically: true)
            }
            
            let pngData = UIImagePNGRepresentation(imageToSave)
            if let _ = pngData?.writeToFile(imagesFolderPath + "/" + newPhotoName, atomically: true){
                return newPhotoName
            }
        }
        return nil
    }
    
    static func getNewUniquePhotoName() -> String{
        return  NSUUID().UUIDString + ".png"
    }

}
