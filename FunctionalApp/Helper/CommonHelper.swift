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
    
    static func deletePhotoWithName(imageName : String?) -> Bool{
        if let curImgName = imageName, imagesFolderPath = getPhotoFolder(){
            do{
                try NSFileManager.defaultManager().removeItemAtPath(imagesFolderPath + "/" + curImgName)
                return true
            }catch{
                
            }
        }
        return false
    }
    
    static func getPhotoFolder() -> String?{
        if let documentFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first{
            return (documentFolder as NSString).stringByAppendingPathComponent("images")
        }
        return nil
    }
    
    static func savePhotoToLocalDirectory(imageToSave : UIImage) -> String?{
        if let imagesFolderPath = getPhotoFolder(){
            let fileManager = NSFileManager.defaultManager()
            if !fileManager.fileExistsAtPath(imagesFolderPath){
                do{
                    try fileManager.createDirectoryAtPath(imagesFolderPath, withIntermediateDirectories: false, attributes: nil)
                }catch{
                    return nil
                }
            }
            let pngData = UIImagePNGRepresentation(imageToSave)
            let newPhotoName = getNewUniquePhotoName()
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
