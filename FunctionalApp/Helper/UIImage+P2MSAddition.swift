//
//  UIImage+P2MSAddition.swift
//
//
//  Created by Pyae Phyo Myint Soe on 18/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

extension UIImage{
    func imageWithMaxWidth(maxWidth : CGFloat) -> UIImage?{
        var scaleFactor :CGFloat = 1.0
        if size.width > maxWidth{
            scaleFactor = size.width/maxWidth
        }
        if CGImage != nil{
            return UIImage(CGImage: self.CGImage!, scale: scaleFactor, orientation: self.imageOrientation)
        }else if CIImage != nil{
            return UIImage(CIImage: self.CIImage!, scale: scaleFactor, orientation: self.imageOrientation)
        }else{
            return nil//return self image if we can't find any of them
        }
    }
}
