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
    
    func imageFitToSize(fitSize : CGFloat) -> UIImage?{
        var scaleFactor :CGFloat = 1.0
        if size.width > size.height{
            scaleFactor = size.height/fitSize
        }else{
            scaleFactor = size.width/fitSize
        }
        if CGImage != nil{
            return UIImage(CGImage: self.CGImage!, scale: scaleFactor, orientation: self.imageOrientation)
        }else if CIImage != nil{
            return UIImage(CIImage: self.CIImage!, scale: scaleFactor, orientation: self.imageOrientation)
        }else{
            return nil//return self image if we can't find any of them
        }
    }
    
    func resizeImageToSize(fitSize : CGFloat) -> UIImage?{
        let screenScale = UIScreen.mainScreen().scale
        var newSize = CGSizeZero
        if size.width > size.height{
            newSize.height = fitSize * screenScale
            newSize.width = size.width * (newSize.height/size.height)
        }else{
            newSize.width = fitSize * screenScale
            newSize.height = size.height * (newSize.width/size.width)
        }
        if let cgImage = CGImage{
            let bitsPerComp = CGImageGetBitsPerComponent(cgImage)
            let bytesPerRow = CGImageGetBytesPerRow(cgImage)
            var contextRef = CGBitmapContextCreate(nil, Int(newSize.width), Int(newSize.height), bitsPerComp, bytesPerRow, CGImageGetColorSpace(cgImage), CGImageGetBitmapInfo(cgImage).rawValue)
            if contextRef == nil{
                contextRef = CGBitmapContextCreate(nil, Int(newSize.width), Int(newSize.height), 8, 0, CGColorSpaceCreateDeviceRGB(), CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Big.rawValue)
            }
            CGContextSetInterpolationQuality(contextRef, CGInterpolationQuality.High)
            CGContextDrawImage(contextRef, CGRect(origin: CGPointZero, size: newSize), cgImage)
            return CGBitmapContextCreateImage(contextRef).flatMap{
                return UIImage(CGImage: $0, scale: self.scale, orientation: self.imageOrientation)
            }
        }
        return nil
    }
    
    func normalizeOrientation() -> UIImage{
        if (imageOrientation == .Up){
            return self
        }
        let alpha = CGImageGetAlphaInfo(CGImage)
        UIGraphicsBeginImageContextWithOptions(size, (alpha == .First || alpha == .Last || alpha == .PremultipliedFirst || alpha == .PremultipliedLast), scale)
        drawInRect(CGRect(origin: CGPointZero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage;
    }
    
    func clipToRect(clipRect : CGRect) -> UIImage {
        if let clippedImage = CGImageCreateWithImageInRect(CGImage, clipRect){
            return UIImage(CGImage: clippedImage)
        }
        return self
    }
    
    func resizeImageToRatio(ratio : CGFloat) -> UIImage? {
        if let cgImage = CGImage{
            let origWidth = CGImageGetWidth(cgImage)
            let newWidth = CGFloat(origWidth) * ratio
            let newHeight = CGFloat(CGImageGetHeight(cgImage)) * ratio
            let bitsPerComp = CGImageGetBitsPerComponent(cgImage)
            let bytesPerRow = CGImageGetBytesPerRow(cgImage)
            var contextRef = CGBitmapContextCreate(nil, Int(newWidth), Int(newHeight), bitsPerComp, bytesPerRow, CGImageGetColorSpace(cgImage), CGImageGetBitmapInfo(cgImage).rawValue)
            if contextRef == nil{
                contextRef = CGBitmapContextCreate(nil, Int(newWidth), Int(newHeight), 8, 0, CGColorSpaceCreateDeviceRGB(), CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Big.rawValue)
            }
            CGContextSetInterpolationQuality(contextRef, CGInterpolationQuality.High)
            CGContextDrawImage(contextRef, CGRect(origin: CGPointZero, size: CGSize(width: newWidth, height: newHeight)), cgImage)
            return CGBitmapContextCreateImage(contextRef).flatMap{
                return UIImage(CGImage: $0, scale: self.scale, orientation: self.imageOrientation)
            }
        }
        return nil
    }
    
    static func createImageForSize(imageSize : CGSize, subImage: UIImage, subImageBounds : CGRect) -> UIImage? {
        let width = Int(imageSize.width)
        let height = Int(imageSize.height)
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let contextRef = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerPixel * width, colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Big.rawValue)
        var newImageBounds = subImageBounds
        newImageBounds.origin.y = imageSize.height - subImageBounds.origin.y - subImageBounds.size.height
        CGContextDrawImage(contextRef, newImageBounds, subImage.CGImage)
        return CGBitmapContextCreateImage(contextRef).flatMap { UIImage(CGImage: $0) }
    }
}
